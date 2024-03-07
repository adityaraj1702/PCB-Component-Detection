import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFileConverter extends StatefulWidget {
  @override
  _ImageFileConverterState createState() => _ImageFileConverterState();
}

class _ImageFileConverterState extends State<ImageFileConverter> {
  String base64Image = '';

  Future<void> convertFileToBase64() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File file = File(image.path);
        List<int> imageBytes = await file.readAsBytes();
        String base64 = base64Encode(imageBytes);
        setState(() {
          base64Image = base64;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image File Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: convertFileToBase64,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            if (base64Image.isNotEmpty)
              Image.memory(
                base64Decode(base64Image),
                width: 200,
                height: 200,
              ),
          ],
        ),
      ),
    );
  }
}

