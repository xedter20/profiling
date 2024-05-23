import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/models/announcement.dart';
import 'package:flutter_riverpod_base/models/user.dart';
import 'package:flutter_riverpod_base/utils/logger.dart';
import 'package:fpdart/fpdart.dart';

import '../../commons/providers/fire_auth_provider.dart';

final firestoreApiProvider = StateProvider<FirestoreApi>((ref) {
  final userId = ref.watch(userIdProvider);
  return FirestoreApi(userID: userId.value ?? '');
});

class FirestoreApi {
  String userID;
  FirestoreApi({required this.userID});

  final _users = FirebaseFirestore.instance.collection('Users');
  final _announcements = FirebaseFirestore.instance.collection('Announcements');
  final _chats = FirebaseFirestore.instance.collection('Chats');

  Future<Either<String, String>> createUser(UserModel user) async {
    try {
      Log().info('Creating user with userId: $userID');
      await _users.doc(userID).set(user.toJson());

      return const Right('Firestore: Create user successfull');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<DocumentSnapshot<Map<String, dynamic>>>>> getUser() async {
    try {
      Log().info('Getting user with userId: $userID');
      final user = _users.doc(userID).snapshots();
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>> getAllUsers() async {
    try {
      final user = _users.where('type', isEqualTo: "user").snapshots();
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>> getAllAdmins() async {
    try {
      final user = _users.where('type', isEqualTo: "admin").snapshots();
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>> newUsersToday() async {
    try {
      Log().info('Getting user with userId: $userID');
      final user = _users
          .where('type', isEqualTo: "user")
          .where('createdAt', isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 1)))
          .snapshots();
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>> getAllAnnouncement() async {
    try {
      Log().info('Getting user with userId: $userID');
      final announcement = _announcements.orderBy('datePosted', descending: true).snapshots();
      return Right(announcement);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> addAnnouncement(Announcement announcement) async {
    try {
      Log().info('Getting user with userId: $userID');
      final result = await _announcements.doc().set(announcement.toJson());
      return Right('success');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Stream<QuerySnapshot<Map<String, dynamic>>>>> getChatChannel(String channelID) async {
    try {
      final announcement = _chats.doc(channelID).collection('messages').orderBy('dateTime', descending: false).snapshots();
      return Right(announcement);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
