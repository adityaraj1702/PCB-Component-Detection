import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pcb_detection/model/dropped_file.dart';

class RoboflowService {
  static const String baseUrl = "https://detect.roboflow.com/";
  final String modelId;
  final String apiKey;

  RoboflowService(this.modelId, this.apiKey);

  String output = '';

  Future<String> infer(DroppedFile file) async {
    // setState(() {
    output = "Inferring...";
    // });

    var settings = await getSettingsFromForm(file);
    try {
      var response =
          await http.post(Uri.parse(settings['url']), body: settings['data']);

      if (response.statusCode == 200) {
        // setState(() {
        output = json.decode(response.body).toString();
        // });
      } else {
        // setState(() {
        output =
            "Error loading response.\n\nCheck your API key, model, version, and other parameters then try again. ${response.statusCode}";
        // });
      }
    } catch (e) {
      // setState(() {
      output =
          "Error loading response.\n\nCheck your API key, model, version, and other parameters then try again. $e";
      // });
    }
    return output;
  }

  Future<Map<String, dynamic>> getSettingsFromForm(DroppedFile file) async {
    // Replace these values with the actual values from your form fields
    String apiKey = 'IYFfEBPmMELFaVl0bIMn';
    String model = 'printed-circuit-board';
    String version = '3';
    String url = 'https://detect.roboflow.com/$model/$version?api_key=$apiKey';
    String data =
        'data:image/jpeg;base64,'; // This will be the data sent in the request body

    // Optionally, add other parameters based on your form fields
    String classes = ''; // Get the value from the form
    String confidence = ''; // Get the value from the form
    String overlap = ''; // Get the value from the form
    String format = 'json'; // Assuming JSON format by default

    // Append optional parameters to the URL
    if (classes.isNotEmpty) url += '&classes=$classes';
    if (confidence.isNotEmpty) url += '&confidence=$confidence';
    if (overlap.isNotEmpty) url += '&overlap=$overlap';
    url += '&format=$format';

    // url += '&image=${file.url}';

    // If the format is 'image', prepare the data accordingly
    if (format == 'image') {
      // Get other parameters like labels and stroke
      String labels = ''; // Get the value from the form
      String stroke = '2'; // Get the value from the form

      // Append additional parameters to the URL
      if (labels.isNotEmpty) url += '&labels=on';
      if (stroke.isNotEmpty) url += '&stroke=$stroke';
    }
    // Depending on the method (upload or URL), prepare the data
    String method = 'image'; // Get the value from the form
    if (method == 'upload') {
      // File imageFile = await getImageFileFromUrl(
      //     'https://example.com/image.jpg', 'image.jpg');

      // Assuming 'file' is the input file from the form
      http.Response response = await http.get(Uri.parse(file.url));
      if (response.statusCode == 200) {
        // Convert the image bytes to base64
        List<int> bytes = response.bodyBytes;
        String imageBase64 = base64Encode(bytes);
        // Append the image data to the data string
        // data += imageBase64;
      } else {
        throw Exception('Failed to load image');
      }
    } else {
      // Assuming 'imageUrl' is the image URL input from the form
      // Encode the URL and append it to the URL string
      String imageUrl =
          'https://predictabledesigns.com/wp-content/uploads/2019/08/a-circuit-board-description-automatically-generat.jpeg'; // Get the value from the form
      url += '&image=${Uri.encodeComponent(imageUrl)}';
    }

    return {'method': 'POST', 'format': format, 'url': url, 'data': data};
  }

  Future<List<int>?> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        print(response);
        return response.bodyBytes;
      } else {
        throw Exception("Error downloading image: ${response.statusCode}");
      }
    } on Exception catch (e) {
      print("Error downloading image: $e");
      return null;
    }
  }
}
