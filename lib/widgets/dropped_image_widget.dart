import 'dart:js';

import 'package:dotted_border/dotted_border.dart';
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

  Widget buildImage() {
    if (file == null) {
      return buildDecoration(child: buildEmptyFile('See Preview here'));
    }
    return buildDecoration(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        file!.url,
        width: 500,
        height: 300,
        fit: BoxFit.fill,
        errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
      ),
    ));
  }

  Widget buildEmptyFile(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        width: 490,
        height: 290,
        color: Colors.grey.shade400,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildDecoration({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey.shade400,
        padding: const EdgeInsets.all(10),
        child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.white,
            strokeWidth: 3,
            padding: EdgeInsets.zero,
            dashPattern: const [8, 4],
            radius: const Radius.circular(10),
            child: child),
      ),
    );
  }
}
