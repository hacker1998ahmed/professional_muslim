class Heir {
  final String relation;
  final Gender gender;
  final int count;
  double share;

  Heir({
    required this.relation,
    required this.gender,
    required this.count,
    this.share = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      'gender': gender.toString(),
      'count': count,
      'share': share,
    };
  }

  factory Heir.fromJson(Map<String, dynamic> json) {
    return Heir(
      relation: json['relation'] as String,
      gender: Gender.values.firstWhere(
        (g) => g.toString() == json['gender'],
      ),
      count: json['count'] as int,
      share: json['share'] as double,
    );
  }
}

enum Gender {
  male,
  female
}

class InheritanceCalculation {
  final double totalEstate;
  final List<Heir> heirs;
  final List<Debt> debts;
  final List<Bequest> bequests;
  final double funeralExpenses;

  InheritanceCalculation({
    required this.totalEstate,
    required this.heirs,
    this.debts = const [],
    this.bequests = const [],
    this.funeralExpenses = 0.0,
  });

  double get totalDebts =>
      debts.fold(0.0, (sum, debt) => sum + debt.amount);

  double get totalBequests =>
      bequests.fold(0.0, (sum, bequest) => sum + bequest.amount);

  double get netEstate {
    final afterFuneral = totalEstate - funeralExpenses;
    final afterDebts = afterFuneral - totalDebts;
    final afterBequests = afterDebts - totalBequests;
    return afterBequests > 0 ? afterBequests : 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEstate': totalEstate,
      'heirs': heirs.map((heir) => heir.toJson()).toList(),
      'debts': debts.map((debt) => debt.toJson()).toList(),
      'bequests': bequests.map((bequest) => bequest.toJson()).toList(),
      'funeralExpenses': funeralExpenses,
    };
  }

  factory InheritanceCalculation.fromJson(Map<String, dynamic> json) {
    return InheritanceCalculation(
      totalEstate: json['totalEstate'] as double,
      heirs: (json['heirs'] as List)
          .map((heir) => Heir.fromJson(heir as Map<String, dynamic>))
          .toList(),
      debts: (json['debts'] as List)
          .map((debt) => Debt.fromJson(debt as Map<String, dynamic>))
          .toList(),
      bequests: (json['bequests'] as List)
          .map((bequest) =>
              Bequest.fromJson(bequest as Map<String, dynamic>))
          .toList(),
      funeralExpenses: json['funeralExpenses'] as double,
    );
  }
}

class Debt {
  final String description;
  final double amount;

  Debt({
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
    };
  }

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      description: json['description'] as String,
      amount: json['amount'] as double,
    );
  }
}

class Bequest {
  final String beneficiary;
  final double amount;
  final String? conditions;

  Bequest({
    required this.beneficiary,
    required this.amount,
    this.conditions,
  });

  Map<String, dynamic> toJson() {
    return {
      'beneficiary': beneficiary,
      'amount': amount,
      'conditions': conditions,
    };
  }

  factory Bequest.fromJson(Map<String, dynamic> json) {
    return Bequest(
      beneficiary: json['beneficiary'] as String,
      amount: json['amount'] as double,
      conditions: json['conditions'] as String?,
    );
  }
}