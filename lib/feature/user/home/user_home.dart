import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/providers/user_data_provider.dart';
import 'package:flutter_riverpod_base/commons/views/dialogs/chat_dialog.dart';
import 'package:flutter_riverpod_base/feature/admin/2.%20announcements/riverpod/announcements_prover.dart';
import 'package:flutter_riverpod_base/res/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  static const routePath = "/user";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final announcementData = ref.watch(announcementProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (builder) {
                return UserChatDialog(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  isAdmin: false,
                );
              });
        },
        child: Icon(
          Icons.message_outlined,
        ),
        backgroundColor: AppColors().secondaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      body: SafeArea(
        child: userData.when(
          data: (data) {
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        data.fullName ?? 'User',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Icon(
                          Icons.logout_outlined,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Announcements',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: announcementData.when(
                          data: (announcementData) {
                            return Column(
                              children: List.generate(
                                announcementData.length,
                                (index) => Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              announcementData[index].title!,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            announcementData[index].datePosted!.toString().substring(0, 10),
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        announcementData[index].content!,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          error: (error, stack) {
                            return Text(error.toString());
                          },
                          loading: () {
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          },
          error: (error, stack) {
            return Text(error.toString());
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
