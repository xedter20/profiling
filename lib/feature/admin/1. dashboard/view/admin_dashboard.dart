import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/data/barangays.dart';
import 'package:flutter_riverpod_base/feature/admin/1.%20dashboard/riverpod/new_user_today_provider.dart';
import 'package:flutter_riverpod_base/feature/admin/1.%20dashboard/riverpod/total_residents.dart';
import 'package:flutter_riverpod_base/feature/admin/2.%20announcements/riverpod/announcements_prover.dart';
import 'package:flutter_riverpod_base/models/user.dart';
import 'package:flutter_riverpod_base/res/themes.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final totalResident = ref.watch(totalResidentProvider);
    final totalAdmin = ref.watch(totalResidentProvider);
    final newUserToday = ref.watch(newUserTodayProvider);
    final announcementData = ref.watch(announcementProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'Welcome',
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
                children: [
                  TextSpan(
                    text: ' ${widget.user.fullName}!',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Here's what's happening in the barangay today",
              style: GoogleFonts.poppins(
                color: Color(0xff414141),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 8,
                  )
                ],
              ),
              child: totalResident.when(
                data: (data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.length.toString(),
                        style: GoogleFonts.poppins(
                          color: AppColors().secondaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total Residents this year',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ],
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
            const SizedBox(
              height: 20,
            ),
            Text(
              "Total users per purok: ",
              style: GoogleFonts.poppins(
                color: Color(0xff414141),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            totalResident.when(
              data: (data) {
                return Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  children: List.generate(
                    purok.length,
                    (index) => Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.where((element) => element.purok == purok[index]).length.toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors().secondaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Total Residents in  ${purok[index]}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
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
            const SizedBox(
              height: 20,
            ),
            Text(
              "Announcements: ",
              style: GoogleFonts.poppins(
                color: Color(0xff414141),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
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
          ],
        ),
      ),
    );
  }
}
