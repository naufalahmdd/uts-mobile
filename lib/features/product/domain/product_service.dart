import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  // Perhatikan: Service membutuhkan Repository untuk bekerja!
  final ProductRepository repository;
  // Constructor Service akan meminta Repository saat diciptakan
  ProductService(this.repository);
  // Fungsi yang akan dipanggil oleh UI (Halaman) nantinya
  List<Product> fetchProducts() {
    // Service tinggal menyuruh Repository mengambil data
    return repository.getAllProducts();
  }

  Product? fetchProductDetail(String id) {
    return repository.getProductById(id);
  }
}
