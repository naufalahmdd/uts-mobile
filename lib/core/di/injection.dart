import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';
import '../../features/splash/domain/splash_service.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

// Inisialisasi sang 'Pelayan' secara global
final locator = GetIt.instance;
void setupLocator() {
  // 1. Splash Service
  locator.registerLazySingleton<SplashService>(() => SplashService());

  // 1.5. Mendaftarkan Dio & Interceptor
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
    return dio;
  });

  // 2. Mendaftarkan Dapur (Repository)
  // registerLazySingleton: Objek cuma dibuat 1x dan dipakai selamanya (hemat memori)
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository(dio: locator()));
  // 3. Mendaftarkan Jembatan (Service)
  // Perhatikan locator() di dalam tanda kurung ProductService.
  // Ini adalah keajaiban get_it! Ia akan otomatis mencari ProductRepository
  // yang sudah didaftarkan di atasnya dan memasukkannya secara otomatis.
  locator.registerFactory<ProductService>(() => ProductService(locator()));

  // 4. Mendaftarkan Cubit
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator()));
}
