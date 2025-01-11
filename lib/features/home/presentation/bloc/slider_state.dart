part of 'slider_cubit.dart';

@immutable
sealed class SliderState {}

final class SliderInitial extends SliderState {}
final class SliderLoading extends SliderState {}

final class SliderLoaded extends SliderState {
  final List<SliderImage> images;

  SliderLoaded(this.images);
}

final class SliderFailure extends SliderState {
  final String errMessage;

  SliderFailure(this.errMessage);
}