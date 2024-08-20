class FullmeData {
  String id;
  String name;
  String task;
  String imageNo;
  List<String?> filePaths;

  FullmeData({required this.id,required this.name, required this.task, required this.imageNo, required this.filePaths});

  factory FullmeData.fromJson(Map<String, dynamic> json) {
    return FullmeData(
      id: json['id'],
      name: json['name'],
      task: json['task'],
      imageNo: json['image_no'],
      filePaths: List<String?>.from(json['file_paths'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['task'] = task;
    data['image_no'] = imageNo;
    data['file_paths'] = filePaths;
    return data;
  }
}
