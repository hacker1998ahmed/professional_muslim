import 'package:flutter/material.dart';

import '../models/azkar.dart';

class AzkarListScreen extends StatelessWidget {
  final String title;
  final List<Zikr> azkar;

  const AzkarListScreen({
    super.key,
    required this.title,
    required this.azkar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: azkar.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final zikr = azkar[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ExpansionTile(
              title: Text(
                zikr.text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                'عدد المرات: ${zikr.count}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (zikr.description.isNotEmpty) ...[                        
                        Text(
                          'الوصف:',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          zikr.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16.0),
                      ],
                      if (zikr.reference != null) ...[                        
                        Text(
                          'المصدر:',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          zikr.reference!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16.0),
                      ],
                      if (zikr.benefit != null) ...[                        
                        Text(
                          'الفضل:',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          zikr.benefit!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}