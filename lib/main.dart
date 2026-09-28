import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_test_app/core/di/injection_container.dart';
import 'package:my_test_app/core/di/injection_container.dart' as OrderLocalDataSourceImpl;
import 'package:my_test_app/core/routes/app_router.dart';
import 'package:my_test_app/core/theme/app_theme.dart';
// final sl=GetIt.instance;
// void initDependencies(){
//   sl.registerLazySingleton(()=>BaseApiController());
//   sl.registerLazySingleton<AuthRemoteDataSource>(()=>AuthRemoteDataSourceImpl(controller: sl<BaseApiController>()));
//   sl.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImplementation(dataSource: sl<AuthRemoteDataSource>()));
//   sl.registerLazySingleton<LogInUseCase>(()=>LogInUseCase(repo: sl<AuthRepository>()));
//   sl.registerFactory(() => LogInBloc(useCase: sl<LogInUseCase>()));
// }

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await OrderLocalDataSourceImpl.init();
  await init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
 
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
     theme: AppTheme.lightTheme,
     darkTheme: AppTheme.darkTheme,
     debugShowCheckedModeBanner: false,
     routerConfig: AppRouter.router,
    
    );
  
  }
}