import 'package:async_button/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/providers/user_data_provider.dart';
import 'package:flutter_riverpod_base/commons/views/widgets/buttons.dart';
import 'package:flutter_riverpod_base/commons/views/widgets/fields.dart';
import 'package:flutter_riverpod_base/core/firebase/fire_firestore_api.dart';
import 'package:flutter_riverpod_base/models/announcement.dart';
import 'package:flutter_riverpod_base/res/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAnnouncement extends ConsumerStatefulWidget {
  const AddAnnouncement({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends ConsumerState<AddAnnouncement> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  AsyncBtnStatesController btnStateController = AsyncBtnStatesController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(30),
        width: 500,
        height: 600,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Announcement',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              AppFieldNormal(
                controller: titleController,
                fieldName: 'Title',
              ),
              const SizedBox(height: 20),
              AppFieldNormal(
                controller: contentController,
                maxLines: 10,
                fieldName: 'Content',
              ),
              const SizedBox(height: 20),
              AsyncButtonFlat(
                AsyncBtnStatesController: btnStateController,
                bgColor: AppColors().primaryBlue,
                fgColor: AppColors().white,
                text: "Add Anouncement",
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    btnStateController.update(AsyncBtnState.loading);

                    try {
                      final storeApi = ref.read(firestoreApiProvider);
                      final userData = ref.read(userDataProvider);
                      await storeApi.addAnnouncement(
                        Announcement(
                          title: titleController.text,
                          content: contentController.text,
                          datePosted: DateTime.now(),
                          postedBy: userData.value!.fullName,
                        ),
                      );
                      EasyLoading.showSuccess('Announcement Added');
                      btnStateController.update(AsyncBtnState.success);
                      Navigator.of(context).pop();
                    } catch (e) {
                      btnStateController.update(AsyncBtnState.failure);
                    }
                  } else {
                    EasyLoading.showError('Please fill all fields');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
