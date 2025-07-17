import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'azkar_list_screen.dart';
import 'tasbih_screen.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'quran_reading_screen.dart';
import 'zakat_calculator_screen.dart';
import 'inheritance_calculator_screen.dart';
import 'fasting_tracker_screen.dart';
import 'about_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime12Hour(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final second = time.second;
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} $period';
  }

  String _getHijriDate() {
    // تحويل تقريبي للتاريخ الهجري
    final gregorianDate = DateTime.now();
    final hijriYear = gregorianDate.year - 579;
    final hijriMonth = _getHijriMonthName(gregorianDate.month);
    return '${gregorianDate.day} $hijriMonth $hijriYear هـ';
  }

  String _getHijriMonthName(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الثانية', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    return months[(month - 1) % 12];
  }

  String _getGregorianDate() {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    const days = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    
    final now = DateTime.now();
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    
    return '$dayName، ${now.day} $monthName ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Time and Date
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CustomPaint(
                    painter: _IslamicPatternPainter(),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Greeting
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontFamily: 'Amiri',
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // Current Time
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Text(
                                    _formatTime12Hour(_currentTime),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Amiri',
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 15),
                            
                            // Dates
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _getGregorianDate(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Amiri',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _getHijriDate(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontFamily: 'Amiri',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Next Prayer Info
                            _buildNextPrayerInfo(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            
            // Main Content
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions
                      _buildQuickActions(),
                      
                      const SizedBox(height: 30),
                      
                      // Main Features Grid
                      _buildMainFeatures(),
                      
                      const SizedBox(height: 30),
                      
                      // Additional Features
                      _buildAdditionalFeatures(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = _currentTime.hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير';
    }
  }

  Widget _buildNextPrayerInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            'الصلاة القادمة: العصر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(width: 10),
          Text(
            '3:45 م',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات السريعة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
            fontFamily: 'Amiri',
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: Icons.play_circle_filled,
                label: 'تشغيل الأذان',
                onPressed: () {
                  // تشغيل الأذان
                },
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickActionButton(
                icon: Icons.explore,
                label: 'اتجاه القبلة',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QiblaScreen(),
                    ),
                  );
                },
                color: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickActionButton(
                icon: Icons.book,
                label: 'قراءة القرآن',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranReadingScreen(),
                    ),
                  );
                },
                color: const Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الميزات الرئيسية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
            fontFamily: 'Amiri',
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              'الأذكار',
              Icons.menu_book,
              const Color(0xFF4CAF50),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AzkarListScreen(
                    title: 'الأذكار',
                    azkar: [],
                  ),
                ),
              ),
            ),
            _buildFeatureCard(
              'التسبيح',
              Icons.radio_button_checked,
              const Color(0xFF2E7D32),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TasbihScreen(),
                ),
              ),
            ),
            _buildFeatureCard(
              'مواقيت الصلاة',
              Icons.access_time,
              const Color(0xFF1B5E20),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerTimesScreen(),
                ),
              ),
            ),
            _buildFeatureCard(
              'حاسبة الزكاة',
              Icons.calculate,
              const Color(0xFF388E3C),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ZakatCalculatorScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ميزات إضافية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
            fontFamily: 'Amiri',
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
          children: [
            _buildSmallFeatureCard(
              'تتبع الصيام',
              Icons.calendar_today,
              const Color(0xFF66BB6A),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FastingTrackerScreen(),
                ),
              ),
            ),
            _buildSmallFeatureCard(
              'حاسبة المواريث',
              Icons.family_restroom,
              const Color(0xFF4CAF50),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InheritanceCalculatorScreen(),
                ),
              ),
            ),
            _buildSmallFeatureCard(
              'حول التطبيق',
              Icons.info,
              const Color(0xFF2E7D32),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Islamic Pattern Painter for background decoration
class _IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw geometric Islamic patterns
    const double spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Draw star pattern
        _drawStar(canvas, paint, Offset(x, y), 15.0);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    const int points = 8;
    const double angle = (3.14159 * 2) / points;

    for (int i = 0; i < points; i++) {
      final double x = center.dx + radius * (i % 2 == 0 ? 1 : 0.5) *
          cos(i * angle);
      final double y = center.dy + radius * (i % 2 == 0 ? 1 : 0.5) *
          sin(i * angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Quick Action Button Widget
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? const Color(0xFF2E7D32),
            (color ?? const Color(0xFF2E7D32)).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (color ?? const Color(0xFF2E7D32)).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Amiri',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
