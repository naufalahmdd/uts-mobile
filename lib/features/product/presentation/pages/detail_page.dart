import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../domain/product_model.dart';
import '../../domain/product_service.dart';
import '../../../bookmark/data/bookmark_repository.dart';

class DetailPage extends StatefulWidget {
  final String productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product? _product;
  bool _isLoading = true;
  String? _error;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final service = locator<ProductService>();
      final result = await service.fetchProductDetail(widget.productId);
      final isBookmarked =
          await locator<BookmarkRepository>().isBookmarked(widget.productId);
      if (mounted) {
        setState(() {
          _product = result;
          _isBookmarked = isBookmarked;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: Text('Maaf, produk tidak ditemukan!')),
      );
    }
    final product = _product!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(_isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_add_outlined),
                label: Text(_isBookmarked
                    ? 'Sudah Tersimpan'
                    : 'Simpan ke Bookmark'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isBookmarked ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final repo = locator<BookmarkRepository>();
                  if (_isBookmarked) {
                    await repo.removeBookmark(product.id);
                    setState(() => _isBookmarked = false);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Bookmark dihapus')),
                      );
                    }
                  } else {
                    await repo.addBookmark(product);
                    setState(() => _isBookmarked = true);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Berhasil disimpan ke Bookmark!')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
