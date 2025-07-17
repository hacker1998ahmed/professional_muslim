class FastDay {
  final DateTime date;
  final bool completed;
  final String? notes;

  FastDay({
    required this.date,
    this.completed = false,
    this.notes,
  });

  FastDay copyWith({
    DateTime? date,
    bool? completed,
    String? notes,
  }) {
    return FastDay(
      date: date ?? this.date,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'completed': completed,
      'notes': notes,
    };
  }

  factory FastDay.fromJson(Map<String, dynamic> json) {
    return FastDay(
      date: DateTime.parse(json['date'] as String),
      completed: json['completed'] as bool,
      notes: json['notes'] as String?,
    );
  }
}

class FastingMonth {
  final String name;
  final int year;
  final List<FastDay> days;
  final FastingType type;

  FastingMonth({
    required this.name,
    required this.year,
    required this.days,
    required this.type,
  });

  int get completedDays => days.where((day) => day.completed).length;

  double get completionPercentage {
    return (completedDays / days.length) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'year': year,
      'days': days.map((day) => day.toJson()).toList(),
      'type': type.toString(),
    };
  }

  factory FastingMonth.fromJson(Map<String, dynamic> json) {
    return FastingMonth(
      name: json['name'] as String,
      year: json['year'] as int,
      days: (json['days'] as List)
          .map((day) => FastDay.fromJson(day as Map<String, dynamic>))
          .toList(),
      type: FastingType.values.firstWhere(
        (type) => type.toString() == json['type'],
      ),
    );
  }
}

enum FastingType {
  ramadan,
  voluntary,
  sixShawwal,
  ashura,
  arafah,
  mondayThursday,
  ayamBeed,
  other
}