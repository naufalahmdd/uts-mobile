import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class CryptoService {
  WebSocketChannel? _channel;

  // Buka koneksi WebSocket ke CoinCap
  Stream<double> connectBitcoinPrice() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );

    return _channel!.stream.map((event) {
      final data = jsonDecode(event as String);
      // Ambil harga bitcoin dari JSON
      final priceStr = data['bitcoin'] as String?;
      return double.tryParse(priceStr ?? '0') ?? 0.0;
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
