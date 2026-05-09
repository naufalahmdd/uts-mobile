import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTD Store - Naufal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_bitcoin),
            tooltip: 'Crypto Hub',
            onPressed: () => context.push('/crypto'),
          ),
          IconButton(
            icon: const Icon(Icons.phone_android),
            tooltip: 'Native Info',
            onPressed: () => context.push('/native'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks),
            tooltip: 'Bookmark Saya',
            onPressed: () => context.push('/bookmark'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Tentang Saya',
            onPressed: () => context.push('/about'),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. JIKA STATE = LOADING (Tampilkan indikator putar)
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. JIKA STATE = ERROR (Tampilkan pesan error)
          else if (state is ProductError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // 3. JIKA STATE = LOADED (Tampilkan daftar produk)
          else if (state is ProductLoaded) {
            final products = state.products;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return GestureDetector(
                  onTap: () => context.push('/detail/${item.id}'),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            child: Image.network(
                              item.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID: ${item.id}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
