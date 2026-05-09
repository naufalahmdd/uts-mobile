import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/bookmark_collection.dart';
import '../../product/domain/product_model.dart';

class BookmarkRepository {
  static Isar? _isar;

  Future<Isar> get db async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [BookmarkItemSchema],
      directory: dir.path,
    );
    return _isar!;
  }

  // Simpan produk ke database dengan timestamp
  Future<void> addBookmark(Product product) async {
    final isar = await db;
    final item = BookmarkItem()
      ..productId = product.id
      ..productName = product.name
      ..productPrice = product.price
      ..productImage = product.image
      ..savedAt = DateTime.now(); // Timestamp saat tombol ditekan

    await isar.writeTxn(() async {
      await isar.bookmarkItems.put(item);
    });
  }

  // Hapus bookmark berdasarkan productId
  Future<void> removeBookmark(String productId) async {
    final isar = await db;
    final item = await isar.bookmarkItems
        .filter()
        .productIdEqualTo(productId)
        .findFirst();
    if (item != null) {
      await isar.writeTxn(() async {
        await isar.bookmarkItems.delete(item.id);
      });
    }
  }

  // Cek apakah produk sudah di-bookmark
  Future<bool> isBookmarked(String productId) async {
    final isar = await db;
    final item = await isar.bookmarkItems
        .filter()
        .productIdEqualTo(productId)
        .findFirst();
    return item != null;
  }

  // Stream reaktif: bereaksi REAL-TIME setiap ada perubahan, TANPA setState
  Stream<List<BookmarkItem>> watchAllBookmarks() async* {
    final isar = await db;
    yield* isar.bookmarkItems.where().watch(fireImmediately: true);
  }
}
