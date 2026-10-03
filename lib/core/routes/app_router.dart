import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pet_store_app/core/di/injection_container.dart';
import 'package:pet_store_app/core/routes/route_name.dart';
import 'package:pet_store_app/presentation/bloc/admin_management/admin_pet_bloc.dart';
import 'package:pet_store_app/presentation/bloc/login/login_bloc.dart';
import 'package:pet_store_app/presentation/bloc/register/register_bloc.dart';
import 'package:pet_store_app/presentation/screen/admin_screen.dart';
import 'package:pet_store_app/presentation/screen/login_screen.dart';
import 'package:pet_store_app/presentation/screen/main_home_screen.dart';
import 'package:pet_store_app/presentation/screen/onboarding_screen.dart';
import 'package:pet_store_app/presentation/screen/register_screen.dart';
import 'package:pet_store_app/presentation/screen/splash_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.registerName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<RegisterBloc>(),
            child: const RegisterScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<LoginBloc>(),
            child: const LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteNames.mainHome,
        name: RouteNames.mainHomeName,
        builder: (context, state) => const MainHomeScreen(),
      ),
      GoRoute(
        path: RouteNames.adminManageScreen,
        name: RouteNames.adminManageScreenName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<AdminPetBloc>(),
            child: const AdminScreen(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const Scaffold(body: Center(child: Text('Page Not Found')));
    },
  );
}
