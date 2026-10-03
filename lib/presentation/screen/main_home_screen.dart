import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_store_app/core/routes/route_name.dart';
import 'package:pet_store_app/core/theme/app_colors.dart';
import 'package:pet_store_app/core/utils/responsive_extension.dart';
import 'package:pet_store_app/gen/assets.gen.dart';
import 'package:pet_store_app/presentation/bloc/main_home/main_home_bloc.dart';
import 'package:pet_store_app/presentation/bloc/main_home/main_home_event.dart';
import 'package:pet_store_app/presentation/bloc/main_home/main_home_state.dart';
import 'package:pet_store_app/presentation/screen/my_order_screen.dart';
import 'package:pet_store_app/presentation/screen/profile_screen.dart';
import 'package:pet_store_app/presentation/screen/store_screen.dart';
import 'package:pet_store_app/presentation/widgets/custom_app_bar.dart';
import 'package:pet_store_app/presentation/widgets/custom_text_widget.dart';

class MainHomeScreen extends StatelessWidget {
   const MainHomeScreen({super.key});

  final List<Widget> _screens = const [
    StoreScreen(),
    MyOrdersScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.w(6); 

    return BlocProvider(
      create: (context) => MainHomeBloc(),
      child: BlocBuilder<MainHomeBloc, MainHomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: CustomAppBar(
              leading: Assets.icons.icPawprint.path,
              middleWidget: Center(
                child: CustomTextWidget(
                  text: "Pet Store",
                  fontSize: 18, 
                  fontWeight: FontWeight.w600, 
                  color: AppColors.white,
                ),
              ),
              leadingPressed: () {
               
              },
              trailing: Assets.icons.icSetting.path,
              trailingAction: () {
              context.pushNamed(RouteNames.adminManageScreenName);
              },
            ),
            body: IndexedStack(
              index: state.tabIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.tabIndex,
              onTap: (index) {
                context.read<MainHomeBloc>().add(TabChangedEvent(index));
              },
              backgroundColor: AppColors.primaryGreen,
              selectedItemColor: AppColors.black,
              unselectedItemColor: AppColors.white,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(Assets.icons.icHome.path, width: iconSize, height: iconSize, color: AppColors.white),
                  activeIcon: Image.asset(Assets.icons.icHome.path, width: iconSize, height: iconSize, color: AppColors.black),
                  label: 'Store',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(Assets.icons.icManage.path, width: iconSize, height: iconSize, color: AppColors.white),
                  activeIcon: Image.asset(Assets.icons.icManage.path, width: iconSize, height: iconSize, color: AppColors.black),
                  label: 'My Orders',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(Assets.icons.icPerson.path, width: iconSize, height: iconSize, color: AppColors.white),
                  activeIcon: Image.asset(Assets.icons.icPerson.path, width: iconSize, height: iconSize, color: AppColors.black),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
