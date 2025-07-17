import 'package:flutter/material.dart';
import '../models/inheritance_calculator.dart';

class InheritanceProvider extends ChangeNotifier {
  InheritanceCalculation? _calculation;
  String _error = '';

  InheritanceCalculation? get calculation => _calculation;
  String get error => _error;

  void calculateInheritance(InheritanceCalculation calculation) {
    try {
      _error = '';
      _calculation = calculation;
      _distributeShares();
      notifyListeners();
    } catch (e) {
      _error = 'حدث خطأ أثناء حساب المواريث: $e';
      notifyListeners();
    }
  }

  void _distributeShares() {
    if (_calculation == null) return;

    final netEstate = _calculation!.netEstate;
    final heirs = _calculation!.heirs;

    // تطبيق قواعد الميراث الإسلامي
    for (final heir in heirs) {
      switch (heir.relation) {
        case 'زوج':
          heir.share = _calculateHusbandShare(netEstate, heirs);
          break;
        case 'زوجة':
          heir.share = _calculateWifeShare(netEstate, heirs) / heir.count;
          break;
        case 'ابن':
          heir.share = _calculateSonShare(netEstate, heirs) / heir.count;
          break;
        case 'بنت':
          heir.share = _calculateDaughterShare(netEstate, heirs) / heir.count;
          break;
        case 'أب':
          heir.share = _calculateFatherShare(netEstate, heirs);
          break;
        case 'أم':
          heir.share = _calculateMotherShare(netEstate, heirs);
          break;
        // يمكن إضافة المزيد من الحالات حسب الحاجة
      }
    }
  }

  double _calculateHusbandShare(double estate, List<Heir> heirs) {
    // الزوج يرث النصف إذا لم يكن هناك فرع وارث
    // والربع إذا كان هناك فرع وارث
    final hasChildren = heirs.any((heir) =>
        heir.relation == 'ابن' || heir.relation == 'بنت');
    return hasChildren ? estate * 0.25 : estate * 0.5;
  }

  double _calculateWifeShare(double estate, List<Heir> heirs) {
    // الزوجة ترث الربع إذا لم يكن هناك فرع وارث
    // والثمن إذا كان هناك فرع وارث
    final hasChildren = heirs.any((heir) =>
        heir.relation == 'ابن' || heir.relation == 'بنت');
    return hasChildren ? estate * 0.125 : estate * 0.25;
  }

  double _calculateSonShare(double estate, List<Heir> heirs) {
    // الابن يرث الباقي بعد أصحاب الفروض
    // ويقسم بين الذكور والإناث للذكر مثل حظ الأنثيين
    final remainingEstate = _calculateRemainingEstate(estate, heirs);
    final sons = heirs.where((heir) => heir.relation == 'ابن').length;
    final daughters = heirs.where((heir) => heir.relation == 'بنت').length;
    final totalShares = (sons * 2) + daughters;
    return remainingEstate * (2 / totalShares);
  }

  double _calculateDaughterShare(double estate, List<Heir> heirs) {
    // البنت ترث النصف إذا كانت واحدة
    // والثلثين إذا كن اثنتين فأكثر
    // وتشترك مع الابن في الباقي للذكر مثل حظ الأنثيين
    final hasSons = heirs.any((heir) => heir.relation == 'ابن');
    if (hasSons) {
      final remainingEstate = _calculateRemainingEstate(estate, heirs);
      final sons = heirs.where((heir) => heir.relation == 'ابن').length;
      final daughters = heirs.where((heir) => heir.relation == 'بنت').length;
      final totalShares = (sons * 2) + daughters;
      return remainingEstate * (1 / totalShares);
    } else {
      final daughterCount = heirs
          .where((heir) => heir.relation == 'بنت')
          .length;
      return daughterCount == 1 ? estate * 0.5 : estate * (2/3);
    }
  }

  double _calculateFatherShare(double estate, List<Heir> heirs) {
    // الأب يرث السدس مع وجود الفرع الوارث الذكر
    // والسدس + الباقي مع وجود الفرع الوارث الأنثى
    // والباقي تعصيباً عند عدم وجود الفرع الوارث
    final hasSons = heirs.any((heir) => heir.relation == 'ابن');
    final hasDaughters = heirs.any((heir) => heir.relation == 'بنت');

    if (hasSons) {
      return estate * (1/6);
    } else if (hasDaughters) {
      return (estate * (1/6)) + _calculateRemainingEstate(estate, heirs);
    } else {
      return _calculateRemainingEstate(estate, heirs);
    }
  }

  double _calculateMotherShare(double estate, List<Heir> heirs) {
    // الأم ترث الثلث إذا لم يكن هناك فرع وارث ولا عدد من الإخوة
    // والسدس مع وجود الفرع الوارث أو عدد من الإخوة
    final hasChildren = heirs.any((heir) =>
        heir.relation == 'ابن' || heir.relation == 'بنت');
    final hasSiblings = heirs.any((heir) =>
        heir.relation == 'أخ' || heir.relation == 'أخت');

    return (hasChildren || hasSiblings) ? estate * (1/6) : estate * (1/3);
  }

  double _calculateRemainingEstate(double estate, List<Heir> heirs) {
    double remainingEstate = estate;

    // حساب الباقي بعد أصحاب الفروض
    for (final heir in heirs) {
      if (heir.relation == 'زوج' ||
          heir.relation == 'زوجة' ||
          heir.relation == 'أم') {
        remainingEstate -= heir.share;
      }
    }

    return remainingEstate > 0 ? remainingEstate : 0;
  }

  void reset() {
    _calculation = null;
    _error = '';
    notifyListeners();
  }
}