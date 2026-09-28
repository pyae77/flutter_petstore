import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app/core/di/injection_container.dart';
import 'package:my_test_app/core/routes/route_name.dart';
import 'package:my_test_app/presentation/bloc/admin_management/admin_pet_bloc.dart';
import 'package:my_test_app/presentation/bloc/log_in/log_in_bloc.dart';
import 'package:my_test_app/presentation/bloc/register/register_bloc.dart';
import 'package:my_test_app/presentation/screen/admin_screen.dart';
import 'package:my_test_app/presentation/screen/logIn_screen.dart';
import 'package:my_test_app/presentation/screen/main_home_screen.dart';
import 'package:my_test_app/presentation/screen/onboarding_screen.dart';
import 'package:my_test_app/presentation/screen/register_screen.dart';
import 'package:my_test_app/presentation/screen/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboardingName,
        builder: (context, state) =>  OnboardingScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.registerName,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<RegisterBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        builder: (context, state) => BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: const LogInScreen(),
          ),
        routes: [
        GoRoute(
          path: RouteNames.mainHome, 
          name: RouteNames.mainHomeName,
          builder: (context, state) =>  MainHomeScreen(),
        ),
      ],
      ),
         GoRoute(
        path: RouteNames.adminManageScreen,
        name: RouteNames.adminManageScreenName,
        builder: (context, state) => BlocProvider(
       create: (context) => sl<AdminPetBloc>(),
       child: const AdminScreen(),
  ),
      ),
       
     
      
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Page Not Found')),
    ),
  );
}