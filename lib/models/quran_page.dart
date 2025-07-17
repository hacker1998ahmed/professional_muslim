class QuranPage {
  final int pageNumber;
  final String text;
  final String surahName;
  final int surahNumber;
  final int juz;
  final int hizb;
  final int rub;
  final String? imageUrl;

  QuranPage({
    required this.pageNumber,
    required this.text,
    required this.surahName,
    required this.surahNumber,
    required this.juz,
    required this.hizb,
    required this.rub,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'text': text,
      'surahName': surahName,
      'surahNumber': surahNumber,
      'juz': juz,
      'hizb': hizb,
      'rub': rub,
      'imageUrl': imageUrl,
    };
  }

  factory QuranPage.fromJson(Map<String, dynamic> json) {
    return QuranPage(
      pageNumber: json['pageNumber'] as int,
      text: json['text'] as String? ?? '',
      surahName: json['surahName'] as String? ?? '',
      surahNumber: json['surahNumber'] as int? ?? 1,
      juz: json['juz'] as int? ?? 1,
      hizb: json['hizb'] as int? ?? 1,
      rub: json['rub'] as int? ?? 1,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class QuranBookmark {
  final int pageNumber;
  final String note;
  final DateTime dateAdded;

  QuranBookmark({
    required this.pageNumber,
    this.note = '',
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'note': note,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory QuranBookmark.fromJson(Map<String, dynamic> json) {
    return QuranBookmark(
      pageNumber: json['pageNumber'] as int,
      note: json['note'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
    );
  }
}