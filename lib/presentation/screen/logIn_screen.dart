import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app/core/routes/route_name.dart';
import 'package:my_test_app/core/theme/app_colors.dart';
import 'package:my_test_app/gen/assets.gen.dart';
import 'package:my_test_app/presentation/bloc/log_in/log_in_bloc.dart';
import 'package:my_test_app/presentation/bloc/log_in/log_in_event.dart';
import 'package:my_test_app/presentation/bloc/log_in/log_in_state.dart';
import 'package:my_test_app/presentation/widgets/custom_button.dart';
import 'package:my_test_app/presentation/widgets/custom_text_widget.dart';
import 'package:my_test_app/presentation/widgets/custom_textformfield.dart';

final TextEditingController _usernameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  void _onLoginPressed(BuildContext context) {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    context.read<LoginBloc>().add(
          SubmitLoginEvent(username: username, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          debugPrint('--- Login Successful ---');
          debugPrint('Username: ${state.user.userName}');
          debugPrint('Email: ${state.user.email}');
          debugPrint('Phone: ${state.user.phone}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome ${state.user.userName}!')),
          );
          
          _usernameController.clear();
          _passwordController.clear();
          context.goNamed(RouteNames.mainHomeName);
        } else if (state is LoginFailure) {
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
                      // Username Input
                      CustomTextFormField(
                        controller: _usernameController,
                        prefixIcon: Image.asset(
                          Assets.icons.icPerson.path,
                          width: 16,
                          height: 16,
                          color: AppColors.grey1,
                        ),
                       
                        labelText: 'User Name',
                      ),
                      const SizedBox(height: 16),

                      
                     CustomTextFormField(
  controller: _passwordController,
  prefixIcon: Image.asset(
    Assets.icons.icLock.path,
    width: 16,
    height: 16,
  ),
  suffixIcon: IconButton(
    onPressed: () {
      context.read<LoginBloc>().add(PasswordIconEvent());
    },
    icon: Icon(
      state.isPasswordVisible 
          ? Icons.visibility 
          : Icons.visibility_off,
    ),
  ),
  labelText: 'Password',
  obscureText: !state.isPasswordVisible, 
),
                      const SizedBox(height: 24),

                      // LogIn Button
                      CustomButton(
                        text: isLoading ? 'Logging in...' : 'LogIn',
                        buttonWidth: double.infinity,
                        buttonHeight: 50,
                        onPressed: isLoading ? null : () => _onLoginPressed(context),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: (){
                          context.pushNamed(RouteNames.registerName);
                        },
                        child: CustomTextWidget(text: 'Create Account'))
                    ],
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