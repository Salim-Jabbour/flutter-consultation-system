import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/Consultation.dart';
import '../../repository/consultation_repository_impl.dart';

part 'consultation_search_state.dart';

class ConsultationSearchCubit extends Cubit<ConsultationSearchState> {
  final ConsultationRepository _consultationRepository;

  List<Consultation> consultation = [];

  ConsultationSearchCubit(this._consultationRepository)
      : super(ConsultationSearchInitial());

  Future<void> searchConsultations(
      {required String searchText, int page = 0}) async {
    emit(ConsultationSearchLoading());
    final result = await _consultationRepository.searchConsultations(
      searchText: searchText,
      page: page,
    );
    result.fold((error) => emit(ConsultationSearchFailure(error.message)),
        (newConsultation) {
      if (page == 0) {
        consultation = [];
      }
      consultation.addAll(newConsultation);
      emit(newConsultation.length < 10
          ? ConsultationSearchReachMax()
          : ConsultationSearchLoaded(page + 1));
    });
  }

  void clearSearch() {
    consultation = [];
    emit(ConsultationSearchInitial());
  }
}
