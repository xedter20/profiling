import 'package:age_calculator/age_calculator.dart';
import 'package:async_button/async_button.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/data/barangays.dart';
import 'package:flutter_riverpod_base/feature/authentication/controller/auth_controller.dart';
import 'package:flutter_riverpod_base/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../commons/views/widgets/buttons.dart';
import '../../../../commons/views/widgets/fields.dart';
import '../../../../res/themes.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final middleNameCtrl = TextEditingController();
  DateTime? dateOfBirth;
  final ageCtrl = TextEditingController();
  String? maritalStatus;
  final contactCtrl = TextEditingController();
  final birthplaceCtrl = TextEditingController();

  AsyncBtnStatesController btnStateController = AsyncBtnStatesController();

  final formKey = GlobalKey<FormState>();
  String? selectedPurok;
  String? selectedGender;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  AppFieldNormal(controller: lastNameCtrl, fieldName: "Last Name"),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFieldNormal(controller: firstNameCtrl, fieldName: "First Name"),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFieldNormal(controller: middleNameCtrl, fieldName: "Middle Name"),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFieldEmail(controller: emailCtrl),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFieldPassword(
                    controller: passwordCtrl,
                    isRegister: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter Birthday',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter date';
                      } else if (AgeCalculator.age(dateOfBirth!).years < 18) {
                        return "Age must be greater than 18";
                      }
                      return null;
                    },
                    mode: DateTimeFieldPickerMode.date,
                    firstDate: DateTime(1700),
                    lastDate: DateTime.now(),
                    initialPickerDateTime: DateTime.now(),
                    onChanged: (DateTime? value) {
                      dateOfBirth = value;
                      //caculate age
                      ageCtrl.text = AgeCalculator.age(dateOfBirth!).years.toString();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFieldNormal(controller: ageCtrl, fieldName: "Age"),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    value: selectedGender,
                    hint: const Text("Select a gender"),
                    decoration: InputDecoration(
                      labelText: 'Select a gender',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please select a gender";
                      }
                      return null;
                    },
                    items: [
                      DropdownMenuItem(
                        value: "Female",
                        child: Text(
                          "Female",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Male",
                        child: Text(
                          "Male",
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedGender = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    value: maritalStatus,
                    hint: const Text("Select marital status"),
                    decoration: InputDecoration(
                      labelText: 'Select marital status',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please select marital status";
                      }
                      return null;
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'Single',
                        child: Text('Single'),
                      ),
                      DropdownMenuItem(
                        value: 'Married',
                        child: Text('Married'),
                      ),
                      DropdownMenuItem(
                        value: 'Divorced',
                        child: Text('Divorced'),
                      ),
                      DropdownMenuItem(
                        value: 'Widowed',
                        child: Text('Widowed'),
                      ),
                      DropdownMenuItem(
                        value: 'Separated',
                        child: Text('Separated'),
                      ),
                    ],
                    onChanged: (value) {
                      maritalStatus = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: maritalStatus == "Married",
                    child: Column(
                      children: [
                        AppFieldNormal(controller: TextEditingController(), fieldName: "Spouse Last Name"),
                        const SizedBox(
                          height: 20,
                        ),
                        AppFieldNormal(controller: TextEditingController(), fieldName: "Spouse First Name"),
                        const SizedBox(
                          height: 20,
                        ),
                        AppFieldNormal(controller: TextEditingController(), fieldName: "SpouseMiddle Name"),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  AppFieldNormal(controller: birthplaceCtrl, fieldName: "Birthplace"),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    value: selectedPurok,
                    hint: const Text("Select a Purok"),
                    decoration: InputDecoration(
                      labelText: 'Select Purok',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please select a Purok";
                      }
                      return null;
                    },
                    items: List.generate(
                      purok.length,
                      (index) => DropdownMenuItem(
                        value: purok[index],
                        child: Text(
                          purok[index],
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      selectedPurok = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppFieldNormal(controller: contactCtrl, fieldName: "Contact Number"),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AsyncButtonFlat(
              AsyncBtnStatesController: btnStateController,
              bgColor: AppColors().primaryBlue,
              fgColor: AppColors().white,
              text: "Signup",
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  btnStateController.update(AsyncBtnState.loading);
                  screenshotController.capture().then((image) {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            content: SizedBox(
                              child: Image.memory(
                                image!,
                              ),
                            ),
                            title: Text('Please confirm\nif all details are correct: '),
                            titleTextStyle: GoogleFonts.poppins(
                              color: AppColors().primaryBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            scrollable: true,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  UserModel user = UserModel(
                                    fullName: "${firstNameCtrl.text} ${lastNameCtrl.text}",
                                    email: emailCtrl.text,
                                    gender: selectedGender!,
                                    //start here
                                    purok: selectedPurok!,
                                    birthday: dateOfBirth!,
                                    age: ageCtrl.text,
                                    status: maritalStatus,
                                    birthplace: birthplaceCtrl.text,
                                  );

                                  try {
                                    final auth = ref.watch(authControllerProvider);
                                    await auth.signUpEmail(emailCtrl.text, passwordCtrl.text, user);
                                    EasyLoading.showSuccess('Welcome Back');
                                    btnStateController.update(AsyncBtnState.success);
                                  } catch (e) {
                                    btnStateController.update(AsyncBtnState.failure);
                                  }
                                },
                                child: Text('Continue'),
                              ),
                            ],
                          );
                        });
                    btnStateController.update(AsyncBtnState.success);
                  }).catchError((onError) {
                    btnStateController.update(AsyncBtnState.failure);
                  });
                } else {
                  EasyLoading.showError('Please fill all fields');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
