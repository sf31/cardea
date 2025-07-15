import 'package:cardea/data/models/loyalty-card.model.dart';
import 'package:cardea/ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class LoyaltyCardManager extends StatefulWidget {
  final LoyaltyCard card;
  final bool isNewCard;

  const LoyaltyCardManager({
    super.key,
    required this.card,
    this.isNewCard = false,
  });

  @override
  State<LoyaltyCardManager> createState() => _LoyaltyCardManagerState();
}

class _LoyaltyCardManagerState extends State<LoyaltyCardManager> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();

  Color pickerColor = Color(0xff2de700);
  Color currentColor = Color(0xff2de700);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    currentColor = widget.card.color;
    _nameController.text = widget.card.name;
    _barcodeController.text = widget.card.barcode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   // showLabel: true, // only on portrait mode
            // ),
            child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final barcode = _barcodeController.text;

      Provider.of<LoyaltyCardViewModel>(context, listen: false).upsert(
        LoyaltyCard(
          id: widget.card.id,
          name: name,
          barcode: barcode,
          color: currentColor,
          usageCount: widget.card.usageCount,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _onDelete() {
    Provider.of<LoyaltyCardViewModel>(
      context,
      listen: false,
    ).removeById(widget.card.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isNewCard ? Text('Add Card') : Text('Edit Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PaddedItem(
                child: TextFormField(
                  onTapOutside: (evt) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Card Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              PaddedItem(
                child: TextFormField(
                  onTapOutside: (evt) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'Barcode',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              PaddedItem(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _pickColor,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: currentColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: _onDelete, child: const Text('Delete')),
                  ElevatedButton(onPressed: _onSave, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaddedItem extends StatelessWidget {
  final Widget child;

  const PaddedItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 16), child: child);
  }
}
