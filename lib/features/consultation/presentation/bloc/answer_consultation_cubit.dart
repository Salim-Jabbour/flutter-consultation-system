import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/consultation_repository_impl.dart';

part 'answer_consultation_state.dart';

class AnswerConsultationCubit extends Cubit<AnswerConsultationState> {
  final ConsultationRepository _consultationRepository;

  AnswerConsultationCubit(this._consultationRepository)
      : super(AnswerConsultationInitial());

  Future<void> answerConsultation(String answer, int id) async {
    emit(AnswerConsultationLoading());
    final result = await _consultationRepository.answerConsultation(
        answer: answer, consultationId: id);
    result.fold((error) => emit(AnswerConsultationFailure(error.message)),
        (success) {
      emit(AnswerConsultationSuccess());
      emit(AnswerConsultationInitial()  );
    });
  }
}
