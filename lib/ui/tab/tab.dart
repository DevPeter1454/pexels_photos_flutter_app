import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_app/model/model.dart';
import 'package:gallery_app/model/service.dart';

class TabletView extends StatefulWidget {
  final dynamic width;
  const TabletView({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  dynamic result;
  List<ImageModel> images = [];
  ScrollController controller = ScrollController();
  String url = 'https://api.pexels.com/v1/curated?page=1&per_page=20 ';
  dynamic width;
  bool page = false;
  retrieveImage(width) async {
    result = await ApiCall(width: width, url: url).getImage();
    // print(images);
    setState(() {
      images = result['images'];
      url = result['url'];
    });
  }

  @override
  void initState() {
    super.initState();
    width = widget.width;
    retrieveImage(width);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          images.length != 800) {
        retrieveImage(width);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tablet'),
        centerTitle: true,
      ),
      body: images.isEmpty
            ? const Center(child: RefreshProgressIndicator())
            : MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: controller,
                shrinkWrap: true,
                crossAxisCount:  4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/image',
                          arguments: images[index]);
                    },
                    child: GridTile(
                        child: Image.network(
                      images[index].src.large,
                      fit: BoxFit.cover,
                    )),
                  );
                })
    );
  }
}
