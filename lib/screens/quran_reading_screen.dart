import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/quran_page.dart';

class QuranReadingScreen extends StatefulWidget {
  const QuranReadingScreen({super.key});

  @override
  State<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends State<QuranReadingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().loadQuranData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('القرآن الكريم - صفحة $_currentPage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _showBookmarksDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.pages.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري تحميل القرآن الكريم...'),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildPageInfo(provider),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: provider.pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index + 1;
                    });
                    provider.setCurrentPage(index + 1);
                  },
                  itemBuilder: (context, index) {
                    final page = provider.pages[index];
                    return _buildQuranPage(page);
                  },
                ),
              ),
              _buildNavigationControls(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageInfo(QuranProvider provider) {
    if (_currentPage > provider.pages.length) return const SizedBox.shrink();
    
    final page = provider.pages[_currentPage - 1];
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('الجزء ${page.juz}'),
          Text('الحزب ${page.hizb}'),
          Text('الربع ${page.rub}'),
        ],
      ),
    );
  }

  Widget _buildQuranPage(QuranPage page) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (page.surahName.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'سورة ${page.surahName}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Text(
              page.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                height: 2.0,
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationControls(QuranProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('السابق'),
          ),
          Text(
            '$_currentPage / ${provider.pages.length}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ElevatedButton.icon(
            onPressed: _currentPage < provider.pages.length ? _nextPage : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < context.read<QuranProvider>().pages.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showBookmarksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('العلامات المرجعية'),
        content: const Text('ستتم إضافة هذه الميزة قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في القرآن'),
        content: const Text('ستتم إضافة هذه الميزة قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
