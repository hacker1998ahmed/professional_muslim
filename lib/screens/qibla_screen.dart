import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with TickerProviderStateMixin {
  double _qiblaDirection = 0.0;
  bool _isLoading = true;
  String _error = '';
  Position? _currentPosition;
  late AnimationController _compassController;
  late Animation<double> _compassAnimation;

  // إحداثيات الكعبة المشرفة
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _compassAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _compassController,
      curve: Curves.easeInOut,
    ));
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _compassController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // التحقق من صلاحيات الموقع
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('تم رفض صلاحيات الموقع');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('تم رفض صلاحيات الموقع نهائياً');
      }

      // الحصول على الموقع الحالي
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // حساب اتجاه القبلة
      _calculateQiblaDirection();

      setState(() {
        _isLoading = false;
      });

      _compassController.forward();
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _calculateQiblaDirection() {
    if (_currentPosition == null) return;

    final double lat1 = _currentPosition!.latitude * (math.pi / 180);
    final double lon1 = _currentPosition!.longitude * (math.pi / 180);
    const double lat2 = kaabaLatitude * (math.pi / 180);
    const double lon2 = kaabaLongitude * (math.pi / 180);

    final double dLon = lon2 - lon1;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double bearing = math.atan2(y, x);
    bearing = bearing * (180 / math.pi);
    bearing = (bearing + 360) % 360;

    _qiblaDirection = bearing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تحديد موقعك...'),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLocationInfo(),
          const SizedBox(height: 20),
          _buildCompass(),
          const SizedBox(height: 20),
          _buildInstructions(),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    if (_currentPosition == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'موقعك الحالي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'خط العرض: ${_currentPosition!.latitude.toStringAsFixed(4)}°',
            ),
            Text(
              'خط الطول: ${_currentPosition!.longitude.toStringAsFixed(4)}°',
            ),
            const SizedBox(height: 8),
            Text(
              'اتجاه القبلة: ${_qiblaDirection.toStringAsFixed(1)}°',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return SizedBox(
      width: 300,
      height: 300,
      child: AnimatedBuilder(
        animation: _compassAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _qiblaDirection * (math.pi / 180) * _compassAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 4,
                ),
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // البوصلة
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // مؤشر القبلة
                  Positioned(
                    top: 20,
                    child: Container(
                      width: 40,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  // النص المركزي
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.place,
                        size: 40,
                        color: Colors.green,
                      ),
                      Text(
                        'القبلة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تعليمات الاستخدام:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• ضع الهاتف على سطح مستوٍ'),
            const Text('• تأكد من تفعيل GPS'),
            const Text('• السهم الأخضر يشير إلى اتجاه القبلة'),
            const Text('• اضغط على زر التحديث لإعادة حساب الاتجاه'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'هذا التطبيق يستخدم GPS لتحديد موقعك وحساب اتجاه القبلة بدقة',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
