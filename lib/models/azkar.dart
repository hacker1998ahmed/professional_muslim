class Azkar {
  final int id;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final String? reference;
  final String? benefit;
  final int count;
  final String category;
  final bool isCompleted;
  final int currentCount;

  const Azkar({
    required this.id,
    required this.arabicText,
    this.transliteration,
    this.translation,
    this.reference,
    this.benefit,
    required this.count,
    required this.category,
    this.isCompleted = false,
    this.currentCount = 0,
  });

  // Create a copy with updated values
  Azkar copyWith({
    int? id,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? reference,
    String? benefit,
    int? count,
    String? category,
    bool? isCompleted,
    int? currentCount,
  }) {
    return Azkar(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      reference: reference ?? this.reference,
      benefit: benefit ?? this.benefit,
      count: count ?? this.count,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'benefit': benefit,
      'count': count,
      'category': category,
      'isCompleted': isCompleted,
      'currentCount': currentCount,
    };
  }

  // Create from JSON
  factory Azkar.fromJson(Map<String, dynamic> json) {
    return Azkar(
      id: json['id'] as int,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String?,
      translation: json['translation'] as String?,
      reference: json['reference'] as String?,
      benefit: json['benefit'] as String?,
      count: json['count'] as int,
      category: json['category'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      currentCount: json['currentCount'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'Azkar(id: $id, arabicText: $arabicText, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Azkar && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Keep the old Zikr class for compatibility
class Zikr {
  final String text;
  final String description;
  final int count;
  final String? reference;
  final String? benefit;

  Zikr({
    required this.text,
    required this.description,
    required this.count,
    this.reference,
    this.benefit,
  });

  factory Zikr.fromJson(Map<String, dynamic> json) {
    return Zikr(
      text: json['text'] as String,
      description: json['description'] as String,
      count: json['count'] as int,
      reference: json['reference'] as String?,
      benefit: json['benefit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'description': description,
      'count': count,
      'reference': reference,
      'benefit': benefit,
    };
  }
}

class AzkarCategory {
  final String title;
  final String description;
  final List<Zikr> azkar;

  AzkarCategory({
    required this.title,
    required this.description,
    required this.azkar,
  });

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    return AzkarCategory(
      title: json['title'] as String,
      description: json['description'] as String,
      azkar: (json['azkar'] as List)
          .map((e) => Zikr.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'azkar': azkar.map((e) => e.toJson()).toList(),
    };
  }
}