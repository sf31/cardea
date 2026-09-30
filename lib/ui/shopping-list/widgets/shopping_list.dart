import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list_done.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/widgets/settings.dart';
import '../shopping_item.viewmodel.dart';
import 'input_shopping_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  bool _showNewItem = false;
  ShoppingItem? _itemToEdit;
  final ScrollController _scrollController = ScrollController();

  ShoppingItemViewModel _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  void _showPersistenceError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.persistenceSaveError ?? ''),
      ),
    );
  }

  Future<bool> onNameChanged(String name, bool dismiss) async {
    final itemToEdit = _itemToEdit;
    bool success = true;

    if (name.isNotEmpty) {
      final vm = _getViewModel();
      if (itemToEdit == null) {
        success = await vm.upsert(ShoppingItem.fromName(name));
      } else {
        final newItem = itemToEdit.copyWith(name: name);
        success = await vm.upsert(newItem);
      }
      if (!mounted) return false;
      if (!success) {
        _showPersistenceError();
        return false;
      }
      if (itemToEdit != null) {
        setState(() {
          _itemToEdit = null;
          _showNewItem = false;
        });
      }
    }

    if (dismiss) {
      setState(() => _showNewItem = false);
    } else {
      _scrollToBottom();
    }
    return true;
  }

  void onItemEdit(ShoppingItem item) {
    if (_itemToEdit != null) return;
    setState(() => _showNewItem = true);
    setState(() => _itemToEdit = item);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_showNewItem) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _openCompleted() {
    final viewModel = _getViewModel();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder:
          (context) => ChangeNotifierProvider.value(
            value: viewModel,
            child: const FractionallySizedBox(
              heightFactor: 0.7,
              child: SafeArea(top: false, child: ShoppingListDone()),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isReady = context.select<ShoppingItemViewModel, bool>(
      (vm) => vm.isReady,
    );
    final completedCount = context.select<ShoppingItemViewModel, int>(
      (vm) => vm.itemListDone.length,
    );
    final completedLabel =
        l10n?.shoppingListCompletedSectionTitle(completedCount) ?? '';
    final compactActions =
        MediaQuery.sizeOf(context).width < 400 ||
        MediaQuery.textScalerOf(context).scale(14) > 18;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.shoppingListSectionTitle ?? ''),
        actions: [
          if (compactActions)
            IconButton(
              tooltip: completedLabel,
              onPressed: isReady && completedCount > 0 ? _openCompleted : null,
              icon: Badge.count(
                count: completedCount,
                isLabelVisible: completedCount > 0,
                child: const Icon(Icons.check_circle_outline),
              ),
            )
          else
            TextButton(
              onPressed: isReady && completedCount > 0 ? _openCompleted : null,
              child: Text(completedLabel),
            ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Settings()));
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<ShoppingItemViewModel>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  const CircularProgressIndicator(),
                  Text(l10n?.dataLoadingLabel ?? ''),
                ],
              ),
            );
          }
          if (provider.loadFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Text(
                      l10n?.dataLoadError ?? '',
                      textAlign: TextAlign.center,
                    ),
                    FilledButton(
                      onPressed: provider.loadItems,
                      child: Text(l10n?.retryBtnLabel ?? ''),
                    ),
                  ],
                ),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child:
                    provider.itemList.isEmpty
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              provider.itemListDone.isEmpty
                                  ? l10n?.shoppingListEmptyLabel ?? ''
                                  : l10n?.shoppingListAllDoneLabel ?? '',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            bottom:
                                _showNewItem
                                    ? 8
                                    : 56 + 2 * kFloatingActionButtonMargin,
                          ),
                          child: ShoppingListTodo(
                            onItemEdit: onItemEdit,
                            showNewItem: _showNewItem,
                          ),
                        ),
              ),
              if (_showNewItem) ...[
                const Divider(height: 1),
                SafeArea(
                  top: false,
                  child: InputShoppingItem(
                    onNameConfirm: onNameChanged,
                    focusLostCallback:
                        () => setState(() {
                          _showNewItem = false;
                          _itemToEdit = null;
                        }),
                    name: _itemToEdit?.name,
                  ),
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton:
          !isReady || _showNewItem
              ? null
              : FloatingActionButton.extended(
                onPressed: () {
                  setState(() => _showNewItem = true);
                  _scrollToBottom();
                },
                icon: const Icon(Icons.add),
                label: Text(l10n?.shoppingListNewItemBtn ?? ''),
              ),
    );
  }
}
