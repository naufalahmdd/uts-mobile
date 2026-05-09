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
      title: 'UTD Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
