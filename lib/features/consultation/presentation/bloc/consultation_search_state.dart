part of 'consultation_search_cubit.dart';

@immutable
sealed class ConsultationSearchState {}

final class ConsultationSearchInitial extends ConsultationSearchState {}

final class ConsultationSearchLoading extends ConsultationSearchState {}

final class ConsultationSearchLoaded extends ConsultationSearchState {
  final int page;

  ConsultationSearchLoaded(this.page);
}

final class ConsultationSearchReachMax extends ConsultationSearchState {}

final class ConsultationSearchFailure extends ConsultationSearchState {
  final String errMessage;

  ConsultationSearchFailure(this.errMessage);
}
