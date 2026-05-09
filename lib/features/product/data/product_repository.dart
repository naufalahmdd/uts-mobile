import 'package:dio/dio.dart';
import '../domain/product_model.dart';

class ProductRepository {
  final Dio dio;

  ProductRepository({required this.dio});

  // 2. Fungsi untuk mengambil semua daftar produk dari API
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // 3. Fungsi untuk mencari 1 produk berdasarkan ID-nya
  Future<Product?> getProductById(String id) async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load product detail: $e');
    }
  }
}
