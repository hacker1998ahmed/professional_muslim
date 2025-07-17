import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/azkar_provider.dart';
import 'providers/prayer_times_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'screens/azkar_list_screen.dart';
import 'screens/tasbih_screen.dart';
import 'screens/about_screen.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/zakat_calculator_screen.dart';
import 'screens/fasting_tracker_screen.dart';
import 'providers/fasting_provider.dart';
import 'screens/quran_memorization_screen.dart';
import 'providers/quran_memorization_provider.dart';
import 'screens/inheritance_calculator_screen.dart';
import 'providers/inheritance_provider.dart';
import 'screens/quran_reading_screen.dart';
import 'providers/quran_provider.dart';
import 'screens/qibla_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AzkarProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => FastingProvider()),
        ChangeNotifierProvider(create: (_) => QuranMemorizationProvider()),
        ChangeNotifierProvider(create: (_) => InheritanceProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          title: 'Professional Muslim',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainNavigationScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكار المسلم'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<AzkarProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.retryLoadAzkar(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildWelcomeHeader(context),
                  Expanded(
                    child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16.0),
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.1,
                  children: [
              _buildMenuItem(
                context,
                'أذكار الصباح',
                Icons.wb_sunny,
                () {
                  final category = provider.getCategoryByIndex(0);
                  if (category != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AzkarListScreen(
                          title: category.title,
                          azkar: category.azkar,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildMenuItem(
                context,
                'أذكار المساء',
                Icons.nights_stay,
                () {
                  final category = provider.getCategoryByIndex(1);
                  if (category != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AzkarListScreen(
                          title: category.title,
                          azkar: category.azkar,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildMenuItem(
                context,
                'أذكار النوم',
                Icons.bedtime,
                () {
                  final category = provider.getCategoryByIndex(2);
                  if (category != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AzkarListScreen(
                          title: category.title,
                          azkar: category.azkar,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildMenuItem(
                context,
                'أذكار الصلاة',
                Icons.mosque,
                () {
                  final category = provider.getCategoryByIndex(3);
                  if (category != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AzkarListScreen(
                          title: category.title,
                          azkar: category.azkar,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildMenuItem(
                context,
                'السبحة الإلكترونية',
                Icons.touch_app,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TasbihScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'مواقيت الصلاة',
                Icons.access_time,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrayerTimesScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'اتجاه القبلة',
                Icons.explore,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QiblaScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'حاسبة الزكاة',
                Icons.calculate,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ZakatCalculatorScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'تتبع الصيام',
                Icons.calendar_today,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FastingTrackerScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'قراءة القرآن',
                Icons.menu_book,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranReadingScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'حفظ القرآن',
                Icons.book,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranMemorizationScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'حاسبة المواريث',
                Icons.calculate_outlined,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InheritanceCalculatorScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                'عن التطبيق',
                Icons.info,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
                  ],
                  ),
                ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final now = DateTime.now();
    String greeting;

    if (now.hour < 12) {
      greeting = 'صباح الخير';
    } else if (now.hour < 17) {
      greeting = 'مساء الخير';
    } else {
      greeting = 'مساء الخير';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.mosque,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            greeting,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'أهلاً بك في تطبيق أذكار المسلم',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 8.0,
      shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Theme.of(context).primaryColor.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
