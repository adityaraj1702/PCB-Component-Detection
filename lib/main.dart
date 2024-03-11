import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
// import 'dart:html';
// import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pcb_detection/model/dropped_file.dart';
import 'package:pcb_detection/roboflow_service.dart';
import 'package:pcb_detection/widgets/dropped_image_widget.dart';
import 'package:pcb_detection/widgets/dropzone_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyA_gcV_6gNN5ZrlljDwrk7PxRT7z6-U1gA",
    appId: "1:992111924753:web:b30c05439c1d154a9243b0",
    messagingSenderId: "G-QPDBWEZQ1K",
    storageBucket: "pcb-component-detection-89a52.appspot.com",
    projectId: "pcb-component-detection-89a52",
  ));
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
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    roboflowService = RoboflowService(modelId, apiKey);
  }

  Future<void> generateResult(DroppedFile file) async {
    final urlDownload = await uploadImage();
    print(urlDownload);
    final response = await roboflowService!.infer(urlDownload.toString());
    // print(response);
  }

  Future<String> uploadImage() async {
    final path = 'files/${file!.name}';
    final Uint8List bytes = file!.fileData;
    uploadTask = FirebaseStorage.instance.refFromURL('gs://pcb-component-detection-89a52.appspot.com').child(path).putData(bytes);
    print('upload task done');
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
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
