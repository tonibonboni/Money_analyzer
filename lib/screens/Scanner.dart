import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'CheckBoxList.dart';

class AndroidCompact1 extends StatefulWidget {
  const AndroidCompact1({super.key});

  @override
  _AndroidCompact1State createState() => _AndroidCompact1State();
}

class _AndroidCompact1State extends State<AndroidCompact1> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  // Function for reading and cleaning OCR text
  Future<List<String>> _extractLines(File imageFile) async {
    try {
      setState(() {
        _isProcessing = true;
      });
      
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      List<String> lines = [];
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          String cleanedLine = line.text.replaceAll(RegExp(r'[^\w\s\.,:]'), '').trim();
          if (cleanedLine.isNotEmpty) {
            lines.add(cleanedLine);
          }
        }
      }
      
      return lines;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
      return [];
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _openCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _image = imageFile;
        });

        List<String> ocrLines = await _extractLines(imageFile);
        
        // Only navigate if we have at least one line
        if (ocrLines.isNotEmpty) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AndroidCompact2(ocrLines: ocrLines),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No text was recognized in the image')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $e')),
      );
    }
  }
  
  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() {
          _image = imageFile;
        });

        List<String> ocrLines = await _extractLines(imageFile);
        
        // Only navigate if we have at least one line
        if (ocrLines.isNotEmpty) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AndroidCompact2(ocrLines: ocrLines),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No text was recognized in the image')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 360,
            height: 800,
            padding: const EdgeInsets.only(top: 132, left: 31, right: 31, bottom: 48),
            decoration: ShapeDecoration(
              color: const Color(0xFF86BBB2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 298,
                  height: 537,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                    image: _image != null ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) : null,
                  ),
                  child: _isProcessing 
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF422655),
                          ),
                        )
                      : _image == null 
                          ? const Center(
                              child: Text(
                                'Take a photo of a receipt',
                                style: TextStyle(
                                  color: Color(0xFF422655),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : null,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Camera button
                    GestureDetector(
                      onTap: _isProcessing ? null : _openCamera,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF422655),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(width: 1, color: const Color(0xFF86BBB2)),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Gallery button
                    GestureDetector(
                      onTap: _isProcessing ? null : _pickFromGallery,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF422655),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(width: 1, color: const Color(0xFF86BBB2)),
                        ),
                        child: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
