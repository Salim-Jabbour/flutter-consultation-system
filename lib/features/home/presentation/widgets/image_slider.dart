import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/features/home/models/slider_image.dart';
import 'package:akemha/features/home/presentation/bloc/slider_cubit.dart';
import 'package:akemha/features/home/presentation/widgets/rounded_image.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../../../core/utils/dbg_print.dart';

class ImagesSlider extends StatefulWidget {
  const ImagesSlider({
    super.key,
    required this.cubit,
  });

  final SliderCubit cubit;

  @override
  State<ImagesSlider> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  int index = 0;
  final CustomCarouselController _carouselController =
      CustomCarouselController();

  // final PageController _pageController = PageController();
  // final List images = const [
  //   AssetImageManager.activity1,
  //   AssetImageManager.activity2,
  //   AssetImageManager.post,
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.cubit,
      child: BlocConsumer<SliderCubit, SliderState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SliderInitial) {
            widget.cubit.getSliderImages();
          }
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.r,
                    ),
                    child: state is SliderLoaded
                        ? state.images.isNotEmpty
                            ? CarouselSlider.builder(
                                carouselController: _carouselController,
                                itemCount: state.images.length,
                                itemBuilder: (context, index, realIndex) {
                                  return GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          state.images[index].pageLink));
                                    },
                                    child: RoundedImage(
                                      image: state.images[index],
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      this.index = index;
                                    });
                                    // _pageController.jumpToPage(index);
                                  },
                                ),
                              )
                            : Container(
                                width: 400.w,
                                height: 200.h,
                                color: ColorManager.grey,
                              )
                        : (state is SliderLoading)
                            ? const Skeletonizer(
                                enabled: true,
                                child: RoundedImage(
                                  isNetworkImage: false,
                                  image: loadingSliderImage,
                                ),
                              )
                            : Container(
                                width: 400.w,
                                height: 250.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: ColorManager.grey,
                                ),
                              ),
                  ),
                  AnimatedSmoothIndicator(
                    onDotClicked: (index) {
                      setState(() {
                        this.index = index;
                      });
                      _carouselController.animateToPage(index);
                    },
                    // controller: _carouselController.state!.pageController!,
                    activeIndex: index,
                    count: state is SliderLoaded ? state.images.length : 0,
                    effect: WormEffect(
                      dotHeight: 10.r,
                      dotWidth: 10.r,
                      dotColor: ColorManager.white,
                      activeDotColor: ColorManager.c2,
                    ),
                  )
                ],
              ),
              if (state is SliderFailure)
                Container(
                  width: 400.w,
                  height: 200.h,
                  color: ColorManager.black,
                )
            ],
          );
        },
      ),
    );
  }
}

class CustomCarouselController extends CarouselControllerImpl {
  CarouselState? _state;

  CarouselState? get state => _state;

  @override
  set state(CarouselState? state) {
    _state = state;
    super.state = state;
  }
}
