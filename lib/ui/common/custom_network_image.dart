import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final bool isCircularImage;
  final bool cameraImageShow;
  final Function(File image)? image;

  const CustomNetworkImage({
    this.url = '',
    this.height,
    this.width,
    this.isCircularImage = false,
    super.key,
    this.image,
    this.cameraImageShow = false,

  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: 80,
      width: 80,
      imageUrl: url,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.black,
        width: 80,
        height: 80,
      ),
      imageBuilder: (context, imageProvider) {
        /// Retrieve image from cache.
        DefaultCacheManager().getSingleFile(url).then((value) {
          var callBack = image;
          if (callBack != null) {
            callBack(value);
          }
        });

        return Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              width: 2,
              color: Colors.transparent,
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
