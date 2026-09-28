import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app/core/di/injection_container.dart';
import 'package:my_test_app/core/routes/route_name.dart';
import 'package:my_test_app/core/theme/app_colors.dart';
import 'package:my_test_app/core/utils/responsive_extension.dart';
import 'package:my_test_app/data/model/user_model.dart';
import 'package:my_test_app/gen/assets.gen.dart';
import 'package:my_test_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:my_test_app/presentation/bloc/profile/profile_event.dart';
import 'package:my_test_app/presentation/bloc/profile/profile_state.dart';
import 'package:my_test_app/presentation/widgets/custom_button.dart';
import 'package:my_test_app/presentation/widgets/custom_textformfield.dart';
import 'package:my_test_app/presentation/widgets/custom_text_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(LoadProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutSuccessState) {
            context.goNamed(RouteNames.loginName);
          } else if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
            );
          }

          UserModel? user;
          if (state is ProfileLoadedState) {
            user = state.user;
          }

          final fullName = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
          final displayName = fullName.isNotEmpty ? fullName : (user?.userName ?? 'N/A');

          return Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(4),
                vertical: context.h(2),
              ),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: context.w(12),
                          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.person,
                            size: context.w(14),
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        SizedBox(height: context.h(1.5)),
                        CustomTextWidget(
                          text: displayName,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: context.h(0.5)),
                        CustomTextWidget(
                          text: '@${user?.userName ?? 'user'}  •  User',
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.h(3)),
                  _buildSectionHeader('PERSONAL INFORMATION'),
                  SizedBox(height: context.h(1)),

                  _buildInfoTile(
                    context,
                    icon: Assets.icons.icPerson.path,
                    label: 'Full Name',
                    value: displayName,
                  ),
                  _buildInfoTile(
                    context,
                    icon: Assets.icons.icMail.path,
                    label: 'Email',
                    value: user?.email ?? 'N/A',
                  ),
                  _buildInfoTile(
                    context,
                    icon: Assets.icons.icPhone.path,
                    label: 'Phone',
                    value: user?.phone ?? 'N/A',
                  ),
                  _buildActionTile(
                    context,
                    icon: Assets.icons.icEdit.path,
                    label: 'Edit Information',
                    iconColor: AppColors.primaryGreen,
                    onTap: () => _showEditProfileDialog(context, user),
                  ),

                  SizedBox(height: context.h(3)),

                  _buildSectionHeader('ACCOUNT ACTIONS'),
                  SizedBox(height: context.h(1)),

                  _buildActionTile(
                    context,
                    icon: Assets.icons.icLogOut.path,
                    label: 'Logout',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomTextWidget(
        text: title,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: context.h(1)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(3),
        vertical: context.h(1.2),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            color: Colors.grey.shade700,
            width: 20,
            height: 20,
          ),
          SizedBox(width: context.w(3)),
          CustomTextWidget(
            text: label,
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
          const Spacer(),
          CustomTextWidget(
            text: value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(1)),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: context.w(3)),
        leading: Image.asset(
          icon,
          color: iconColor,
          width: 20,
          height: 20,
        ),
        title: CustomTextWidget(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserModel? currentUser) {
    final firstNameController = TextEditingController(text: currentUser?.firstName ?? '');
    final lastNameController = TextEditingController(text: currentUser?.lastName ?? '');
    final passwordController = TextEditingController(text: currentUser?.password ?? '');
    final phoneController = TextEditingController(text: currentUser?.phone ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CustomTextWidget(
          text: 'Edit Profile',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.h(1)),
              // 1. First Name Field
              CustomTextFormField(
                controller: firstNameController,
                labelText: 'First Name',
                hintText: 'Enter your first name',
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
              SizedBox(height: context.h(1.5)),

              // 2. Last Name Field
              CustomTextFormField(
                controller: lastNameController,
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                prefixIcon: const Icon(Icons.person_outline, size: 20),
              ),
              SizedBox(height: context.h(1.5)),

              // 3. Password Field
              CustomTextFormField(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'Enter new password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
              ),
              SizedBox(height: context.h(1.5)),

              // 4. Phone Field
              CustomTextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                labelText: 'Phone',
                hintText: 'Enter your phone number',
                prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonHeight: context.h(4.5),
                  backgroundColor: Colors.grey.shade200,
                  onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                  child: const CustomTextWidget(
                    text: 'Cancel',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Save',
                  fontSize: 13,
                  textWeight: FontWeight.bold,
                  textColor: AppColors.black,
                  backgroundColor: AppColors.primaryGreen,
                  borderRadius: 8,
                  buttonHeight: context.h(4.5),
                  onPressed: () {
                    final updatedUser = UserModel(
                      id: currentUser?.id ?? 0,
                      userName: currentUser?.userName ?? '',
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: currentUser?.email ?? '',
                      password: passwordController.text.trim(),
                      phone: phoneController.text.trim(),
                      userStatus: currentUser?.userStatus ?? 0,
                    );

                    context.read<ProfileBloc>().add(
                          UpdateProfileEvent(
                            username: currentUser?.userName ?? '',
                            user: updatedUser,
                          ),
                        );

                    Navigator.of(dialogContext, rootNavigator: true).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CustomTextWidget(
          text: 'Logout',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        content: const CustomTextWidget(
          text: 'Are you sure you want to log out?',
          fontSize: 14,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonHeight: context.h(4.5),
                  backgroundColor: Colors.grey.shade200,
                  onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                  child: const CustomTextWidget(
                    text: 'Cancel',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Logout',
                  fontSize: 13,
                  textWeight: FontWeight.bold,
                  textColor: Colors.white,
                  backgroundColor: AppColors.neutralRed,
                  borderRadius: 8,
                  buttonHeight: context.h(4.5),
                  onPressed: () {
                    Navigator.of(dialogContext, rootNavigator: true).pop();
                    context.read<ProfileBloc>().add(LogoutEvent());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}