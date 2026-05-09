import 'package:flutter/material.dart';
import 'package:uts_mobile/features/product/data/product_repository.dart';
import 'package:uts_mobile/features/product/domain/product_service.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';
import 'package:get_it/get_it.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

final locator = GetIt.instance;

void main() {
  // SANGAT PENTING: Panggil Pelayan (GetIt) sebelum aplikasi berjalan!
  setupLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Ubah dari MaterialApp biasa menjadi MaterialApp.router
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UTD Advanced App',
      theme: AppTheme.lightTheme,
      // Masukkan konfigurasi rute yang sudah kita buat di Step 6
      routerConfig: AppRouter.router,
    );
  }
}
