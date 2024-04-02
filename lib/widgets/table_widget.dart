import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pcb_detection/model/component_model.dart';

class TableWidget extends StatefulWidget {
  final String data;
  const TableWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  late ComponentModel componentModel;
  List<String> classes = [];
  List<bool> selected = [];
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.teal,
    Colors.cyan,
    Colors.pink,
    Colors.amber,
    Colors.lime,
    Colors.brown,
    Colors.grey,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.indigoAccent,
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.pinkAccent,
    Colors.amberAccent,
    Colors.limeAccent,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    componentModel = ComponentModel.fromJson(jsonDecode(widget.data));
    // Extract unique classes and initialize selected list with false values
    Map<String, int> classFrequency = {};
    componentModel.predictions?.forEach((prediction) {
      classFrequency.update(prediction.Class!, (value) => value + 1,
          ifAbsent: () => 1);
    });
    classes = classFrequency.keys.toList();
    selected = List.generate(classes.length, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(
            label: Row(
              children: [
                Checkbox(
                  value: selected.every((value) => value),
                  onChanged: (value) {
                    setState(() {
                      selected = List.filled(classes.length, value ?? false);
                    });
                  },
                ),
                const Text('Select'),
              ],
            ),
            tooltip: 'Select/Unselect',
          ),
          const DataColumn(
            label: Text("Components"),
            tooltip: "Various components detected on the PCB",
          ),
          const DataColumn(
            label: Text("Numbers"),
            tooltip: "Number of the component detected",
          ),
        ],
        rows: classes.asMap().entries.map((entry) {
          int index = entry.key;
          return DataRow(
            cells: [
              DataCell(
                Checkbox(
                  value: selected[index],
                  onChanged: (value) {
                    setState(() {
                      selected[index] = value!;
                    });
                  },
                ),
              ),
              DataCell(
                Row(
                  children: [
                    _buildColorBox(colorList[index]), // Custom colored box
                    const SizedBox(width: 8), // Add spacing between the box and text
                    Text(entry.value), // Populate Components column
                  ],
                ),
              ),
              DataCell(
                Text(
                  // Get the number of occurrences of the class
                  // You need to modify this part according to your data structure
                  // This is just an example assuming you have a list of predictions
                  // with 'class' attribute representing the class name
                  componentModel.predictions!
                      .where((prediction) => prediction.Class == entry.value)
                      .length
                      .toString(),
                ),
              ), // Populate Numbers column
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColorBox(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}