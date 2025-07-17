import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/inheritance_calculator.dart';
import '../providers/inheritance_provider.dart';

class InheritanceCalculatorScreen extends StatefulWidget {
  const InheritanceCalculatorScreen({super.key});

  @override
  State<InheritanceCalculatorScreen> createState() =>
      _InheritanceCalculatorScreenState();
}

class _InheritanceCalculatorScreenState
    extends State<InheritanceCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _estateController = TextEditingController();
  final _funeralExpensesController = TextEditingController();
  final List<Heir> _heirs = [];
  final List<Debt> _debts = [];
  final List<Bequest> _bequests = [];

  @override
  void dispose() {
    _estateController.dispose();
    _funeralExpensesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة المواريث'),
      ),
      body: Consumer<InheritanceProvider>(
        builder: (context, provider, child) {
          if (provider.error.isNotEmpty) {
            return Center(child: Text(provider.error));
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEstateSection(),
                  const Divider(),
                  _buildHeirsSection(),
                  const Divider(),
                  _buildDebtsSection(),
                  const Divider(),
                  _buildBequestsSection(),
                  const SizedBox(height: 16),
                  _buildCalculateButton(provider),
                  if (provider.calculation != null)
                    _buildResultsSection(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEstateSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التركة والمصاريف',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _estateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'قيمة التركة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال قيمة التركة';
                }
                if (double.tryParse(value) == null) {
                  return 'الرجاء إدخال رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _funeralExpensesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مصاريف الجنازة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (double.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeirsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الورثة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddHeirDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة وارث'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_heirs.isEmpty)
              const Center(child: Text('لا يوجد ورثة'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _heirs.length,
                itemBuilder: (context, index) {
                  final heir = _heirs[index];
                  return ListTile(
                    title: Text(_getHeirTitle(heir)),
                    subtitle: Text('العدد: ${heir.count}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _heirs.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الديون',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddDebtDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة دين'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_debts.isEmpty)
              const Center(child: Text('لا توجد ديون'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _debts.length,
                itemBuilder: (context, index) {
                  final debt = _debts[index];
                  return ListTile(
                    title: Text(debt.description),
                    subtitle: Text('المبلغ: ${debt.amount}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _debts.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBequestsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الوصايا',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddBequestDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة وصية'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_bequests.isEmpty)
              const Center(child: Text('لا توجد وصايا'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _bequests.length,
                itemBuilder: (context, index) {
                  final bequest = _bequests[index];
                  return ListTile(
                    title: Text(bequest.beneficiary),
                    subtitle: Text(
                        'المبلغ: ${bequest.amount}\n${bequest.conditions ?? ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _bequests.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton(InheritanceProvider provider) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final calculation = InheritanceCalculation(
              totalEstate: double.parse(_estateController.text),
              heirs: _heirs,
              debts: _debts,
              bequests: _bequests,
              funeralExpenses: double.tryParse(
                      _funeralExpensesController.text) ??
                  0.0,
            );
            provider.calculateInheritance(calculation);
          }
        },
        child: const Text('حساب المواريث'),
      ),
    );
  }

  Widget _buildResultsSection(InheritanceProvider provider) {
    final calculation = provider.calculation!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نتائج التوزيع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('إجمالي التركة: ${calculation.totalEstate}'),
            Text('مصاريف الجنازة: ${calculation.funeralExpenses}'),
            Text('إجمالي الديون: ${calculation.totalDebts}'),
            Text('إجمالي الوصايا: ${calculation.totalBequests}'),
            Text('صافي التركة: ${calculation.netEstate}'),
            const Divider(),
            const Text(
              'نصيب كل وارث:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...calculation.heirs.map(
              (heir) => Text(
                '${_getHeirTitle(heir)}: ${heir.share.toStringAsFixed(2)}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddHeirDialog() {
    String? selectedRelation;
    Gender selectedGender = Gender.male;
    final countController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة وارث'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedRelation,
                items: [
                  'زوج',
                  'زوجة',
                  'ابن',
                  'بنت',
                  'أب',
                  'أم',
                  'أخ',
                  'أخت',
                ].map((relation) => DropdownMenuItem(
                      value: relation,
                      child: Text(relation),
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRelation = value;
                    selectedGender = value == 'زوج' ||
                            value == 'ابن' ||
                            value == 'أب' ||
                            value == 'أخ'
                        ? Gender.male
                        : Gender.female;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'صلة القرابة',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'العدد',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (selectedRelation != null) {
                setState(() {
                  _heirs.add(Heir(
                    relation: selectedRelation!,
                    gender: selectedGender,
                    count: int.tryParse(countController.text) ?? 1,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddDebtDialog() {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة دين'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'وصف الدين',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (descriptionController.text.isNotEmpty && amount != null) {
                setState(() {
                  _debts.add(Debt(
                    description: descriptionController.text,
                    amount: amount,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddBequestDialog() {
    final beneficiaryController = TextEditingController();
    final amountController = TextEditingController();
    final conditionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة وصية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: beneficiaryController,
              decoration: const InputDecoration(
                labelText: 'المستفيد',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: conditionsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'الشروط (اختياري)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (beneficiaryController.text.isNotEmpty && amount != null) {
                setState(() {
                  _bequests.add(Bequest(
                    beneficiary: beneficiaryController.text,
                    amount: amount,
                    conditions: conditionsController.text.isEmpty
                        ? null
                        : conditionsController.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  String _getHeirTitle(Heir heir) {
    String title = heir.relation;
    if (heir.count > 1) {
      title += ' (${heir.count})';
    }
    return title;
  }
}