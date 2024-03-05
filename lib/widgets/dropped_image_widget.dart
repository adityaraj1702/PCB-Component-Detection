import 'dart:js';

import 'package:flutter/material.dart';
import 'package:pcb_detection/model/dropped_file.dart';

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile? file;
  const DroppedFileWidget({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => buildImage();

  Widget buildImage(){
    if(file == null) return buildEmptyFile('No File');
    return Image.network(
      file!.url,
      width: 500,
      height: 300,
      fit: BoxFit.fill,
      errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
    );
  }

  Widget buildEmptyFile(String text){
    return Container(
      width: 120,
      height: 120,
      color: Colors.blue.shade300,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}


