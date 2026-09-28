import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app/core/routes/route_name.dart';
import 'package:my_test_app/core/theme/app_colors.dart';
import 'package:my_test_app/core/utils/responsive_extension.dart';
import 'package:my_test_app/domain/entity/user_entity.dart';
import 'package:my_test_app/gen/assets.gen.dart';
import 'package:my_test_app/presentation/bloc/register/register_bloc.dart';
import 'package:my_test_app/presentation/bloc/register/register_event.dart';
import 'package:my_test_app/presentation/bloc/register/register_state.dart';
import 'package:my_test_app/presentation/widgets/custom_app_bar.dart';
import 'package:my_test_app/presentation/widgets/custom_button.dart';
import 'package:my_test_app/presentation/widgets/custom_textformfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final user = UserEntity(
      id: 0,
      userName: _usernameController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
      userStatus: 1,
    );

    context.read<RegisterBloc>().add(SubmitRegisterEvent(user));
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registered successfully!')),
          );
          context.goNamed(RouteNames.loginName);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;

        return PopScope(
          canPop: !isLoading,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: CustomAppBar(
                leading: Assets.icons.icArrowLeft.path,
                leadingPressed: isLoading
                    ? null
                    : () {
                        context.goNamed(RouteNames.onboardingName);
                      },
              ),
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: isLoading
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.h(1.5)),

                        Center(
                          child: Image.asset(
                            Assets.icons.icCoco.path,
                            width: context.h(18),
                            height: context.h(18),
                          ),
                        ),

                        SizedBox(height: context.h(2)),

                        // 1. Username
                        const Text('Enter your username', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 16),

                        // 2. First Name & Last Name
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('First name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  CustomTextFormField(
                                    controller: _firstNameController,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Last name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  CustomTextFormField(
                                    controller: _lastNameController,
                                  
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 3. Email Address
                        const Text('Enter an email address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // 4. Password
                        const Text('Enter password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 16),

                        // 5. Phone Number
                        const Text('Enter phone number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: context.h(3)),

                        // Register Button
                        CustomButton(
                          buttonWidth: double.infinity,
                          buttonHeight: 48,
                          text: isLoading ? 'Registering...' : 'Register',
                          onPressed: isLoading ? null : _onRegisterPressed,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}