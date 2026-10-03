import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_store_app/core/di/injection_container.dart';
import 'package:pet_store_app/core/routes/route_name.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/splash/splash_bloc.dart';
import 'package:pet_store_app/presentation/bloc/splash/splash_event.dart';
import 'package:pet_store_app/presentation/bloc/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> animationKeyNotifier = ValueNotifier<int>(0);

    return BlocProvider(
      create: (context) => sl<SplashBloc>()..add(SplashAppStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashFirstTime) {
            context.goNamed(RouteNames.onboardingName);
          } else if (state is SplashAuthenticated) {
            context.goNamed(RouteNames.mainHomeName);
          } else if (state is SplashUnauthenticated) {
            context.goNamed(RouteNames.loginName);
          }
        },
        child: Scaffold(
          body: Container(
            color: AppColors.primaryGreen,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.images.dogCartoon.path,
                  width: 350,
                  height: 350,
                ),
                ValueListenableBuilder<int>(
                  valueListenable: animationKeyNotifier,
                  builder: (context, key, child) {
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(key),
                      tween: Tween<double>(begin: -1.0, end: 2.0),
                      duration: const Duration(milliseconds: 1500),
                      onEnd: () {
                        animationKeyNotifier.value++;
                      },
                      builder: (context, value, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: const [
                                Colors.white38,
                                Colors.white,
                                Color.fromARGB(255, 31, 218, 34),
                                Colors.white38,
                              ],
                              stops: const [0.0, 0.4, 0.6, 1.0],
                              transform: _SlidingGradientTransform(
                                slidePercent: value,
                              ),
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}