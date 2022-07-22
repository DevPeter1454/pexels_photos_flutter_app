import 'package:flutter/material.dart';
import 'package:gallery_app/ui/desktop/ui.dart';
import 'package:gallery_app/ui/phone/phone.dart';
import 'package:gallery_app/ui/tab/tab.dart';

class Layout extends StatefulWidget {
  const Layout({
    Key? key,
   
  }) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (width < 600) {
          return  MobileView(width:width);
        } else if (width > 600 && width < 800) {
          return TabletView(width:width);
        } else {
          return Gallery(width:width);
        }
      }),
    );
  }
}
