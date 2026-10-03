import 'package:get_it/get_it.dart';
import 'package:pet_store_app/core/services/dio_client.dart';
import 'package:pet_store_app/core/services/storage_service.dart';
import 'package:pet_store_app/data/data_source/local/order_local_data_source.dart';
import 'package:pet_store_app/data/data_source/remote/pet_remote_data_source.dart';
import 'package:pet_store_app/data/data_source/remote/store_remote_data_source.dart';
import 'package:pet_store_app/data/data_source/remote/user_remote_data_source.dart';
import 'package:pet_store_app/data/repository_impl/pet_repository_impl.dart';
import 'package:pet_store_app/data/repository_impl/store_repository_impl.dart';
import 'package:pet_store_app/data/repository_impl/user_repository_impl.dart';
import 'package:pet_store_app/domain/repository/pet_repository.dart';
import 'package:pet_store_app/domain/repository/store_repository.dart';
import 'package:pet_store_app/domain/repository/user_repository.dart';
import 'package:pet_store_app/domain/use_cases/add_pet_use_case.dart';
import 'package:pet_store_app/domain/use_cases/create_user_use_case.dart';
import 'package:pet_store_app/domain/use_cases/delete_pet_use_case.dart';
import 'package:pet_store_app/domain/use_cases/delete_purchase_order_by_use_case.dart';
import 'package:pet_store_app/domain/use_cases/find_purchase_order_by_id_use_case.dart';
import 'package:pet_store_app/domain/use_cases/get_my_orders_use_case.dart';
import 'package:pet_store_app/domain/use_cases/get_pets_by_status_use_case.dart';
import 'package:pet_store_app/domain/use_cases/login_use_case.dart';
import 'package:pet_store_app/domain/use_cases/place_order_use_case.dart';
import 'package:pet_store_app/domain/use_cases/update_pet_use_case.dart'
    show UpdatePetUseCase;
import 'package:pet_store_app/domain/use_cases/upload_pet_image_use_case.dart';
import 'package:pet_store_app/presentation/bloc/admin_management/admin_pet_bloc.dart';
import 'package:pet_store_app/presentation/bloc/login/login_bloc.dart';
import 'package:pet_store_app/presentation/bloc/my_orders/order_bloc.dart';
import 'package:pet_store_app/presentation/bloc/register/register_bloc.dart';
import 'package:pet_store_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:pet_store_app/presentation/bloc/splash/splash_bloc.dart';
import 'package:pet_store_app/presentation/bloc/store_screen/pet_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();
  // ---------------------------------------------------------------------------
  // 1. Core / Network
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // ---------------------------------------------------------------------------
  // 2. Data Sources
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<PetRemoteDataSource>(
    () => PetRemoteDataSourceImpl(dio: sl<DioClient>()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl<DioClient>()),
  );
  sl.registerLazySingleton<StoreRemoteDataSource>(
    () => StoreRemoteDataSourceImpl(sl<DioClient>()),
  );

  // ---------------------------------------------------------------------------
  // 3. Repositories
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>(), sl<StorageService>()),
  );
  sl.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ---------------------------------------------------------------------------
  // 4. Use Cases
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => PlaceStoreOrderUseCase(sl()));
  sl.registerLazySingleton(() => FindPurchaseOrderByIdUseCase(sl()));
  sl.registerLazySingleton(() => DeletePurchaseOrderByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetMyOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetPetsByStatusUseCase(sl()));
  sl.registerLazySingleton(() => AddPetUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePetUseCase(sl()));
  sl.registerLazySingleton(() => DeletePetUseCase(sl()));
  sl.registerLazySingleton(() => UploadPetImageUseCase(sl()));

  // ---------------------------------------------------------------------------
  // 5. BLoCs
  // ---------------------------------------------------------------------------
  sl.registerFactory(() => SplashBloc(storageService: sl<StorageService>()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      userRepository: sl<UserRepository>(),
      storageService: sl<StorageService>(),
    ),
  );
  sl.registerFactory(() => PetBloc(repository: sl()));
  sl.registerLazySingleton(
    () => OrderBloc(
      placeStoreOrderUseCase: sl(),
      findPurchaseOrderByIdUseCase: sl(),
      deletePurchaseOrderByIdUseCase: sl(),
      getMyOrdersUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminPetBloc(
      getPetsByStatusUseCase: sl(),
      addPetUseCase: sl(),
      updatePetUseCase: sl(),
      deletePetUseCase: sl(),
      uploadPetImageUseCase: sl(),
    ),
  );
}
