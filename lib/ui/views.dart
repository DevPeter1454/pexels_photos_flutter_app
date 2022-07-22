import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ImageView extends StatefulWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  dynamic received;
  dynamic filePath;
  @override
  Widget build(BuildContext context) {
    received = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.height * 0.5,
                child: Image.network('${received.src.medium}'),
              ),
            ),
            Builder(builder: (BuildContext context) {
              return OutlinedButton(
                onPressed: () {
                  _save(context);
                  // Share.share('${received.src.medium}');
                  // _onShare(context);
                },
                child: const Text('Save Image'),
              );
            }),
          OutlinedButton(
                onPressed: () {
                  _onShare(context);
                  // Share.share('${received.src.medium}');
                  // _onShare(context);
                },
                child: const Text('Share Image'),
              )

          ],
        ));
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final urlImage = received.src.medium.toString();
    final image = await http.get(Uri.parse(urlImage));
    final response = image.bodyBytes;
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = '$directory/image.png';
    File(path).writeAsBytesSync(response);
    await Share.shareFiles([path], text: 'images', subject: 'Share me', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    // await Share.share(received.src.medium,
    //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  _save(context) async {
    if (Platform.isIOS || Platform.isAndroid) {
      await _askPermission();
      var response = await Dio().get(received.src.medium,
          options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

      // var newRes = await http.

      toast('Image Saved', duration: const Duration(seconds: 1));
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

      var response = await Dio().get(received.src.large.toString(),
          options: Options(responseType: ResponseType.bytes));
      await image.writeAsBytes(Uint8List.fromList(response.data));
      toast('Image Saved', duration: const Duration(seconds: 1));
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
}
