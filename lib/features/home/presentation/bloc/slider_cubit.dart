import 'package:akemha/features/home/models/slider_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../repository/home_repository.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  final HomeRepository _homeRepository;

  SliderCubit(this._homeRepository) : super(SliderInitial());

  Future<void> getSliderImages() async {
    emit(SliderLoading());
    final result = await _homeRepository.fetchSliderImages();
    result.fold((error) {
      emit(SliderFailure(error.message));
    }, (images) {
      emit(SliderLoaded(images));
    });
  }
}
