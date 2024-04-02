import 'dart:convert';
import 'package:flutter/material.dart';

// Assuming you have a variable `jsonData` containing your JSON data
String jsonData = '''
{
  "predictions": [
    {
      "x": 798.0,
      "y": 817.5,
      "width": 242.0,
      "height": 247.0,
      "confidence": 0.9403144717216492,
      "class": "IC",
      "class_id": 9,
      "detection_id": "eaec063d-9787-4901-8a19-55485d4a2d0b"
    },
    {
      "x": 286.0,
      "y": 693.5,
      "width": 186.0,
      "height": 171.0,
      "confidence": 0.9391250610351562,
      "class": "Connector",
      "class_id": 4,
      "detection_id": "0e91227e-610d-4f24-90dd-1fe9c976fa40"
    },
    {
      "x": 271.0,
      "y": 1087.0,
      "width": 202.0,
      "height": 174.0,
      "confidence": 0.9363261461257935,
      "class": "Connector",
      "class_id": 4,
      "detection_id": "58bbca2b-4150-4bbe-8efa-6d3413850a8f"
    }
  ]
}
''';

List<String> extractClasses(String jsonData) {
  List<dynamic> predictions = jsonDecode(jsonData)['predictions'];
  Set<String> classesSet = Set<String>();
  predictions.forEach((prediction) {
    classesSet.add(prediction['class']);
  });
  return classesSet.toList();
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> classes = [];
  List<String> selectedClasses = [];

  @override
  void initState() {
    super.initState();
    classes = extractClasses(jsonData);
    selectedClasses = List.from(classes); // Initially, all items are selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Center(
        child: Directionality(
          textDirection:
              TextDirection.ltr, // Set your desired text directionality
          child: DropdownButtonFormField<String>(
            items: classes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: selectedClasses.contains(value),
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue!) {
                            selectedClasses.add(value);
                          } else {
                            selectedClasses.remove(value);
                          }
                        });
                      },
                    ),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Handle dropdown value change
            },
            value: null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Select classes',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(selectedClasses);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

