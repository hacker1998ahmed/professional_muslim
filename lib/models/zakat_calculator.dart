class ZakatCalculation {
  final double goldValue;
  final double silverValue;
  final double cashValue;
  final double stocksValue;
  final double propertyValue;
  final double businessValue;
  final double debtsOwed;
  final double debtsToOthers;

  ZakatCalculation({
    this.goldValue = 0.0,
    this.silverValue = 0.0,
    this.cashValue = 0.0,
    this.stocksValue = 0.0,
    this.propertyValue = 0.0,
    this.businessValue = 0.0,
    this.debtsOwed = 0.0,
    this.debtsToOthers = 0.0,
  });

  double get totalAssets {
    return goldValue +
        silverValue +
        cashValue +
        stocksValue +
        propertyValue +
        businessValue +
        debtsOwed;
  }

  double get totalLiabilities {
    return debtsToOthers;
  }

  double get netWorth {
    return totalAssets - totalLiabilities;
  }

  double get zakatAmount {
    // الزكاة تحسب بنسبة 2.5% من صافي الثروة إذا بلغت النصاب
    const double zakatRate = 0.025; // 2.5%
    const double nisabValue = 85; // نصاب الذهب بالجرام
    
    if (netWorth >= nisabValue * goldValue) {
      return netWorth * zakatRate;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'goldValue': goldValue,
      'silverValue': silverValue,
      'cashValue': cashValue,
      'stocksValue': stocksValue,
      'propertyValue': propertyValue,
      'businessValue': businessValue,
      'debtsOwed': debtsOwed,
      'debtsToOthers': debtsToOthers,
      'totalAssets': totalAssets,
      'totalLiabilities': totalLiabilities,
      'netWorth': netWorth,
      'zakatAmount': zakatAmount,
    };
  }
}