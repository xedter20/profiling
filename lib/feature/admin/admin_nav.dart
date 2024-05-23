import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/providers/user_data_provider.dart';
import 'package:flutter_riverpod_base/feature/admin/1.%20dashboard/view/admin_dashboard.dart';
import 'package:flutter_riverpod_base/feature/admin/2.%20announcements/view/admin_announcements.dart';
import 'package:flutter_riverpod_base/feature/admin/3.%20messages/view/admin_messages.dart';
import 'package:flutter_riverpod_base/feature/admin/4.%20residents/view/admin_residents.dart';
import 'package:flutter_riverpod_base/res/themes.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminNav extends ConsumerStatefulWidget {
  const AdminNav({super.key});

  static const routePath = "/admin";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminNavState();
}

class _AdminNavState extends ConsumerState<AdminNav> {
  int page = 0;

  List<String> tabs = [
    'Dashboard',
    'Announcements',
    'Messages',
    'Residents',
  ];

  List<IconData> icons = [
    Icons.dashboard,
    Icons.announcement_outlined,
    Icons.messenger,
    Icons.people,
  ];

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      body: SafeArea(
        child: userData.when(
          data: (data) {
            return Container(
              child: Row(
                children: [
                  Card(
                    elevation: 10,
                    child: SideMenu(
                      minWidth: 110,
                      maxWidth: 325,
                      hasResizerToggle: false,
                      hasResizer: false,
                      builder: (data) => SideMenuData(
                        header: Container(
                          height: 140,
                          child: Center(
                            child: Image.asset(
                              'assets/images/barangay-logo.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                        items: List.generate(
                          tabs.length,
                          (index) => SideMenuItemDataTile(
                            isSelected: page == index,
                            hasSelectedLine: false,
                            selectedTitleStyle: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                            itemHeight: 45,
                            onTap: () {
                              setState(() {
                                page = index;
                              });
                            },
                            highlightSelectedColor: AppColors().secondaryBlue,
                            title: tabs[index],
                            titleStyle: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
                            borderRadius: BorderRadius.circular(14),
                            icon: Icon(icons[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Container(
                            height: 90,
                            padding: EdgeInsets.symmetric(horizontal: 75),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.account_circle_outlined,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.fullName ?? 'User',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 75,
                                ),
                                IconButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  icon: Icon(
                                    Icons.exit_to_app_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: page,
                            children: [
                              AdminDashboard(
                                user: data,
                              ),
                              AdminAnnouncements(),
                              AdminMessages(),
                              AdminResidents(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stack) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
