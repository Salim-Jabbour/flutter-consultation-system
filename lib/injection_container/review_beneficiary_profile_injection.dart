import '../core/network/network_info.dart';

import '../features/role_doctor/review_beneficiary_profile/data/datasource/remote/review_beneficiary_profile_remote_datasource.dart';
import '../features/role_doctor/review_beneficiary_profile/presentation/manager/consultation_bloc/beneficiary_consultation_bloc.dart';
import '../features/role_doctor/review_beneficiary_profile/presentation/manager/medical_record_bloc/beneficiary_medical_record_bloc.dart';
import '../features/role_doctor/review_beneficiary_profile/presentation/manager/medicines_bloc/medicines_bloc_bloc.dart';
import '../features/role_doctor/review_beneficiary_profile/presentation/manager/profile_bloc/review_beneficiary_profile_bloc.dart';
import '../features/role_doctor/review_beneficiary_profile/repository/review_beneficiary_profile_repository.dart';
import '../features/role_doctor/review_beneficiary_profile/repository/review_beneficiary_profile_repository_impl.dart';
import 'main_injection.dart';

Future<void> reviewBeneficiaryProfileInjection() async {
  //remote data source
  locator.registerLazySingleton<ReviewBeneficiaryProfileRemoteDataSource>(
    () => ReviewBeneficiaryProfileRemoteDataSourceImpl(locator.get()),
  );
  //repository
  locator.registerLazySingleton<ReviewBeneficiaryProfileRepository>(
    () => ReviewBeneficiaryProfileRepositoryImpl(
      locator.get<ReviewBeneficiaryProfileRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //profile BLoC
  locator.registerFactory(
    () => ReviewBeneficiaryProfileBloc(
      locator.get<ReviewBeneficiaryProfileRepository>(),
    ),
  );

  //medical record BLoC
  locator.registerFactory(
    () => BeneficiaryMedicalRecordBloc(
      locator.get<ReviewBeneficiaryProfileRepository>(),
    ),
  );

  //consultation BLoC
  locator.registerFactory(
    () => BeneficiaryConsultationBloc(
      locator.get<ReviewBeneficiaryProfileRepository>(),
    ),
  );

  // Medicines BLoC
  locator.registerFactory(
    () => MedicinesBlocBloc(
      locator.get<ReviewBeneficiaryProfileRepository>(),
    ),
  );
}
