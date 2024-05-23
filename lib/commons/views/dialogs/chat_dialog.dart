import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/providers/chat_channel_provider.dart';
import 'package:flutter_riverpod_base/commons/providers/user_data_provider.dart';
import 'package:flutter_riverpod_base/models/chat.dart';
import 'package:flutter_riverpod_base/models/user.dart';
import 'package:google_fonts/google_fonts.dart';

class UserChatDialog extends ConsumerStatefulWidget {
  const UserChatDialog({super.key, required this.userId, required this.isAdmin});

  final String userId;
  final bool isAdmin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<UserChatDialog> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final chatData = ref.watch(chatChannelProvider(widget.userId));

    return Dialog(
        child: userData.when(
      data: (data) {
        return chatData.when(
          data: (chatData) {
            return Conversation(widget: widget, userData: data, messages: chatData);
          },
          error: (error, stack) {
            return Text(error.toString());
          },
          loading: () {
            return Conversation(widget: widget, userData: data, messages: []);
          },
        );
      },
      error: (error, stack) {
        return Text(error.toString());
      },
      loading: () {
        return Text('Loading...');
      },
    ));
  }
}

class Conversation extends StatelessWidget {
  Conversation({
    super.key,
    required this.widget,
    required this.userData,
    required this.messages,
  });

  final ScrollController _controller = ScrollController();

  final UserChatDialog widget;
  final UserModel userData;
  final List<ChatMessage> messages;

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 10));
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    return Container(
      padding: const EdgeInsets.all(30),
      width: 500,
      height: 700,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                ),
                SizedBox(
                  width: 7,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection("Users").doc(widget.userId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        widget.isAdmin ? snapshot.data!['fullName'] : 'Barangay Admin',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }
                    return Text(
                      'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 7,
                ),
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.green,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            controller: _controller,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              bool isMine = userData.fullName == messages[index].senderName;
              bool isAdminMsg = messages[index].isAdmin == true && widget.isAdmin == true;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: isMine || isAdminMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${messages[index].senderName}",
                      style: GoogleFonts.aleo(),
                    ),
                    Material(
                      borderRadius: BorderRadius.only(
                        topLeft: isMine || isAdminMsg ? const Radius.circular(30.0) : Radius.zero,
                        topRight: isMine || isAdminMsg ? Radius.zero : const Radius.circular(30.0),
                        bottomLeft: const Radius.circular(30.0),
                        bottomRight: const Radius.circular(30.0),
                      ),
                      elevation: 0,
                      color: isMine || isAdminMsg ? Colors.blue : Colors.grey.shade400,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          "${messages[index].message}",
                          style: TextStyle(
                            color: isMine || isAdminMsg ? Colors.white : Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.poppins(),
                      filled: true,
                      isDense: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Chats').doc(widget.userId).collection('messages').add(
                          ChatMessage(
                            message: messageController.text,
                            senderName: userData.fullName,
                            dateTime: DateTime.now(),
                            isAdmin: widget.isAdmin,
                          ).toJson(),
                        );
                  },
                  icon: Icon(
                    Icons.send,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
