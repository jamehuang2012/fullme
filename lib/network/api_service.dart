import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/fullme_data.dart';
import 'package:html/parser.dart' as parser;

import 'ImageDownloader.dart';

class ApiService {

  Future<List<String?>> fetchImageUrls(String url,String imageNo,{int count = 1}) async {
    try {
      // List to hold imgSrc results
      List<String?> imageUrls = [];

      // Perform the GET request 3 times
      for (int i = 0; i < count; i++) {
        final response = await http.get(Uri.parse(url));

        // Check if the request was successful (status code 200).
        if (response.statusCode == 200) {
          var document = parser.parse(response.body);
          var imgElement = document.getElementsByTagName('img').first;
          var imgSrc = imgElement.attributes['src'];
          print(imgSrc);
          //imageUrls.add(imgSrc);
          String? filePath;
          ImageDownloader imageDownloader = ImageDownloader();
          filePath = await imageDownloader.downloadImage(
            'http://fullme.pkuxkx.com/$imgSrc', // Replace with your image URL
            imageNo, // Replace with your imageNo
          );

          print("file save $filePath " );
          imageUrls.add(filePath);

        } else {
          throw Exception('Failed to load image: ${response.statusCode}');
        }
      }
      print("imageUrls$imageUrls");
      return imageUrls;
    } catch (e) {
      throw Exception('Failed to fetch image data: $e');
    }
  }
}