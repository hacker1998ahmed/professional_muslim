import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool showShadow;
  final Gradient? gradient;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.showShadow = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? theme.cardColor) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: showShadow ? [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: cardContent,
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: cardContent,
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    required this.colors,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      borderRadius: borderRadius,
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
}

class IslamicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isSelected;

  const IslamicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      gradient: isSelected ? const LinearGradient(
        colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ) : null,
      backgroundColor: isSelected ? null : Theme.of(context).cardColor,
      child: DefaultTextStyle(
        style: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
          fontFamily: 'Amiri',
        ),
        child: child,
      ),
    );
  }
}

class PrayerTimeCard extends StatelessWidget {
  final String prayerName;
  final String time;
  final bool isNext;
  final bool isPassed;
  final VoidCallback? onTap;

  const PrayerTimeCard({
    super.key,
    required this.prayerName,
    required this.time,
    this.isNext = false,
    this.isPassed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    Color textColor;
    
    if (isNext) {
      cardColor = const Color(0xFF4CAF50);
      textColor = Colors.white;
    } else if (isPassed) {
      cardColor = Colors.grey.shade300;
      textColor = Colors.grey.shade600;
    } else {
      cardColor = Theme.of(context).cardColor;
      textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    }

    return CustomCard(
      backgroundColor: cardColor,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isNext ? Colors.white : const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Amiri',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withValues(alpha: 0.8),
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
          ),
          if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'التالية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AzkarCard extends StatelessWidget {
  final String title;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final String? reference;
  final String? benefit;
  final int? count;
  final int? currentCount;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;

  const AzkarCard({
    super.key,
    required this.title,
    required this.arabicText,
    this.transliteration,
    this.translation,
    this.reference,
    this.benefit,
    this.count,
    this.currentCount,
    this.onTap,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
                fontFamily: 'Amiri',
              ),
            ),
          if (title.isNotEmpty) const SizedBox(height: 12),
          
          // Arabic text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              arabicText,
              style: const TextStyle(
                fontSize: 20,
                height: 1.8,
                fontFamily: 'Amiri',
                color: Color(0xFF1B5E20),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          
          if (transliteration != null) ...[
            const SizedBox(height: 12),
            Text(
              transliteration!,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          
          if (translation != null) ...[
            const SizedBox(height: 8),
            Text(
              translation!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
                fontFamily: 'Amiri',
              ),
            ),
          ],
          
          if (reference != null || benefit != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
          ],
          
          if (reference != null)
            Row(
              children: [
                const Icon(
                  Icons.book,
                  size: 16,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'المرجع: $reference',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2E7D32),
                      fontFamily: 'Amiri',
                    ),
                  ),
                ),
              ],
            ),
          
          if (benefit != null) ...[
            if (reference != null) const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Color(0xFFFF9800),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الفائدة: $benefit',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF9800),
                      fontFamily: 'Amiri',
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          if (count != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'العدد: $count',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'Amiri',
                  ),
                ),
                if (currentCount != null && onIncrement != null)
                  Row(
                    children: [
                      Text(
                        '$currentCount / $count',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                          fontFamily: 'Amiri',
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: currentCount! < count! ? onIncrement : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          minimumSize: const Size(40, 40),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
