import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pet_store_app/core/routes/route_name.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/core/utils/responsive_extension.dart';
import 'package:pet_store_app/core/utils/validators.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/register/register_bloc.dart';
import 'package:pet_store_app/presentation/bloc/register/register_event.dart';
import 'package:pet_store_app/presentation/bloc/register/register_state.dart';
import 'package:pet_store_app/presentation/widgets/custom_app_bar.dart';
import 'package:pet_store_app/presentation/widgets/custom_button.dart';
import 'package:pet_store_app/presentation/widgets/custom_textformfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          context.goNamed(RouteNames.loginName);
          return;
        }

        if (state is RegisterFailure) {
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
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            initialValue: state.username,
                            onChanged: (value) {
                              context.read<RegisterBloc>().add(
                                UsernameChanged(value),
                              );
                            },
                            validator: (value) => AppValidators.validateRequired(
                              value,
                              fieldName: 'username',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'First name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextFormField(
                                      initialValue: state.firstName,
                                      onChanged: (value) {
                                        context.read<RegisterBloc>().add(
                                          FirstNameChanged(value),
                                        );
                                      },
                                      validator: (value) => AppValidators.validateRequired(
                                        value,
                                        fieldName: 'first name',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Last name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextFormField(
                                      initialValue: state.lastName,
                                      onChanged: (value) {
                                        context.read<RegisterBloc>().add(
                                          LastNameChanged(value),
                                        );
                                      },
                                      validator: (value) => AppValidators.validateRequired(
                                        value,
                                        fieldName: 'last name',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Email address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            initialValue: state.email,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              context.read<RegisterBloc>().add(EmailChanged(value));
                            },
                            validator: AppValidators.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            initialValue: state.password,
                            obscureText: true,
                            onChanged: (value) {
                              context.read<RegisterBloc>().add(PasswordChanged(value));
                            },
                            validator: AppValidators.validatePassword,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Phone number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            initialValue: state.phone,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              context.read<RegisterBloc>().add(PhoneChanged(value));
                            },
                            validator: AppValidators.validatePhone,
                          ),
                          SizedBox(height: context.h(3)),
                          CustomButton(
                            buttonWidth: double.infinity,
                            buttonHeight: 48,
                            text: isLoading ? 'Registering...' : 'Register',
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<RegisterBloc>().add(
                                      SubmitRegisterEvent(),
                                    );
                                  },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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