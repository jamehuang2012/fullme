import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageDownloader {
  static final ImageDownloader _instance = ImageDownloader._internal();

  factory ImageDownloader() {
    return _instance;
  }

  ImageDownloader._internal();

  Future<String?> downloadImage(String imageUrl, String imageNo) async {
    try {
      // Get the temporary directory of the device
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Create a folder based on imageNo
      final Directory folderDir = Directory('${appDir.path}/pku/$imageNo');
      if (!await folderDir.exists()) {
        await folderDir.create(recursive: true);
      }

      // Get the image name from the URL
      final String fileName = path.basename(imageUrl);

      // Define the full path where the image will be saved
      final String filePath = '${folderDir.path}/$fileName';

      // Download the image
      final Response response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save the image to the file
      final File file = File(filePath);
      await file.writeAsBytes(response.data);

      print('Image downloaded to: $filePath');
      return filePath; // Return the file path of the downloaded image

    } catch (e) {
      print('Error downloading image: $e');
      return null; // Return null if an error occurs
    }
  }
}
