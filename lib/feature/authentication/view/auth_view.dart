import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/commons/providers/fire_auth_provider.dart';
import 'package:flutter_riverpod_base/feature/authentication/view/widgets/login_form.dart';
import 'package:flutter_riverpod_base/feature/authentication/view/widgets/register_form.dart';
import 'package:flutter_riverpod_base/feature/user/home/user_home.dart';
import 'package:flutter_riverpod_base/res/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../res/strings.dart';
import '../../../utils/logger.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  static const routePath = "/auth";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  List<String> options = ['Login', 'Register'];

  PageController pageController = PageController(initialPage: 0);

  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final userId = ref.watch(userIdProvider);

    ref.listen(
      userIdProvider,
      (previous, next) {
        if (next.value != null) {
          Log().info("User is logged in");
          GoRouter.of(context).pushReplacement(UserHome.routePath);
        } else {
          Log().info("User is not logged in");
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/barangay-logo.png',
                width: 300,
                height: 300,
              ),
            ),
            Center(
              child: DefaultTabController(
                length: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 500,
                  color: Colors.white.withAlpha(200),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TabBar(
                          labelColor: AppColors().primaryBlue,
                          indicatorColor: AppColors().primaryBlue,
                          onTap: (int index) {
                            currIndex = index;
                            setState(() {});
                          },
                          tabs: [
                            Tab(
                              child: Text(
                                options[0],
                              ),
                            ),
                            Tab(
                              child: Text(
                                options[1],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: currIndex == 1 ? 600 : 400,
                          width: 400,
                          child: TabBarView(
                            children: const [
                              LoginForm(),
                              RegisterForm(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
