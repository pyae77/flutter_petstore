import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_store_app/core/routes/route_name.dart';
import 'package:pet_store_app/core/utils/responsive_extension.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:pet_store_app/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:pet_store_app/presentation/bloc/onboarding/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<OnboardingItem> _items = [
    OnboardingItem(
      logoImage: 'logo',
      title: 'Hey! Welcome',
      description:
          'Find the best premium & nutritious food\nfor your furry friends',
      buttonText: 'Next',
    ),
    OnboardingItem(
      title: 'Healthy & Tasty!',
      description:
          'One tap to order dry food, wet food,\ntreats & organic meals\n\nTailored for all breeds & ages\n\nFast & doorstep delivery',
      buttonText: 'Next',
    ),
    OnboardingItem(
      title: 'We Provide',
      description:
          '100% authentic pet food brands\n\nDaily feeding guide & nutrition plans\n\nAuto-refill & subscription options',
      buttonText: 'Get Started',
    ),
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed(BuildContext context, int currentIndex) {
    if (currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(RouteNames.registerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    Assets.images.dog1.path,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: context.h(42),
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).padding.bottom + 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _items.length,
                            (dotIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 22,
                              height: 8,
                              decoration: BoxDecoration(
                                color: state.pageIndex == dotIndex
                                    ? const Color(0xFF52B467)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: state.pageIndex == dotIndex
                                      ? const Color(0xFF52B467)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _items.length,
                            onPageChanged: (index) {
                              context.read<OnboardingBloc>().add(
                                OnboardingPageChangedEvent(index),
                              );
                            },
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              final logoPath = index == 0
                                  ? Assets.icons.icCoco.path
                                  : null;

                              return SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (logoPath != null)
                                      Image.asset(
                                        logoPath,
                                        height: context.h(10),
                                      )
                                    else
                                      SizedBox(height: context.h(10)),
                                    SizedBox(height: context.h(1)),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: context.h(1)),
                                    Text(
                                      item.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        height: 1.3,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () =>
                                _onNextPressed(context, state.pageIndex),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF52B467),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _items[state.pageIndex].buttonText,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                          child: state.pageIndex == _items.length - 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed(
                                            RouteNames.loginName,
                                          );
                                        },
                                        child: const Text(
                                          'Log in',
                                          style: TextStyle(
                                            color: Color(0xFF52B467),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OnboardingItem {
  final String? logoImage;
  final String title;
  final String description;
  final String buttonText;

  const OnboardingItem({
    this.logoImage,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
