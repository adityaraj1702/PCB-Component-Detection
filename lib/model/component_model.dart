class ComponentModel {
	double? time;
	Photo? image;
	List<Predictions>? predictions;

	ComponentModel({this.time, this.image, this.predictions});

	ComponentModel.fromJson(Map<String, dynamic> json) {
		time = json['time'];
		image = json['image'] != null ? Photo.fromJson(json['image']) : null;
		if (json['predictions'] != null) {
			predictions = <Predictions>[];
			json['predictions'].forEach((v) { predictions!.add(Predictions.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['time'] = time;
		if (image != null) {
      data['image'] = image!.toJson();
    }
		if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class Photo {
	int? width;
	int? height;

	Photo({this.width, this.height});

	Photo.fromJson(Map<String, dynamic> json) {
		width = json['width'];
		height = json['height'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['width'] = width;
		data['height'] = height;
		return data;
	}
}

class Predictions {
	double? x;
	double? y;
	int? width;
	int? height;
	double? confidence;
	String? Class;
	int? classId;
	String? detectionId;

	Predictions({this.x, this.y, this.width, this.height, this.confidence, this.Class, this.classId, this.detectionId});

	Predictions.fromJson(Map<String, dynamic> json) {
		x = json['x'];
		y = json['y'];
		width = json['width'];
		height = json['height'];
		confidence = json['confidence'];
		Class = json['class'];
		classId = json['class_id'];
		detectionId = json['detection_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['x'] = x;
		data['y'] = y;
		data['width'] = width;
		data['height'] = height;
		data['confidence'] = confidence;
		data['class'] = Class;
		data['class_id'] = classId;
		data['detection_id'] = detectionId;
		return data;
	}
}