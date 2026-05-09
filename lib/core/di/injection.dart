import 'package:get_it/get_it.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';

// Inisialisasi sang 'Pelayan' secara global
final locator = GetIt.instance;
void setupLocator() {
  // 1. Mendaftarkan Dapur (Repository)
  // registerLazySingleton: Objek cuma dibuat 1x dan dipakai selamanya (hemat memori)
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
  // 2. Mendaftarkan Jembatan (Service)
  // Perhatikan locator() di dalam tanda kurung ProductService.
  // Ini adalah keajaiban get_it! Ia akan otomatis mencari ProductRepository
  // yang sudah didaftarkan di atasnya dan memasukkannya secara otomatis.
  locator.registerFactory<ProductService>(() => ProductService(locator()));
}
