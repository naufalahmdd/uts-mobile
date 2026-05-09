import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  // Perhatikan: Service membutuhkan Repository untuk bekerja!
  final ProductRepository repository;
  
  ProductService(this.repository);
  
  // Fungsi yang akan dipanggil oleh UI (Halaman) nantinya
  Future<List<Product>> fetchProducts() async {
    final products = await repository.getAllProducts();
    // Logika Personal (Anti-AI): Digit terakhir NIM ganjil (7) -> Tambahkan [Diskon 10%]
    return products.map((product) {
      return product.copyWith(name: '${product.name} [Diskon 10%]');
    }).toList();
  }

  Future<Product?> fetchProductDetail(String id) async {
    final product = await repository.getProductById(id);
    if (product != null) {
      return product.copyWith(name: '${product.name} [Diskon 10%]');
    }
    return null;
  }
}
