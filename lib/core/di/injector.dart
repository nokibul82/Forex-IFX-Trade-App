import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/promo_repository.dart';
import '../../data/repositories/promo_repository_impl.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio
  getIt.registerLazySingleton<Dio>(() => DioClient().dio);

  // Data Sources
  getIt.registerLazySingleton<LocalDataSource>(
        () => LocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSource(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<RemoteDataSource>(),
      getIt<LocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AccountRepository>(
        () => AccountRepositoryImpl(
      getIt<RemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<PromoRepository>(
        () => PromoRepositoryImpl(
      getIt<RemoteDataSource>(),
    ),
  );
}