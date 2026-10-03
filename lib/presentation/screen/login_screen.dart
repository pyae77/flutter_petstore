import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pet_store_app/core/routes/route_name.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/core/utils/validators.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/login/login_bloc.dart';
import 'package:pet_store_app/presentation/bloc/login/login_event.dart';
import 'package:pet_store_app/presentation/bloc/login/login_state.dart';
import 'package:pet_store_app/presentation/widgets/custom_button.dart';
import 'package:pet_store_app/presentation/widgets/custom_text_widget.dart';
import 'package:pet_store_app/presentation/widgets/custom_textformfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome back, ${state.user.userName}!')),
          );
          context.goNamed(RouteNames.mainHomeName);
          return;
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset(
                          Assets.icons.icCoco.path,
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 40),
                        CustomTextFormField(
                          initialValue: state.username,
                          prefixIcon: Image.asset(
                            Assets.icons.icPerson.path,
                            width: 16,
                            height: 16,
                            color: AppColors.grey1,
                          ),
                          labelText: 'Username',
                          onChanged: (value) {
                            context.read<LoginBloc>().add(UsernameChanged(value));
                          },
                          validator: (value) => AppValidators.validateRequired(
                            value,
                            fieldName: 'username',
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          initialValue: state.password,
                          prefixIcon: Image.asset(
                            Assets.icons.icLock.path,
                            width: 16,
                            height: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(
                                TogglePasswordVisibility(),
                              );
                            },
                            icon: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          labelText: 'Password',
                          obscureText: !state.isPasswordVisible,
                          onChanged: (value) {
                            context.read<LoginBloc>().add(PasswordChanged(value));
                          },
                          validator: AppValidators.validatePassword,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: isLoading ? 'Logging in...' : 'Log in',
                          buttonWidth: double.infinity,
                          buttonHeight: 50,
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<LoginBloc>().add(
                                    SubmitLoginEvent(),
                                  );
                                },
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.registerName);
                          },
                          child: const CustomTextWidget(text: 'Create account'),
                        ),
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
