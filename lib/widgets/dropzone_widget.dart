import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pcb_detection/model/dropped_file.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;
  const DropzoneWidget({
    Key? key,
    required this.onDroppedFile,
  }) : super(key: key);

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController controller;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final colorBackground = isHighlighted ? Colors.blue : Colors.green;
    final colorButton =
        isHighlighted ? Colors.blue.shade300 : Colors.green.shade300;
    return buildDecoration(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            DropzoneView(
              onCreated: (controller) => this.controller = controller,
              onHover: () => setState(() => isHighlighted = true),
              onLeave: () => setState(() => isHighlighted = false),
              onDrop: acceptFile,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 80,
                  color: Colors.white,
                ),
                const Text(
                  'Drop Image here',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'or',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: colorButton,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () async {
                      final events = await controller.pickFiles();
                      if (events.isEmpty) return;
                      acceptFile(events.first);
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 32,
                    ),
                    label: const Text(
                      'Choose Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = isHighlighted ? Colors.blue : Colors.green;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: colorBackground,
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

  Future acceptFile(dynamic event) async {
    final name = event.name;
    final url = await controller.createFileUrl(event);
    print("Name: $name");
    print("Url: $url");

    final droppedFile = DroppedFile(
      url: url,
      name: name,
    );

    widget.onDroppedFile(droppedFile);
    setState(() => isHighlighted = false);
  }
}
