import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart'; // Import pelayan
import '../../domain/product_service.dart'; // Import service

class DetailPage extends StatelessWidget {
  final String productId;
  // Halaman ini menerima productId dari AppRouter sebelumnya
  const DetailPage({super.key, required this.productId});
  @override
  Widget build(BuildContext context) {
    // AJAIB! Kita minta data ke Pelayan (locator).
    // UI tidak perlu buat 'new ProductService()', cukup panggil locator!
    final service = locator<ProductService>();
    final product = service.fetchProductDetail(productId);
    // Jika produk tidak ditemukan (ID salah)
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: Text('Maaf, produk tidak ditemukan!')),
      );
    }
    // Jika produk ditemukan, tampilkan UI-nya
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${product.name}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 100, color: Colors.teal.shade200),
            const SizedBox(height: 20),
            Text(
              'ID Produk: ${product.id}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // CARA KEMBALI MENGGUNAKAN GO_ROUTER
              onPressed: () => context.pop(),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
