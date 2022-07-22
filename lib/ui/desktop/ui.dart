import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_app/model/model.dart';
import 'package:gallery_app/model/service.dart';

class Gallery extends StatefulWidget {
  final double width;
  const Gallery({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  dynamic result;
  List<ImageModel> images = [];
  List<ImageModel> sImages = [];
  ScrollController controller = ScrollController();
  String url = 'https://api.pexels.com/v1/curated?page=1&per_page=25 ';
  String? sUrl;
  TextEditingController query = TextEditingController();
  String sQuery = '';
  dynamic width;
  bool searching = false;
  bool page = false;
  retrieveImage(width) async {
    result = await ApiCall(width: width, url: url).getImage();
    // print(images);
    setState(() {
      images = result['images'];
      url = result['url'];
    });
  }

  getSearch(width) async {
    if (query.text.isNotEmpty) {
      result = await ApiCall(width: width, url: sUrl!).getImageBySearch();
      setState(() {
        sImages = result['images'];
        sUrl = result['url'];
      });

      // searching = false;
    }
  }

  @override
  void initState() {
    super.initState();
    width = widget.width;
    retrieveImage(width);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          images.length != 800 &&
          searching == false) {
        retrieveImage(width);
      } else if (controller.position.pixels ==
              controller.position.maxScrollExtent &&
          images.length != 800 &&
          searching == true) {
        getSearch(width);
      }
    });
    query.addListener(() {
      if (query.text.isEmpty) {
        setState(() {
          sImages.clear();
        });
      } else if (query.text.isNotEmpty) {
        setState(() {
          sUrl =
              "https://api.pexels.com/v1/search?query=${query.text}&per_page=20";
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // sizeMonitor(width);
    // width
    return Scaffold(
        appBar: AppBar(
          title: const Text('Desktop'),
          centerTitle: true,
          actions: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: TextField(
                  controller: query,
                  decoration: const InputDecoration(
                      filled: true, label: Text('Search Pexels ')),
                )),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searching = true;
                  // sQuery = query.text;
                });

                getSearch(width);
                // query.clear();
              },
            ),
            searching == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        searching = false;
                        query.clear();
                      });
                    },
                    icon: const Icon(Icons.cancel_sharp))
                : const SizedBox.shrink(),
          ],
        ),
        body: images.isEmpty
            ? const Center(child: RefreshProgressIndicator())
            : sImages.isEmpty && searching == true
                ? const Center(child: RefreshProgressIndicator())
                : MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: controller,
                    shrinkWrap: true,
                    crossAxisCount: 5,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: searching ? sImages.length : images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          searching
                              ? Navigator.pushNamed(context, '/image',
                                  arguments: sImages[index])
                              : Navigator.pushNamed(context, '/image',
                                  arguments: images[index]);
                        },
                        child: GridTile(
                            child: Image.network(
                          searching
                              ? sImages[index].src.medium
                              : images[index].src.medium,
                          fit: BoxFit.cover,
                        )),
                      );
                    }));
  }
}
