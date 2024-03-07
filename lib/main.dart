import 'package:flutter/material.dart';
import 'package:pcb_detection/imagepicking.dart';
import 'package:pcb_detection/model/dropped_file.dart';
import 'package:pcb_detection/roboflow_service.dart';
import 'package:pcb_detection/widgets/dropped_image_widget.dart';
import 'package:pcb_detection/widgets/dropzone_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DroppedFile? file;
  final String modelId = "printed-circuit-board/3";
  final String apiKey = "IYFfEBPmMELFaVl0bIMn";
  RoboflowService? roboflowService;
  String? prediction;

  @override
  void initState() {
    super.initState();
    roboflowService = RoboflowService(modelId, apiKey);
  }

  Future<void> generateResult(DroppedFile file) async {
    // try {
    // final imageBytes = await roboflowService!.downloadImage(file.url);
    // if (imageBytes != null) {
    //   print("Image downoaded successfully");
    // }
    final response = await roboflowService!.infer(file);
    print(response);
    // if (response != null) {
    //   setState(() {
    //     prediction =
    //         response["class"]; // Assuming "class" key holds prediction
    //   });
    //   print("Prediction: $prediction");
    // }
    //   }
    // } on Exception catch (e) {
    //   print("Error: $e"); // Print a more informative error message
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 500,
                  child: DropzoneWidget(
                    onDroppedFile: (file) => setState(() => this.file = file),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 300,
                  width: 500,
                  child: DroppedFileWidget(file: file),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => generateResult(file!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Generate Results',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 40,
              width: 800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Filter Accuracy: "),
                      SizedBox(
                        height: 40,
                        width: 60,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(" %"),
                    ],
                  ),
                  const Row(
                    children: [
                      Text("Filter Components: "),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: Text(
                            "Make multiselect dropdown based on json result"),
                      ),
                    ],
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
