import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:gallery_app/model/apikey.dart';
import 'package:gallery_app/model/model.dart';

List<ImageModel> images = [];
List<ImageModel> sImages = [];

class ApiCall {
  dynamic width;
  String url;
  ApiCall({
    required this.width,
    required this.url,
  });

  getImage() async {
    try {
      // print('first $url');
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': apiKey,
      });
      var newResponse = json.decode(response.body);
      var imagesList = newResponse['photos'] as List;
      url = newResponse['next_page'];
      // print('second $url');

      for (var image in imagesList) {
        images.add(ImageModel.fromMap(image));
      }
      return {'images': images, 'url': url};
    } catch (e) {
      return e.toString();
    }
  }

  getImageBySearch() async {
    try {
      // print('first $url');
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': apiKey,
      });
      var newResponse = json.decode(response.body);
      var imagesList = newResponse['photos'] as List;
      url = newResponse['next_page'];
      // print('second $url');

      for (var image in imagesList) {
        sImages.add(ImageModel.fromMap(image));
      }
      return {'images': sImages, 'url': url};
    } catch (e) {
      return e.toString();
    }
  }
}
