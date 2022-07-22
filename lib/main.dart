import 'package:flutter/material.dart';
import 'package:gallery_app/ui/layout.dart';
import 'package:gallery_app/ui/views.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Layout(),
        '/image': (context) => const ImageView(),
      },
      debugShowCheckedModeBanner: false,
    ));
  }
}
