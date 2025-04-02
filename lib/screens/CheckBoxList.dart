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
  late List<String> selectedCategories;
  final StorageService _storageService = StorageService();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    items = filterAndFormatOcrText(widget.ocrLines);
    checked = List<bool>.filled(items.length, false);
    // Initialize a category for each item (defaulting to 'Food')
    selectedCategories = List<String>.filled(
      items.length, 
      CategoryUtils.getPredefinedCategories().first
    );
  }

  // Safely parse a price string with error handling
  double _safeParsePrice(String priceStr) {
    try {
      return double.parse(priceStr.replaceAll(',', '.'));
    } catch (e) {
      // Return 0 if parsing fails
      return 0.0;
    }
  }

  // Filtering and formatting OCR text
  List<String> filterAndFormatOcrText(List<String> lines) {
    List<String> formattedList = [];
    RegExp regex = RegExp(r"(.+?)\s+(\d+[.,]?\d*)\s?(USD|EUR|GBP|\$|€|£)?", caseSensitive: false);
    List<String> unwantedKeywords = ["TOTAL", "TAX", "SHOP", "ADDRESS", "STORE", "INVOICE", "DATE", "TIME"];

    for (var line in lines) {
      try {
        // Skip lines with unwanted words
        if (unwantedKeywords.any((word) => line.toUpperCase().contains(word))) {
          continue;
        }
        
        var match = regex.firstMatch(line);
        if (match != null) {
          String item = match.group(1)?.trim() ?? "Unknown Item";  
          String price = match.group(2)?.trim() ?? "0"; 
          String currency = match.group(3) ?? "";
          formattedList.add("$item - $price $currency".trim());
        }
      } catch (e) {
        // Skip items that cause exceptions during parsing
        print("Error parsing line: $line - $e");
      }
    }

    return formattedList.isNotEmpty ? formattedList : [];
  }

  // Convert display text to ReceiptItem objects
  List<ReceiptItem> _prepareItemsForSaving() {
    List<ReceiptItem> result = [];
    for (int i = 0; i < items.length; i++) {
      if (checked[i]) {
        try {
          // Parse the formatted text back
          String itemText = items[i];
          int separatorIndex = itemText.lastIndexOf('-');
          
          if (separatorIndex > 0) {
            String name = itemText.substring(0, separatorIndex).trim();
            String priceWithCurrency = itemText.substring(separatorIndex + 1).trim();
            
            // Extract price and currency
            RegExp priceRegex = RegExp(r"(\d+[.,]?\d*)\s?([^\d]*)");
            var priceMatch = priceRegex.firstMatch(priceWithCurrency);
            
            double price = 0.0;
            String currency = "";
            
            if (priceMatch != null) {
              // Safely parse price
              price = _safeParsePrice(priceMatch.group(1) ?? "0");
              currency = priceMatch.group(2)?.trim() ?? "";
            }
            
            result.add(ReceiptItem(
              name: name,
              price: price,
              currency: currency,
              category: selectedCategories[i],
              date: DateTime.now(),
            ));
          }
        } catch (e) {
          print("Error preparing item at index $i: $e");
          // Show error to user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error processing item: ${items[i]}')),
          );
        }
      }
    }
    return result;
  }

  // Add a new empty item
  void _addNewItem() {
    setState(() {
      items.add("New Item - 0.00 \$");
      checked.add(true);
      selectedCategories.add(CategoryUtils.getPredefinedCategories().first);
      
      // Scroll to the new item
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }
  
  // Edit an item
  void _editItem(int index) {
    // Parse existing item
    String itemText = items[index];
    int separatorIndex = itemText.lastIndexOf('-');
    
    String name = "New Item";
    String price = "0.00";
    String currency = "\$";
    
    if (separatorIndex > 0) {
      name = itemText.substring(0, separatorIndex).trim();
      String priceWithCurrency = itemText.substring(separatorIndex + 1).trim();
      
      // Extract price and currency
      RegExp priceRegex = RegExp(r"(\d+[.,]?\d*)\s?([^\d]*)");
      var priceMatch = priceRegex.firstMatch(priceWithCurrency);
      
      if (priceMatch != null) {
        price = priceMatch.group(1) ?? "0.00";
        currency = priceMatch.group(2)?.trim() ?? "\$";
      }
    }
    
    // Controllers for editing
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController priceController = TextEditingController(text: price);
    TextEditingController currencyController = TextEditingController(text: currency);
    
    // Show edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: currencyController,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Validate price input
              double? parsedPrice;
              try {
                parsedPrice = double.parse(priceController.text.replaceAll(',', '.'));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid price format')),
                );
                return;
              }
              
              // Update item
              setState(() {
                // Make sure parsedPrice is not null by providing a default value
                final double safePrice = parsedPrice ?? 0.0;
                String newItem = "${nameController.text} - ${safePrice.toStringAsFixed(2)} ${currencyController.text}";
                items[index] = newItem;
                checked[index] = true; // Auto-check edited items
              });
              
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  // Delete an item
  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                items.removeAt(index);
                checked.removeAt(index);
                selectedCategories.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  // Save selected items
  Future<void> _saveSelectedItems() async {
    setState(() {
      isSaving = true;
    });
    
    List<ReceiptItem> itemsToSave = _prepareItemsForSaving();
    
    if (itemsToSave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item to save')),
      );
      setState(() {
        isSaving = false;
      });
      return;
    }
    
    try {
      await _storageService.saveReceiptItems(itemsToSave);
      
      // Group items by category for the success message
      Map<String, int> categoryCount = {};
      for (var item in itemsToSave) {
        categoryCount[item.category] = (categoryCount[item.category] ?? 0) + 1;
      }
      
      String message = categoryCount.entries
          .map((e) => '${e.value} items to ${e.key}')
          .join(', ');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: $message')),
      );
      
      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving items: $e')),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }
  
  // Select all items
  void _selectAll(bool? value) {
    if (value != null) {
      setState(() {
        for (int i = 0; i < checked.length; i++) {
          checked[i] = value;
        }
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

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
                'Select Items',
                style: TextStyle(color: Color(0xFF422655), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select items and choose a category for each',
                style: TextStyle(color: Color(0xFF422655), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            
            // Controls bar (Select all + Add item)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Select all checkbox
                  if (items.isNotEmpty) ...[
                    Checkbox(
                      value: checked.isNotEmpty && checked.every((element) => element == true),
                      onChanged: _selectAll,
                      activeColor: const Color(0xFF422655),
                    ),
                    const Text(
                      'Select All',
                      style: TextStyle(
                        color: Color(0xFF422655),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Add item button
                  ElevatedButton.icon(
                    onPressed: _addNewItem,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF422655),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            size: 60,
                            color: Color(0xFFCCCCCC),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No items found',
                            style: TextStyle(
                              color: Color(0xFF422655),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add items manually or scan a receipt',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _addNewItem,
                            icon: const Icon(Icons.add),
                            label: const Text('Add New Item'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF422655),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                // Item name and checkbox
                                Row(
                                  children: [
                                    // Checkbox
                                    Checkbox(
                                      value: checked[index],
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          checked[index] = newValue ?? false;
                                        });
                                      },
                                      activeColor: const Color(0xFF422655),
                                    ),
                                    // Item details
                                    Expanded(
                                      child: Text(
                                        items[index],
                                        style: const TextStyle(
                                          color: Color(0xFF422655),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    // Edit button
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      color: Colors.blue,
                                      onPressed: () => _editItem(index),
                                      tooltip: 'Edit Item',
                                    ),
                                    // Delete button
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      color: Colors.red,
                                      onPressed: () => _deleteItem(index),
                                      tooltip: 'Delete Item',
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                
                                // Only show category dropdown if item is checked
                                if (checked[index])
                                  Padding(
                                    padding: const EdgeInsets.only(left: 56.0, right: 16.0, bottom: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: selectedCategories[index],
                                          items: CategoryUtils.getPredefinedCategories().map((String category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    CategoryUtils.getCategoryIcon(category),
                                                    color: CategoryUtils.getCategoryColor(category),
                                                    size: 20,
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
                                                selectedCategories[index] = newValue;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
