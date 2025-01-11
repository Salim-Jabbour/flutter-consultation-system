import 'package:akemha/core/errors/base_error.dart';

import 'package:akemha/features/profile/model/profile_model.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/profile_remote_data_source.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl(
    this._profileRemoteDataSource,
    this._networkInfo,
  );
  @override
  Future<Either<Failure, ProfileModel>> getProfileInfo(
      String token, String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _profileRemoteDataSource.getProfileInfo(token, userId);
        return addSuccess.fold(
          (failure) => Left(failure),
          (getProfileInfo) {
            return right(getProfileInfo);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }
}
