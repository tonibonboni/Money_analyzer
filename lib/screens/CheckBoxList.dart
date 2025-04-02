import 'package:flutter/material.dart';
import '../models/receipt_item.dart';
import '../services/storage_service.dart';
import '../utils/category_utils.dart';

class AndroidCompact2 extends StatefulWidget {
  final List<String> ocrLines;
  const AndroidCompact2({Key? key, required this.ocrLines}) : super(key: key);

  @override
  _AndroidCompact2State createState() => _AndroidCompact2State();
}

class _AndroidCompact2State extends State<AndroidCompact2> {
  late List<String> items;
  late List<bool> checked;
  String selectedCategory = CategoryUtils.getPredefinedCategories().first;
  final StorageService _storageService = StorageService();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    items = filterAndFormatOcrText(widget.ocrLines);
    checked = List<bool>.filled(items.length, false);
  }

  // Filtering and formatting OCR text
  List<String> filterAndFormatOcrText(List<String> lines) {
    List<String> formattedList = [];
    RegExp regex = RegExp(r"(.+?)\s+(\d+[.,]?\d*)\s?(USD|EUR|GBP|\$|€|£)?", caseSensitive: false);
    List<String> unwantedKeywords = ["TOTAL", "TAX", "SHOP", "ADDRESS", "STORE", "INVOICE", "DATE", "TIME"];

    for (var line in lines) {
      // Skip lines with unwanted words
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

  // Convert display text to ReceiptItem objects
  List<ReceiptItem> _prepareItemsForSaving() {
    List<ReceiptItem> result = [];
    for (int i = 0; i < items.length; i++) {
      if (checked[i]) {
        // Parse the formatted text back
        String itemText = items[i];
        int separatorIndex = itemText.lastIndexOf('-');
        
        if (separatorIndex > 0) {
          String name = itemText.substring(0, separatorIndex).trim();
          String priceWithCurrency = itemText.substring(separatorIndex + 1).trim();
          
          // Extract price and currency
          RegExp priceRegex = RegExp(r"(\d+[.,]?\d*)\s?([^\d]*)");
          var priceMatch = priceRegex.firstMatch(priceWithCurrency);
          
          if (priceMatch != null) {
            double price = double.tryParse(priceMatch.group(1)!.replaceAll(',', '.')) ?? 0.0;
            String currency = priceMatch.group(2)?.trim() ?? "";
            
            result.add(ReceiptItem(
              name: name,
              price: price,
              currency: currency,
              category: selectedCategory,
              date: DateTime.now(),
            ));
          }
        }
      }
    }
    return result;
  }

  // Save selected items
  Future<void> _saveSelectedItems() async {
    setState(() {
      isSaving = true;
    });
    
    List<ReceiptItem> itemsToSave = _prepareItemsForSaving();
    
    await _storageService.saveReceiptItems(itemsToSave);
    
    setState(() {
      isSaving = false;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${itemsToSave.length} items saved to $selectedCategory')),
    );
    
    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(top: 50, bottom: 10),
              child: Text(
                'Select Items:',
                style: TextStyle(color: Color(0xFF422655), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Category dropdown
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCategory,
                  items: CategoryUtils.getPredefinedCategories().map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Row(
                        children: [
                          Icon(
                            CategoryUtils.getCategoryIcon(category),
                            color: CategoryUtils.getCategoryColor(category),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            category,
                            style: const TextStyle(color: Color(0xFF422655)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                ),
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
                child: items.isEmpty
                  ? const Center(
                      child: Text('No items found', style: TextStyle(color: Color(0xFF422655))),
                    )
                  : ListView.builder(
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
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: isSaving 
                  ? null 
                  : () => _saveSelectedItems(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF422655),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Items',
                      style: TextStyle(
                        color: Colors.white,
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
