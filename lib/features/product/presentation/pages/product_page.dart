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
            icon: const Icon(Icons.bookmarks),
            tooltip: 'Bookmark Saya',
            onPressed: () => context.push('/bookmark'),
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
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('ID: ${item.id}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/detail/${item.id}');
                    },
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
