import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/receipt_item.dart';
import '../services/receipt_service.dart';
import 'Categories.dart';

class AndroidCompact2 extends StatefulWidget {
  final List<String> ocrLines;
  const AndroidCompact2({Key? key, required this.ocrLines}) : super(key: key);

  @override
  _AndroidCompact2State createState() => _AndroidCompact2State();
}

class _AndroidCompact2State extends State<AndroidCompact2> {
  late List<String> items;
  late List<bool> checked;
  final ReceiptService _receiptService = ReceiptService();
  final uuid = const Uuid();
  String? selectedCategory;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    items = filterAndFormatOcrText(widget.ocrLines);
    checked = List<bool>.filled(items.length, false);
  }

  // Parse OCR text to extract structured data
  List<String> filterAndFormatOcrText(List<String> lines) {
    List<String> formattedList = [];
    RegExp regex = RegExp(r"(.+?)\s+(\d+[.,]?\d*)\s?(USD|EUR|GBP|\$|€|£)?", caseSensitive: false);
    List<String> unwantedKeywords = ["TOTAL", "TAX", "SHOP", "ADDRESS", "STORE", "INVOICE", "DATE", "TIME"];

    for (var line in lines) {
      // Skip lines with unwanted keywords
      if (unwantedKeywords.any((word) => line.toUpperCase().contains(word))) {
        continue;
      }
      
      var match = regex.firstMatch(line);
      if (match != null) {
        String item = match.group(1)!.trim();  
        String price = match.group(2)!.trim(); 
        String currency = match.group(3) ?? "";
        formattedList.add("$item - $price $currency".trim());
      }
    }

    return formattedList.isNotEmpty ? formattedList : [];
  }

  // Extract item name, price and currency from formatted string
  Map<String, dynamic> _parseItemString(String itemString) {
    // Extract the price and currency from the end of the string
    RegExp priceRegex = RegExp(r"(\d+[.,]?\d*)\s?(USD|EUR|GBP|\$|€|£)?$");
    var priceMatch = priceRegex.firstMatch(itemString);
    
    String name = itemString;
    double price = 0.0;
    String currency = '';
    
    if (priceMatch != null) {
      // Get the price part
      String priceStr = priceMatch.group(1) ?? "0";
      price = double.tryParse(priceStr.replaceAll(',', '.')) ?? 0.0;
      
      // Get the currency part
      currency = priceMatch.group(2) ?? "";
      
      // Clean up currency symbols
      if (currency == "\$") currency = "USD";
      if (currency == "€") currency = "EUR";
      if (currency == "£") currency = "GBP";
      
      // Extract the name by removing the price part
      int endIndex = itemString.lastIndexOf(" - ");
      if (endIndex != -1) {
        name = itemString.substring(0, endIndex);
      }
    }
    
    return {
      'name': name,
      'price': price,
      'currency': currency,
    };
  }

  // Save selected items to the chosen category
  Future<void> _saveSelectedItems() async {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // Get selected items
      List<ReceiptItem> selectedItems = [];
      String receiptId = uuid.v4(); // Generate a unique ID for this receipt
      
      for (int i = 0; i < items.length; i++) {
        if (checked[i]) {
          var parsedItem = _parseItemString(items[i]);
          
          selectedItems.add(ReceiptItem(
            name: parsedItem['name'],
            price: parsedItem['price'],
            currency: parsedItem['currency'],
            category: selectedCategory!,
            dateAdded: DateTime.now(),
            receiptId: receiptId,
          ));
        }
      }
      
      if (selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No items selected')),
        );
        setState(() {
          isSaving = false;
        });
        return;
      }
      
      // Save the items
      await _receiptService.saveReceiptItems(selectedItems);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedItems.length} items saved to $selectedCategory'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Reset selection
        setState(() {
          checked = List<bool>.filled(items.length, false);
          selectedCategory = null;
          isSaving = false;
        });
      }
    } catch (e) {
      print('Error saving items: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving items: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CategoryManager categoryManager = CategoryManager();
    
    return Scaffold(
      body: Container(
        width: 360,
        height: 800,
        decoration: ShapeDecoration(
          color: const Color(0xFF86BBB2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                'Select Items:',
                style: TextStyle(color: Color(0xFF422655), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: checked[index],
                      onChanged: (bool? newValue) {
                        setState(() {
                          checked[index] = newValue ?? false;
                        });
                      },
                      title: Text(
                        items[index],
                        style: const TextStyle(color: Color(0xFF422655), fontSize: 16),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Category selection dropdown
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select a category'),
                  value: selectedCategory,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF422655)),
                  elevation: 16,
                  style: const TextStyle(color: Color(0xFF422655)),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: categoryManager.categoryNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(
                            categoryManager.getIconForCategory(value),
                            color: const Color(0xFF422655),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Save button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveSelectedItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF422655),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Selected Items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
