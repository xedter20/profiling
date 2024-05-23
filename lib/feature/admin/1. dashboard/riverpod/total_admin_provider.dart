import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/core/firebase/fire_firestore_api.dart';
import 'package:flutter_riverpod_base/models/user.dart';

final totalAdminProvider = StreamProvider((ref) {
  final storeApi = ref.watch(firestoreApiProvider);

  final streamController = StreamController<List<UserModel>>();

  storeApi.getAllAdmins().asStream().listen((event) {
    return event.fold((l) {}, (r) {
      r.listen((event) {
        streamController.add(event.docs.map((e) => UserModel.fromJson(e.data())).toList());
      });
    });
  });

  return streamController.stream;
});
