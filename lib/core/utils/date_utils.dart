// import 'package:intl/intl.dart'; // Removed to avoid dependency issues

class AppDateUtils {
  // Arabic month names
  static const List<String> arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  
  // Arabic day names
  static const List<String> arabicDays = [
    'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'
  ];
  
  // Hijri month names
  static const List<String> hijriMonths = [
    'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني', 'جمادى الأولى', 'جمادى الثانية',
    'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
  ];
  
  // Format date in Arabic
  static String formatArabicDate(DateTime date) {
    final day = date.day;
    final month = arabicMonths[date.month - 1];
    final year = date.year;
    final dayName = arabicDays[date.weekday % 7];
    
    return '$dayName، $day $month $year';
  }
  
  // Format time in 12-hour format
  static String formatTime12Hour(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    
    return '$displayHour:$minute $period';
  }
  
  // Format time in 24-hour format
  static String formatTime24Hour(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  // Get time difference in Arabic
  static String getTimeDifferenceArabic(DateTime from, DateTime to) {
    final difference = to.difference(from);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
  
  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }
  
  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }
  
  // Get relative date string
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'اليوم';
    } else if (isTomorrow(date)) {
      return 'غداً';
    } else if (isYesterday(date)) {
      return 'أمس';
    } else {
      return formatArabicDate(date);
    }
  }
  
  // Get days in month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
  
  // Get first day of month
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  // Get last day of month
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
  
  // Check if year is leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
  
  // Get week number of year
  static int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }
  
  // Format duration in Arabic
  static String formatDurationArabic(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '$hoursس $minutesد';
    } else if (minutes > 0) {
      return '$minutesد $secondsث';
    } else {
      return '$secondsث';
    }
  }
  
  // Get Islamic date (simplified - would need proper Hijri calendar library)
  static String getIslamicDateString(DateTime date) {
    // This is a simplified version - in real app, use proper Hijri calendar
    final hijriYear = date.year - 579; // Approximate conversion
    final hijriMonth = hijriMonths[date.month - 1];
    return '$hijriMonth $hijriYear هـ';
  }
  
  // Check if time is between two times
  static bool isTimeBetween(DateTime time, DateTime start, DateTime end) {
    final timeOfDay = time.hour * 60 + time.minute;
    final startOfDay = start.hour * 60 + start.minute;
    final endOfDay = end.hour * 60 + end.minute;
    
    if (startOfDay <= endOfDay) {
      return timeOfDay >= startOfDay && timeOfDay <= endOfDay;
    } else {
      // Crosses midnight
      return timeOfDay >= startOfDay || timeOfDay <= endOfDay;
    }
  }
  
  // Get next occurrence of time
  static DateTime getNextOccurrence(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    
    if (today.isAfter(now)) {
      return today;
    } else {
      return today.add(const Duration(days: 1));
    }
  }
  
  // Format countdown timer
  static String formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
  
  // Get age from birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
  
  // Check if date is weekend (Friday/Saturday in Islamic countries)
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.friday || date.weekday == DateTime.saturday;
  }
  
  // Get business days between two dates
  static int getBusinessDays(DateTime start, DateTime end) {
    int businessDays = 0;
    DateTime current = start;
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (!isWeekend(current)) {
        businessDays++;
      }
      current = current.add(const Duration(days: 1));
    }
    
    return businessDays;
  }
  
  // Parse Arabic numerals to English
  static String parseArabicNumerals(String text) {
    const arabicNumerals = '٠١٢٣٤٥٦٧٨٩';
    const englishNumerals = '0123456789';
    
    String result = text;
    for (int i = 0; i < arabicNumerals.length; i++) {
      result = result.replaceAll(arabicNumerals[i], englishNumerals[i]);
    }
    
    return result;
  }
  
  // Convert English numerals to Arabic
  static String toArabicNumerals(String text) {
    const arabicNumerals = '٠١٢٣٤٥٦٧٨٩';
    const englishNumerals = '0123456789';
    
    String result = text;
    for (int i = 0; i < englishNumerals.length; i++) {
      result = result.replaceAll(englishNumerals[i], arabicNumerals[i]);
    }
    
    return result;
  }
}
