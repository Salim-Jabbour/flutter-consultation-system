import 'dart:async';

import 'package:akemha/core/utils/dbg_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/Consultation.dart';
import '../../models/specialization.dart';
import '../../repository/consultation_repository_impl.dart';

part 'consultation_event.dart';

part 'consultation_state.dart';

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  final ConsultationRepository _consultationRepository;
  ConsultationsMapModel consultationsMap = const ConsultationsMapModel(
    specializations: [],
    consultationsMap: {},
  );

  Completer<void> refreshCompleter = Completer<void>();

  ConsultationBloc(this._consultationRepository)
      : super(ConsultationInitial()) {
    on<GetConsultationsPage>(
      (event, emit) async {
        refreshCompleter = Completer<void>();
        dbg('id ${event.id}');
        bool isInitial =
            event.page == 0;
        if (isInitial) {
          consultationsMap.consultationsMap[event.id] =
              const ConsultationListModel(consultations: []);
          emit(ConsultationsLoaded(
            consultations: consultationsMap,
            currentSpecialization: event.id,
            isInitialLoading: true,
          ));
        } else {
          emit(
            ConsultationsLoaded(
              consultations: consultationsMap,
              currentSpecialization: event.id,
              isLoading: true,
            ),
          );
        }
        dbg('currentSpecialization ${event.id}');
        final result = await _consultationRepository.fetchConsultationsPage(
          pageNumber: event.page,
          id: event.id,
        );
        if (!refreshCompleter.isCompleted) {
          refreshCompleter.complete();
        }
        result.fold(
          (error) {
            if (isInitial) {
              emit(ConsultationsFailure(error.message));
            } else {
              // ToDo: is Error
              emit(
                ConsultationsLoaded(
                  consultations: consultationsMap,
                  currentSpecialization: event.id,
                ),
              );
            }
          },
          (consultations) {
            dbg("consultationsMap ${result.length()}");
            if (isInitial) {
              consultationsMap.consultationsMap[event.id] =
                  consultationsMap.consultationsMap[event.id]!.copyWith(
                consultations: consultations,
                currentPage:event.page +
                        1,
                reachMax:
                    consultationsMap.consultationsMap[event.id]!.reachMax ||
                        consultations.length < 10,
              );
            } else {
              // consultationsMap.consultationsMap[event.id]!.consultations
              //     .addAll(consultations);
              consultationsMap.consultationsMap[event.id] =
                  consultationsMap.consultationsMap[event.id]!.copyWith(
                      consultations: consultationsMap
                              .consultationsMap[event.id]!.consultations +
                          consultations,
                      currentPage: event.page +
                          1,
                      reachMax: consultationsMap
                              .consultationsMap[event.id]!.reachMax ||
                          consultations.length < 10);
            }
            dbg("length ${consultationsMap.consultationsMap[event.id]!.consultations.length}");
            dbg("current page ${consultationsMap.consultationsMap[event.id]!.currentPage}");
            emit(ConsultationsLoaded(
              consultations: consultationsMap,
              currentSpecialization: event.id,
            ));
          },
        );
      },
    );
    on<ChangeSpecialization>(
      (event, emit) {
        dbg('ChangeSpecialization ${event.id}');
        emit(ConsultationsLoaded(
          consultations: consultationsMap,
          currentSpecialization: event.id,
        ));
      },
    );

    on<GetSpecializations>(
      (event, emit) async {
        dbg('GetSpecializations');
        emit(ConsultationsInitialLoading());
        final result = await _consultationRepository.fetchSpecializations();
        result.fold(
          (error) {
            emit(ConsultationsFailure(error.message));
          },
          (specializations) async {
            Map<int, ConsultationListModel> map = {};
            map[0] = const ConsultationListModel(consultations: []);
            for (Specialization specialization in specializations) {
              map[specialization.id] =
                  const ConsultationListModel(consultations: []);
            }
            consultationsMap = ConsultationsMapModel(
              specializations: [
                    const Specialization(
                      id: 0,
                      name: 'All',
                      image:
                          "https://static.vecteezy.com/system/resources/previews/017/580/947/original/stethoscope-logo-concept-free-vector.jpg",
                    )
                  ] +
                  specializations,
              consultationsMap: map,
            );
            emit(
              ConsultationsLoaded(
                consultations: consultationsMap,
                isInitialLoading: true,
                firstGet: true,
              ),
            );
          },
        );
      },
    );

    on<RequestConsultation>(
      (event, emit) async {
        dbg('request event');
        emit(ConsultationsInitialLoading());
        final result = await _consultationRepository.requestConsultation(
          images: event.images,
          specializationId: event.specializationId,
          title: event.title,
          description: event.description,
          consultationType: event.consultationType,
        );
        result.fold(
          (error) {
            emit(ConsultationsFailure(error.message));
          },
          (requestConsultationResponse) {
            dbg('requestConsultationResponse');
            emit(ConsultationRequested());
          },
        );
      },
    );
    on<RateConsultation>(
      (event, emit) async {
        dbg("rate bloc${event.rate}");
        emit(ConsultationRateLoading());
        final result =
            await _consultationRepository.rateConsultation(rate: event.rate,id: event.id);
        result.fold(
          (error) {
            emit(ConsultationsFailure(error.message));
          },
          (rateResponse) {
            emit(ConsultationRateSuccess());
          },
        );
      },
    );
  }
}
