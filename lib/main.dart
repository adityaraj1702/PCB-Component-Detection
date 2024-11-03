import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:pcb_detection/model/component_model.dart';
import 'package:pcb_detection/model/dropped_file.dart';
import 'package:pcb_detection/roboflow_service.dart';
import 'package:pcb_detection/widgets/bounding_box.dart';
import 'package:pcb_detection/widgets/dropped_image_widget.dart';
import 'package:pcb_detection/widgets/dropzone_widget.dart';
import 'package:pcb_detection/widgets/table_widget.dart';

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
      home: const MyHomePage(title: 'PCB Component Detection and Estimation'),
      debugShowCheckedModeBanner: false,
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
  var data = '';
  String progress = '';
  Uint8List imageToDisplay = Uint8List(0);
  bool isLoaded = false;
  bool isLoading = false;
  late ComponentModel componentModel;
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
    roboflowService = RoboflowService(modelId, apiKey);
  }

  Future<void> generateResult(DroppedFile file) async {
    setState(() {
      isLoading = true;
      progress = 'Uploading Image...';
    });
    final urlDownload = await uploadImage();
    setState(() {
      progress = 'Performing Inference...';
    });
    final body = await roboflowService!.infer(urlDownload.toString());
    // final Map<String, dynamic> jsonResponse = jsonDecode(body);
    final image = await roboflowService!.inferImage(urlDownload.toString());
    setState(() {
      progress = 'Result Generated!';
      data = body;
      // componentModel = ComponentModel.fromJson(jsonResponse);
      imageToDisplay = image;
      isLoading = false;
      isLoaded = true;
    });
    //deleting image from firebase storage
    await FirebaseStorage.instance.refFromURL(urlDownload.toString()).delete();
  }

  Future<String> uploadImage() async {
    final path = 'files/${file!.name}';
    final Uint8List bytes = file!.fileData;
    uploadTask = FirebaseStorage.instance
        .refFromURL('gs://pcb-component-detection-89a52.appspot.com')
        .child(path)
        .putData(bytes);
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              //draggable file picking
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
                  if (file != null)
                    const SizedBox(
                      width: 20,
                    ),
                  if (file != null)
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
              //generate button
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
              //filter settings
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
                  ],
                ),
              ),
              //load table and annotated image
              if (isLoading == true)
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(progress),
                  ],
                ),
              if (isLoaded == true)
                SizedBox(
                  height: 1000,
                  width: 1000,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TableWidget(
                        data: data,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        child: GestureZoomBox(
                          maxScale: 5,
                          doubleTapScale: 2.5,
                          child: Image.memory(
                            imageToDisplay,
                            width: 500,
                            height: 400,
                            fit: BoxFit.contain,
                            // child: ComponentImage(colorList: colorList,image: ,predictions: [],selectedClass: [],),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
