import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/core/firebase/fire_firestore_api.dart';
import 'package:flutter_riverpod_base/models/announcement.dart';

final announcementProvider = StreamProvider((ref) {
  final storeApi = ref.watch(firestoreApiProvider);

  final streamController = StreamController<List<Announcement>>();

  storeApi.getAllAnnouncement().asStream().listen((event) {
    return event.fold((l) {}, (r) {
      r.listen((event) {
        streamController.add(event.docs
            .map((e) => Announcement.fromJson({
                  ...e.data(),
                  'id': e.id,
                }))
            .toList());
      });
    });
  });

  return streamController.stream;
});
