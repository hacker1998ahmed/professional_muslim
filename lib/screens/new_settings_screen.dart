import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../ui/widgets/custom_card.dart';
import '../ui/widgets/app_widgets.dart';
import '../core/constants/app_constants.dart';

class NewSettingsScreen extends StatefulWidget {
  const NewSettingsScreen({super.key});

  @override
  State<NewSettingsScreen> createState() => _NewSettingsScreenState();
}

class _NewSettingsScreenState extends State<NewSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _prayerReminders = true;
  bool _azkarReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'الإعدادات',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CustomPaint(
                    painter: IslamicPatternPainter(),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Settings Content
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
                    children: [
                      // Profile Section
                      _buildProfileSection(),
                      
                      const SizedBox(height: 30),
                      
                      // Theme Settings
                      _buildThemeSettings(),
                      
                      const SizedBox(height: 20),
                      
                      // Language Settings
                      _buildLanguageSettings(),
                      
                      const SizedBox(height: 20),
                      

                      
                      // Notification Settings
                      _buildNotificationSettings(),
                      
                      const SizedBox(height: 20),
                      
                      // Sound Settings
                      _buildSoundSettings(),
                      
                      const SizedBox(height: 20),
                      
                      // Prayer Settings
                      _buildPrayerSettings(),
                      
                      const SizedBox(height: 20),
                      
                      // Reminder Settings
                      _buildReminderSettings(),
                      
                      const SizedBox(height: 20),
                      
                      // App Settings
                      _buildAppSettings(),
                      
                      const SizedBox(height: 20),
                      
                      // About Section
                      _buildAboutSection(),
                      
                      const SizedBox(height: 40),
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

  Widget _buildProfileSection() {
    return const CustomCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF2E7D32),
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'مستخدم التطبيق',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(height: 5),
          Text(
            'مرحباً بك في ${AppConstants.appName}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.palette, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'المظهر',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text(
                  'الوضع الليلي',
                  style: TextStyle(fontFamily: 'Amiri'),
                ),
                subtitle: const Text(
                  'تفعيل الثيم الداكن',
                  style: TextStyle(fontFamily: 'Amiri'),
                ),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: const Color(0xFF2E7D32),
                ),
                activeColor: const Color(0xFF2E7D32),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.language, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'اللغة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return ListTile(
                title: const Text(
                  'لغة التطبيق',
                  style: TextStyle(fontFamily: 'Amiri'),
                ),
                subtitle: Text(
                  languageProvider.currentLanguageName,
                  style: const TextStyle(fontFamily: 'Amiri'),
                ),
                trailing: DropdownButton<String>(
                  value: languageProvider.currentLocale.languageCode,
                  items: const [
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('العربية'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      languageProvider.changeLanguage(value);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'الإشعارات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SwitchListTile(
            title: const Text(
              'تفعيل الإشعارات',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            subtitle: const Text(
              'تلقي إشعارات التطبيق',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(
              Icons.notifications_active,
              color: Color(0xFF2E7D32),
            ),
            activeColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.volume_up, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'الصوت والاهتزاز',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SwitchListTile(
            title: const Text(
              'الأصوات',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            subtitle: const Text(
              'تشغيل أصوات التطبيق',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
            secondary: const Icon(
              Icons.music_note,
              color: Color(0xFF2E7D32),
            ),
            activeColor: const Color(0xFF2E7D32),
          ),
          SwitchListTile(
            title: const Text(
              'الاهتزاز',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            subtitle: const Text(
              'اهتزاز الجهاز مع الإشعارات',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
            secondary: const Icon(
              Icons.vibration,
              color: Color(0xFF2E7D32),
            ),
            activeColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.mosque, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'إعدادات الصلاة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListTile(
            title: const Text(
              'طريقة حساب المواقيت',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            subtitle: const Text(
              'الهيئة المصرية العامة للمساحة',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // فتح شاشة اختيار طريقة الحساب
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.alarm, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'التذكيرات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SwitchListTile(
            title: const Text(
              'تذكير الصلاة',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            value: _prayerReminders,
            onChanged: (value) {
              setState(() {
                _prayerReminders = value;
              });
            },
            activeColor: const Color(0xFF2E7D32),
          ),
          SwitchListTile(
            title: const Text(
              'تذكير الأذكار',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            value: _azkarReminders,
            onChanged: (value) {
              setState(() {
                _azkarReminders = value;
              });
            },
            activeColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'إعدادات التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: const Icon(Icons.backup, color: Color(0xFF2E7D32)),
            title: const Text(
              'النسخ الاحتياطي',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return const CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Color(0xFF2E7D32)),
              SizedBox(width: 10),
              Text(
                'حول التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
            title: Text(
              'إصدار التطبيق',
              style: TextStyle(fontFamily: 'Amiri'),
            ),
            subtitle: Text(
              AppConstants.appVersion,
              style: TextStyle(fontFamily: 'Amiri'),
            ),
          ),
        ],
      ),
    );
  }
}


