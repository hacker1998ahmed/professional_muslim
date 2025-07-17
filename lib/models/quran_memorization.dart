class Surah {
  final int number;
  final String name;
  final int totalAyahs;
  final List<Ayah> ayahs;
  final double memorizationProgress;

  Surah({
    required this.number,
    required this.name,
    required this.totalAyahs,
    required this.ayahs,
    this.memorizationProgress = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'totalAyahs': totalAyahs,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
      'memorizationProgress': memorizationProgress,
    };
  }

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      totalAyahs: json['totalAyahs'] as int,
      ayahs: (json['ayahs'] as List)
          .map((ayah) => Ayah.fromJson(ayah as Map<String, dynamic>))
          .toList(),
      memorizationProgress: json['memorizationProgress'] as double,
    );
  }

  Surah copyWith({
    int? number,
    String? name,
    int? totalAyahs,
    List<Ayah>? ayahs,
    double? memorizationProgress,
  }) {
    return Surah(
      number: number ?? this.number,
      name: name ?? this.name,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      ayahs: ayahs ?? this.ayahs,
      memorizationProgress: memorizationProgress ?? this.memorizationProgress,
    );
  }
}

class Ayah {
  final int number;
  final String text;
  final MemorizationStatus status;
  final DateTime? lastReviewed;
  final List<Review> reviews;

  Ayah({
    required this.number,
    required this.text,
    this.status = MemorizationStatus.notStarted,
    this.lastReviewed,
    this.reviews = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'status': status.toString(),
      'lastReviewed': lastReviewed?.toIso8601String(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] as int,
      text: json['text'] as String,
      status: MemorizationStatus.values.firstWhere(
        (status) => status.toString() == json['status'],
      ),
      lastReviewed: json['lastReviewed'] != null
          ? DateTime.parse(json['lastReviewed'] as String)
          : null,
      reviews: (json['reviews'] as List)
          .map((review) => Review.fromJson(review as Map<String, dynamic>))
          .toList(),
    );
  }

  Ayah copyWith({
    int? number,
    String? text,
    MemorizationStatus? status,
    DateTime? lastReviewed,
    List<Review>? reviews,
  }) {
    return Ayah(
      number: number ?? this.number,
      text: text ?? this.text,
      status: status ?? this.status,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      reviews: reviews ?? this.reviews,
    );
  }
}

class Review {
  final DateTime date;
  final ReviewRating rating;
  final String? notes;

  Review({
    required this.date,
    required this.rating,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'rating': rating.toString(),
      'notes': notes,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      date: DateTime.parse(json['date'] as String),
      rating: ReviewRating.values.firstWhere(
        (rating) => rating.toString() == json['rating'],
      ),
      notes: json['notes'] as String?,
    );
  }
}

enum MemorizationStatus {
  notStarted,
  inProgress,
  memorized,
  needsReview
}

enum ReviewRating {
  excellent,
  good,
  fair,
  poor,
  needsPractice
}