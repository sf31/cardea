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
  bool _showCompletedItems = false;
  ShoppingItem? _itemToEdit;
  final ScrollController _scrollController = ScrollController();

  ShoppingItemViewModel _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  void _showPersistenceError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Unable to save changes.')),
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
        _showPersistenceError(vm.errorMessage);
        return false;
      }
      if (itemToEdit != null) {
        setState(() {
          _itemToEdit = null;
          _showNewItem = false;
        });
      }
    }

    if (dismiss) setState(() => _showNewItem = false);
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
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.shoppingListSectionTitle ?? ''),
        actions: [
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
          if (provider.itemList.isEmpty &&
              provider.itemListDone.isEmpty &&
              !_showNewItem) {
            return Center(
              child: Text(
                l10n?.shoppingListEmptyLabel ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }
          _scrollToBottom();
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    bottom: _showNewItem ? 0 : kFloatingActionButtonMargin + 56,
                  ),
                  child: Column(
                    children: [
                      ShoppingListTodo(
                        onItemEdit: onItemEdit,
                        showNewItem: _showNewItem,
                      ),
                      if (provider.itemListDone.isNotEmpty)
                        Card(
                          margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: ExpansionTile(
                            initiallyExpanded: _showCompletedItems,
                            onExpansionChanged:
                                (expanded) => setState(
                                  () => _showCompletedItems = expanded,
                                ),
                            title: Text(
                              l10n?.shoppingListCompletedSectionTitle(
                                    provider.itemListDone.length,
                                  ) ??
                                  '',
                            ),
                            children: const [ShoppingListDone()],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (_showNewItem)
                InputShoppingItem(
                  onNameConfirm: onNameChanged,
                  focusLostCallback:
                      () => setState(() {
                        _showNewItem = false;
                        _itemToEdit = null;
                      }),
                  name: _itemToEdit?.name,
                )
              else
                SizedBox(),
            ],
          );
        },
      ),
      floatingActionButton:
          _showNewItem
              ? SizedBox()
              : FloatingActionButton.extended(
                onPressed: () => setState(() => _showNewItem = !_showNewItem),
                label: Text(l10n?.shoppingListNewItemBtn ?? ''),
                icon: const Icon(Icons.add),
              ),
    );
  }
}
