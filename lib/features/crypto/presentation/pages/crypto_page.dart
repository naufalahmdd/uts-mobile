import 'package:flutter/material.dart';
import '../../data/crypto_service.dart';
import '../../domain/crypto_isolate.dart';

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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade700, Colors.indigo.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://assets.coincap.io/assets/icons/btc@2x.png',
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Bitcoin (BTC)',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Harga Real-Time (USD)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<double>(
                      stream: _cryptoService.connectBitcoinPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data! > 0) {
                          _btcPrice = snapshot.data!;
                          _pulseController.forward(from: 0);
                        }
                        return ScaleTransition(
                          scale: _pulseAnimation,
                          child: Text(
                            '\$ ${_btcPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: Colors.yellow, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'LIVE UPDATING',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
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
