import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/core/firebase/fire_firestore_api.dart';
import 'package:flutter_riverpod_base/models/user.dart';
import 'package:flutter_riverpod_base/utils/logger.dart';
import 'package:fpdart/fpdart.dart';

final authStoreRepoProvider = StateProvider<StoreAuthRepo>((ref) {
  final api = ref.watch(firestoreApiProvider);
  return StoreAuthRepo(firestoreApi: api);
});

class StoreAuthRepo {
  FirestoreApi firestoreApi;

  StoreAuthRepo({required this.firestoreApi});

  Future<Either<String, String>> createUser(UserModel user) async {
    final result = await firestoreApi.createUser(user);

    return result.fold((error) {
      Log().error(error);
      return Left(error);
    }, (success) {
      Log().info('Account created in firestore');
      return Right(success);
    });
  }
}
