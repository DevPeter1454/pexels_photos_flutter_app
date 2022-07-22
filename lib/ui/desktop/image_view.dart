// import 'dart:io';
// import 'dart:typed_data';

// ignore_for_file: avoid_print

// import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';


class ImageView extends StatefulWidget {
  final String? imgUrl;

  const ImageView({
    Key? key,
    @required this.imgUrl,
  }) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl ?? "",
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl ?? '',
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _save(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff1C1B1B).withOpacity(0.8),
                        ),
                      ),
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white60, width: 1),
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0x36FFFFFF),
                                Color(0x0FFFFFFF)
                              ])),
                          child: Column(
                            children: const [
                              Text(
                                "Set Wallpaper",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                              Text(
                                "Image will be saved in gallery",
                                style: TextStyle(
                                    fontSize: 7, color: Colors.white70),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          )
        ],
      ),
    );
  }

  _save(context) async {
    if (Platform.isIOS || Platform.isAndroid) {
      // image_gallery_saver: '^plugin
      // permission_handler: ^plugin
      // random_string: ^plugin
      // dio: ^plugin
      await _askPermission();
      var response = await Dio().get(widget.imgUrl ?? '',
          options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

      // you can use  overlay_support: ^plugin
      toast('image saved', duration: const Duration(seconds: 1));
    }

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      Directory dir = await getApplicationDocumentsDirectory();
      var pathList = dir.path.split('\\');
      pathList[pathList.length - 1] = 'Pictures';
      var picturePath = pathList.join('\\');
      var round = Random();
      var nextRound = round.nextInt(1000000).toString();
      var image =
          await File(join(picturePath, "flutter_image", "image$nextRound.png"))
              .create(recursive: true);
      var response = await Dio().get(widget.imgUrl ?? '',
          options: Options(responseType: ResponseType.bytes));
      await image.writeAsBytes(Uint8List.fromList(response.data));

      // await SmartDialog.showToast('image saved', debounceTemp: true);
      toast('image saved', duration: const Duration(seconds: 1));
    }

    return Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /* Map<Permission, PermissionStatus> permissions = */

      await Permission.photos.request();
    } else {
      /* PermissionStatus permission = */ await [Permission.storage].request();
    }
  }

  // another method of saving image to gallery
  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();

  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '-')
  //       .replaceAll(':', '-');
  //   final name = 'screenshot_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);

  //   return result['filePath'];
  // }
}
