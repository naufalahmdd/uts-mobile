import 'package:flutter/material.dart';
import '../../data/bookmark_collection.dart';
import '../../data/bookmark_repository.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = BookmarkRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmark Saya')),
      // StreamBuilder bereaksi secara real-time menggunakan watch() dari Isar
      // TANPA memanggil setState sama sekali
      body: StreamBuilder<List<BookmarkItem>>(
        stream: repo.watchAllBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada produk yang di-bookmark',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              // Format jam Anti-AI: "Disimpan pada 14:05"
              final hour = item.savedAt.hour.toString().padLeft(2, '0');
              final minute = item.savedAt.minute.toString().padLeft(2, '0');
              final formattedTime = 'Disimpan pada $hour:$minute';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.productImage,
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image, size: 40),
                    ),
                  ),
                  title: Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${item.productPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        formattedTime, // Logika Anti-AI timestamp
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await BookmarkRepository().removeBookmark(item.productId);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
