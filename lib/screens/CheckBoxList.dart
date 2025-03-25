import 'package:flutter/material.dart';

class AndroidCompact2 extends StatefulWidget {
  final List<String> ocrLines;
  const AndroidCompact2({Key? key, required this.ocrLines}) : super(key: key);

  @override
  _AndroidCompact2State createState() => _AndroidCompact2State();
}

class _AndroidCompact2State extends State<AndroidCompact2> {
  late List<String> items;
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    items = filterAndFormatOcrText(widget.ocrLines);
    checked = List<bool>.filled(items.length, false);
  }

  // Филтриране и форматиране на OCR текста
  List<String> filterAndFormatOcrText(List<String> lines) {
    List<String> formattedList = [];
    RegExp regex = RegExp(r"(.+?)\s+(\d+[.,]?\d*)\s?(USD|EUR|GBP|\$|€|£)?", caseSensitive: false);
    List<String> unwantedKeywords = ["TOTAL", "TAX", "SHOP", "ADDRESS", "STORE", "INVOICE", "DATE", "TIME"];

    for (var line in lines) {
      // Пропускаме редове с нежелани думи
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
