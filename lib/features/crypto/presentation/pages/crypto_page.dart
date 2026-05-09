import 'package:flutter/material.dart';
import '../data/crypto_service.dart';
import '../domain/crypto_isolate.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage>
    with SingleTickerProviderStateMixin {
  final CryptoService _cryptoService = CryptoService();
  double _btcPrice = 0.0;
  bool _isCalculating = false;
  int? _calculationResult;
  // Animasi warna harga untuk efek real-time
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _prevPrice = 0.0;
  Color _priceColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cryptoService.disconnect();
    _pulseController.dispose();
    super.dispose();
  }

  // Kalkulasi Pajak Kripto menggunakan Isolate
  // Animasi harga TIDAK akan freeze karena Isolate berjalan di background thread
  Future<void> _runTaxCalculation() async {
    setState(() {
      _isCalculating = true;
      _calculationResult = null;
    });

    // NIM: 20123067 -> 2 digit terakhir = 67
    // Isolate.run() -> berjalan di thread terpisah, UI tetap responsif
    final result = await runHeavyCalculationInIsolate(67);

    if (mounted) {
      setState(() {
        _isCalculating = false;
        _calculationResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Hub'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- KARTU HARGA BITCOIN REAL-TIME ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://assets.coincap.io/assets/icons/btc@2x.png',
                          width: 40,
                          height: 40,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.currency_bitcoin,
                                  size: 40, color: Colors.orange),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Bitcoin (BTC)',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Harga Real-Time (USD)',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    // StreamBuilder untuk harga WebSocket - bereaksi real-time
                    StreamBuilder<double>(
                      stream: _cryptoService.connectBitcoinPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data! > 0) {
                          final newPrice = snapshot.data!;
                          // Update warna berdasarkan naik/turun
                          if (newPrice > _prevPrice && _prevPrice > 0) {
                            _priceColor = Colors.green;
                          } else if (newPrice < _prevPrice) {
                            _priceColor = Colors.red;
                          }
                          _prevPrice = newPrice;
                          _btcPrice = newPrice;
                          // Trigger animasi pulse setiap update harga
                          _pulseController.forward(from: 0);
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Column(children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Menghubungkan ke WebSocket...'),
                          ]);
                        }

                        return ScaleTransition(
                          scale: _pulseAnimation,
                          child: Text(
                            _btcPrice > 0
                                ? '\$ ${_btcPrice.toStringAsFixed(2)}'
                                : 'Memuat...',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: _priceColor,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    // Indikator animasi live
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- SECTION KALKULASI PAJAK KRIPTO (ISOLATE) ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.calculate, size: 48, color: Colors.blue),
                    const SizedBox(height: 12),
                    const Text(
                      'Kalkulasi Pajak Kripto',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Menjalankan loop sebanyak 67 × 10.000.000 kali\ndi background thread (Isolate) — harga crypto di atas\ntidak akan freeze saat kalkulasi berjalan!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isCalculating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isCalculating
                            ? 'Kalkulasi berjalan di background...'
                            : 'Jalankan Kalkulasi Pajak'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isCalculating ? null : _runTaxCalculation,
                      ),
                    ),
                    if (_calculationResult != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '✅ Kalkulasi Selesai!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hasil: ${_calculationResult}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Animasi harga tetap berjalan selama proses ✓',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
