part of 'answer_consultation_cubit.dart';

@immutable
sealed class AnswerConsultationState {}

final class AnswerConsultationInitial extends AnswerConsultationState {}

final class AnswerConsultationLoading extends AnswerConsultationState {}

final class AnswerConsultationSuccess extends AnswerConsultationState {}

final class AnswerConsultationFailure extends AnswerConsultationState {
  final String errMessage;
  AnswerConsultationFailure(this.errMessage);
}
