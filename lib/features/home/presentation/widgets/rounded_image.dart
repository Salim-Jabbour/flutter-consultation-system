import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/features/home/models/slider_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.width,
    this.height,
    required this.image,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = ColorManager.c2,
    this.fit = BoxFit.fill,
    this.padding,
    this.isNetworkImage = true,
    this.onPressed,
    this.borderRadius,
  });

  final double? width, height;
  final SliderImage image;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 10.r,
          ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: width ?? 400.w,
          height: height ?? 100.h,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          ),
          child: ClipRRect(
            borderRadius: applyImageRadius
                ? BorderRadius.circular(borderRadius ?? 10.r)
                : BorderRadius.zero,
            child: Image(
              fit: fit,
              image: isNetworkImage
                  ? CachedNetworkImageProvider(image.imageUrl)
                  : AssetImage(image.imageUrl) as ImageProvider,
            ),
          ),
        ),
      ),
    );
  }
}
