import 'package:akemha/core/resource/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class TestGallery extends StatelessWidget {
  TestGallery({super.key});

  final pageController = PageController();

  void onPageChanged(int index) {}

  final galleryItems = [
    AssetImageManager.post,
    AssetImageManager.activity1,
    AssetImageManager.activity2
  ];

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        final tag = UniqueKey();
        return PhotoViewGalleryPageOptions(
          imageProvider: AssetImage(galleryItems[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(tag: tag,),
        );
      },
      itemCount: galleryItems.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded /
                    (event.expectedTotalBytes ?? 1),
          ),
        ),
      ),
      backgroundDecoration: const BoxDecoration(color: Colors.grey),
      pageController: pageController,
      onPageChanged: onPageChanged,
    );
  }
}
