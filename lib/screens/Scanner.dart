import 'package:flutter/material.dart';
import 'package:receipt_reader/receipt_reader.dart';
import 'package:receipt_reader/models/order.dart';
import 'CheckBoxList.dart'; // Импортира OrderCheckboxList от CheckBoxList.dart

class ReceiptScanner extends StatelessWidget {
  const ReceiptScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Scanner'),
        backgroundColor: const Color(0xFF422655),
      ),
      body: Center(
        child: ReceiptUploader(
          geminiApi: 'AIzaSyBasOkoE5mOfZcLV7VMfn7kPaAgR1eZpo0', // Your API key
          listOfCategories: <String>["Food", "Transport", "Entertainment", "Shopping", "Bills", "Other"],
          onAdd: (Order order) {
            // Convert order items to OCR lines format
            List<String> ocrLines = _convertOrderToOcrLines(order);
            // Navigate to our new CheckBoxList implementation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AndroidCompact2(ocrLines: ocrLines),
              ),
            );
          },
          // Optional styling parameters:
          actionButtonStyle: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF422655),
            textStyle: const TextStyle(fontSize: 16),
          ),
          orderSummaryTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          extractedDataTextStyle:
              const TextStyle(fontSize: 14, color: Colors.grey),
          imagePreviewHeight: 250.0,
          padding: const EdgeInsets.all(20.0),
        ),
      ),
    );
  }
  
  // Helper method to convert Order to ocrLines format for our CheckBoxList
  List<String> _convertOrderToOcrLines(Order order) {
    List<String> lines = [];
    
    for (var item in order.items) {
      // Format: "Item name - price currency"
      double totalPrice = item.price * item.quantity;
      String formattedLine = "${item.name} - ${totalPrice.toStringAsFixed(2)} \$";
      lines.add(formattedLine);
    }
    
    return lines;
  }
}

/// This screen will not be used as we're using our new CheckBoxList implementation
/// But kept for reference or fallback use
class ReceiptDetailsScreen extends StatelessWidget {
  final Order order;

  const ReceiptDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Details'),
        backgroundColor: const Color(0xFF422655),
        actions: [
          // Add a button to proceed to our new categorization flow
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Categorize Items',
            onPressed: () {
              List<String> ocrLines = _convertOrderToOcrLines(order);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AndroidCompact2(ocrLines: ocrLines),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заглавна секция за данни от касовата бележка
            const Text(
              'Receipt Data:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Можете да добавите допълнителни детайли, ако Order обектът ги предоставя.
            const SizedBox(height: 20),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  // Изчисляваме общата цена за артикула: количество * цена
                  double totalItemPrice = item.quantity * item.price;
                  return ListTile(
                    title: Text('${item.quantity}x ${item.name}'),
                    trailing: Text('\$${totalItemPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            // Обща сума
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Използваме полето total, което съществува според примера
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Add button to proceed to categorization
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF422655),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  List<String> ocrLines = _convertOrderToOcrLines(order);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AndroidCompact2(ocrLines: ocrLines),
                    ),
                  );
                },
                child: const Text('Categorize Items', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to convert Order to ocrLines format for our CheckBoxList
  List<String> _convertOrderToOcrLines(Order order) {
    List<String> lines = [];
    
    for (var item in order.items) {
      // Format: "Item name - price currency"
      double totalPrice = item.price * item.quantity;
      String formattedLine = "${item.name} - ${totalPrice.toStringAsFixed(2)} \$";
      lines.add(formattedLine);
    }
    
    return lines;
  }
}
