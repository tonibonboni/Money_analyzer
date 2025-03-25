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

  // Функция за разчитане и почистване на OCR текста
  Future<List<String>> _extractLines(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); // Принуждава разчитане на латиница
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    List<String> lines = [];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        String cleanedLine = line.text.replaceAll(RegExp(r'[^\w\s\.,:]'), '').trim(); // Премахване на ненужни символи
        if (cleanedLine.isNotEmpty) {
          lines.add(cleanedLine);
        }
      }
    }
    return lines;
  }

  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });

      List<String> ocrLines = await _extractLines(imageFile);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AndroidCompact2(ocrLines: ocrLines),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              ),
              const SizedBox(height: 13),
              GestureDetector(
                onTap: _openCamera,
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
            ],
          ),
        ),
      ],
    );
  }
}
