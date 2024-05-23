import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/core/firebase/fire_firestore_api.dart';
import 'package:flutter_riverpod_base/models/chat.dart';

final chatChannelProvider = StreamProvider.family((ref, String channelID) {
  final storeApi = ref.watch(firestoreApiProvider);

  final streamController = StreamController<List<ChatMessage>>();

  storeApi.getChatChannel(channelID).asStream().listen((event) {
    return event.fold((l) {}, (r) {
      r.listen((event) {
        streamController.add(event.docs
            .map(
              (e) => ChatMessage.fromJson(
                {
                  ...e.data(),
                },
              ),
            )
            .toList());
      });
    });
  });

  return streamController.stream;
});
