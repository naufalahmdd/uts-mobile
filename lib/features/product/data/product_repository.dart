import '../domain/product_model.dart';

class ProductRepository {
  // 1. Membuat data pura-pura (dummy)
  final List<Product> _dummyData = [
    Product(id: 'P01', name: 'Laptop UTD Pro'),
    Product(id: 'P02', name: 'Mouse Wireless'),
    Product(id: 'P03', name: 'Keyboard Mekanikal'),
  ];
  // 2. Fungsi untuk mengambil semua daftar produk
  List<Product> getAllProducts() {
    return _dummyData;
  }

  // 3. Fungsi untuk mencari 1 produk berdasarkan ID-nya
  Product? getProductById(String id) {
    try {
      // Cari produk pertama yang ID-nya cocok dengan parameter
      return _dummyData.firstWhere((prod) => prod.id == id);
    } catch (e) {
      // Jika tidak ketemu, kembalikan null (kosong)
      return null;
    }
  }
}
