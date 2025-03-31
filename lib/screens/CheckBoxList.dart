import 'package:flutter/material.dart';
import 'package:receipt_reader/models/order.dart';

class OrderCheckboxList extends StatefulWidget {
  final Order order;
  const OrderCheckboxList({Key? key, required this.order}) : super(key: key);

  @override
  _OrderCheckboxListState createState() => _OrderCheckboxListState();
}

class _OrderCheckboxListState extends State<OrderCheckboxList> {
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    // Създаваме списък от булеви стойности за всеки артикул
    checked = List<bool>.filled(widget.order.items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избери артикули'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF86BBB2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'Избери артикули:',
                style: TextStyle(
                  color: Color(0xFF422655),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                child: ListView.builder(
                  itemCount: widget.order.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.order.items[index];
                    // Изчисляваме общата цена: количество * цена
                    double totalItemPrice = item.quantity * item.price;
                    String formattedText =
                        '${item.quantity}x ${item.name} - \$${totalItemPrice.toStringAsFixed(2)}';
                    return CheckboxListTile(
                      value: checked[index],
                      onChanged: (bool? newValue) {
                        setState(() {
                          checked[index] = newValue ?? false;
                        });
                      },
                      title: Text(
                        formattedText,
                        style: const TextStyle(
                          color: Color(0xFF422655),
                          fontSize: 16,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
