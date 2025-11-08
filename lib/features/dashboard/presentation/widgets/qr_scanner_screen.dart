import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math' as math;


class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isDetected = false;
  bool _torchOn = false;
  late AnimationController _animController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isDetected) return;
    final barcode = capture.barcodes.first;
    if (barcode.rawValue != null) {
      _isDetected = true;
      Navigator.pop(context, barcode.rawValue);
    }
  }

  Future<void> _toggleTorch() async {
    await _controller.toggleTorch();
    // No hay getter, así que solo invertimos el estado local
    setState(() => _torchOn = !_torchOn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanArea = size.width * 0.7;
    print('📸 Initializing scanner...');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 📷 Cámara activa
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetection,
          ),

          /// 🔹 Overlay con marco
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: scanArea,
                    width: scanArea,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔸 Línea animada
          AnimatedBuilder(
            animation: _scannerAnimation,
            builder: (context, child) {
              final double position = math.max(
                0,
                (scanArea * _scannerAnimation.value) - (scanArea / 2),
              );
              return Align(
                alignment: Alignment.center,
                child: Container(
                  width: scanArea,
                  height: 3,
                  margin: EdgeInsets.only(top: position),
                  decoration: BoxDecoration(
                    color: AppColors.dogOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),

          /// 🔹 Cabecera con flash y volver
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleTorch,
                    icon: Icon(
                      _torchOn ? Icons.flash_on : Icons.flash_off,
                      color: _torchOn ? AppColors.dogOrange : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 📋 Texto inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Text(
                'Align the QR code within the frame',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
