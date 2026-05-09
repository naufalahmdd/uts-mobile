import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/bookmark/presentation/pages/bookmark_page.dart';
import '../di/injection.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          // BUNGKUS PRODUCT PAGE DENGAN BLOC PROVIDER
          return BlocProvider(
            // Kita minta Cubit dari get_it, dan langsung suruh dia jalan (fetchAllProducts)
            create: (context) => locator<ProductCubit>()..fetchAllProducts(),
            child: const ProductPage(),
          );
        },
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? "";
          return DetailPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/bookmark',
        builder: (context, state) => const BookmarkPage(),
      ),
    ],
  );
}
