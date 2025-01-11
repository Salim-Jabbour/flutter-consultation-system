import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../consultation/models/Consultation.dart';
import '../../repository/consultation_repository.dart';

part 'consultation_log_event.dart';

part 'consultation_log_state.dart';

class ConsultationLogBloc
    extends Bloc<ConsultationLogEvent, ConsultationLogState> {
  final ConsultationLogRepository _consultationLogRepository;
  ConsultationListModel myAnsweredConsultations =
      const ConsultationListModel(consultations: []);
  ConsultationListModel consultationsLog =
      const ConsultationListModel(consultations: []);
  Completer<void> refreshCompleter = Completer<void>();

  ConsultationLogBloc(this._consultationLogRepository)
      : super(ConsultationLogInitial()) {
    on<GetConsultationsLogPage>((event, emit) async {
      refreshCompleter = Completer<void>();
      bool isInitial = event.page == 0;
      if (isInitial) {
        consultationsLog =
            consultationsLog.copyWith(currentPage: 0, consultations: []);
        emit(
          ConsultationsLogLoaded(
            consultationsLog: consultationsLog.copyWith(isInitialLoading: true),
            myAnsweredConsultations: myAnsweredConsultations,
          ),
        );
      } else {
        emit(
          ConsultationsLogLoaded(
            consultationsLog: consultationsLog.copyWith(isLoading: true),
            myAnsweredConsultations: myAnsweredConsultations,
          ),
        );
      }
      final result = await _consultationLogRepository.fetchConsultationsLogPage(
        pageNumber: consultationsLog.currentPage,
      );
      if (!refreshCompleter.isCompleted) {
        refreshCompleter.complete();
      }
      result.fold((error) {
        if (isInitial) {
          emit(ConsultationsLogFailure(error.message));
        } else {
          emit(
            ConsultationsLogLoaded(
              consultationsLog: consultationsLog.copyWith(isError: true),
              myAnsweredConsultations: myAnsweredConsultations,
            ),
          );
        }
      }, (consultations) {
        consultationsLog = consultationsLog.copyWith(
          consultations: consultationsLog.consultations + consultations,
          currentPage: consultationsLog.currentPage + 1,
          reachMax: consultationsLog.reachMax || consultations.length < 10,
        );
        emit(
          ConsultationsLogLoaded(
            consultationsLog: consultationsLog,
            myAnsweredConsultations: myAnsweredConsultations,
          ),
        );
      });
    });
    on<GetMyAnsweredConsultationsLogPage>((event, emit) async {
      refreshCompleter = Completer<void>();
      bool isInitial = event.page == 0;
      if (isInitial) {
        myAnsweredConsultations =
            myAnsweredConsultations.copyWith(currentPage: 0, consultations: []);
        emit(ConsultationsLogLoaded(
          consultationsLog: consultationsLog,
          myAnsweredConsultations:
              myAnsweredConsultations.copyWith(isInitialLoading: true),
        ));
      } else {
        emit(
          ConsultationsLogLoaded(
            consultationsLog: consultationsLog,
            myAnsweredConsultations:
                myAnsweredConsultations.copyWith(isLoading: true),
          ),
        );
      }
      final result =
          await _consultationLogRepository.fetchMyAnsweredConsultationsPage(
        pageNumber: myAnsweredConsultations.currentPage,
      );
      if (!refreshCompleter.isCompleted) {
        refreshCompleter.complete();
      }
      result.fold((error) {
        if (isInitial) {
          emit(ConsultationsLogFailure(error.message));
        } else {
          emit(
            ConsultationsLogLoaded(
              consultationsLog: consultationsLog,
              myAnsweredConsultations:
                  myAnsweredConsultations.copyWith(isError: true),
            ),
          );
        }
      }, (consultations) {
        myAnsweredConsultations = myAnsweredConsultations.copyWith(
          consultations: myAnsweredConsultations.consultations + consultations,
          currentPage: myAnsweredConsultations.currentPage + 1,
          reachMax:
              myAnsweredConsultations.reachMax || consultations.length < 10,
        );
        emit(
          ConsultationsLogLoaded(
            consultationsLog: consultationsLog,
            myAnsweredConsultations: myAnsweredConsultations,
          ),
        );
      });
    });
  }
}
