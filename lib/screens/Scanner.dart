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
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ReceiptUploader(
          geminiApi: 'YOUR_GEMINI_API_KEY', // Заменете с вашия API ключ или URL, ако е необходим
          listOfCategories: <String>["Храна", "Напитки", "Други"],
          onAdd: (Order order) {
            // При успешно разчитане, пренасочваме потребителя към екрана с избора на артикули
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptDetailsScreen(order: order),
              ),
            );
          },
          // Опционални параметри за стилизиране:
          actionButtonStyle: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
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
}

/// Този екран визуализира подробностите на разчетената касова бележка.
class ReceiptDetailsScreen extends StatelessWidget {
  final Order order;

  const ReceiptDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Тук показваме само основната информация: списък с артикули и общата сума.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заглавна секция за данни от касовата бележка
            const Text(
              'Данни за касовата бележка:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Можете да добавите допълнителни детайли, ако Order обектът ги предоставя.
            const SizedBox(height: 20),
            const Text(
              'Артикули:',
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
                    'Общо:',
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
          ],
        ),
      ),
    );
  }
}
