import 'package:flutter/material.dart';
import 'package:pcb_detection/model/component_model.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Predictions>? predictions;
  final List<String>? selectedClass;
  final List<Color>? colorList;

  BoundingBoxPainter({this.predictions, this.selectedClass, this.colorList});

  @override
  void paint(Canvas canvas, Size size) {
    if (predictions != null && selectedClass != null && colorList != null) {
      final double scaleX = size.width / 2048;
      final double scaleY = size.height / 1498;

      for (var prediction in predictions!) {
        if (selectedClass!.contains(prediction.Class)) {
          final index = selectedClass!.indexOf(prediction.Class!);
          final color = colorList![index];
          final left = prediction.x! * scaleX;
          final top = prediction.y! * scaleY;
          final right = (prediction.x! + prediction.width!) * scaleX;
          final bottom = (prediction.y! + prediction.height!) * scaleY;

          final rect = Rect.fromLTRB(left, top, right, bottom);

          final paint = Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ComponentImage extends StatelessWidget {
  final Image? image;
  final List<Predictions>? predictions;
  final List<String>? selectedClass;
  final List<Color>? colorList;

  const ComponentImage(
      {super.key, this.image, this.predictions, this.selectedClass, this.colorList});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BoundingBoxPainter(
        predictions: predictions,
        selectedClass: selectedClass,
        colorList: colorList,
      ),
      child: AspectRatio(
        aspectRatio: image!.width! / image!.height!,
        child: Image.network(""),
      ),
    );
  }
}
