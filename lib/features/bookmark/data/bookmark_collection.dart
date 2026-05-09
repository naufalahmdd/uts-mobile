import 'package:isar/isar.dart';

part 'bookmark_collection.g.dart';

@Collection()
class BookmarkItem {
  Id id = Isar.autoIncrement;

  late String productId;
  late String productName;
  late double productPrice;
  late String productImage;

  // Logika Personal Anti-AI: Menyimpan timestamp saat tombol ditekan
  late DateTime savedAt;
}
