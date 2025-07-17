import 'package:flutter/material.dart';
import '../models/zakat_calculator.dart';

class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goldController = TextEditingController();
  final _silverController = TextEditingController();
  final _cashController = TextEditingController();
  final _stocksController = TextEditingController();
  final _propertyController = TextEditingController();
  final _businessController = TextEditingController();
  final _debtsOwedController = TextEditingController();
  final _debtsToOthersController = TextEditingController();

  ZakatCalculation? _calculation;

  @override
  void dispose() {
    _goldController.dispose();
    _silverController.dispose();
    _cashController.dispose();
    _stocksController.dispose();
    _propertyController.dispose();
    _businessController.dispose();
    _debtsOwedController.dispose();
    _debtsToOthersController.dispose();
    super.dispose();
  }

  void _calculateZakat() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _calculation = ZakatCalculation(
          goldValue: double.tryParse(_goldController.text) ?? 0.0,
          silverValue: double.tryParse(_silverController.text) ?? 0.0,
          cashValue: double.tryParse(_cashController.text) ?? 0.0,
          stocksValue: double.tryParse(_stocksController.text) ?? 0.0,
          propertyValue: double.tryParse(_propertyController.text) ?? 0.0,
          businessValue: double.tryParse(_businessController.text) ?? 0.0,
          debtsOwed: double.tryParse(_debtsOwedController.text) ?? 0.0,
          debtsToOthers: double.tryParse(_debtsToOthersController.text) ?? 0.0,
        );
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.attach_money),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة الزكاة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'أدخل قيمة ممتلكاتك',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'قيمة الذهب',
                controller: _goldController,
                helperText: 'أدخل قيمة الذهب بالعملة المحلية',
              ),
              _buildTextField(
                label: 'قيمة الفضة',
                controller: _silverController,
                helperText: 'أدخل قيمة الفضة بالعملة المحلية',
              ),
              _buildTextField(
                label: 'النقود',
                controller: _cashController,
                helperText: 'أدخل مجموع النقود والودائع البنكية',
              ),
              _buildTextField(
                label: 'الأسهم والاستثمارات',
                controller: _stocksController,
                helperText: 'أدخل قيمة الأسهم والاستثمارات',
              ),
              _buildTextField(
                label: 'العقارات المعدة للبيع',
                controller: _propertyController,
                helperText: 'أدخل قيمة العقارات المعدة للبيع',
              ),
              _buildTextField(
                label: 'عروض التجارة',
                controller: _businessController,
                helperText: 'أدخل قيمة البضائع المعدة للبيع',
              ),
              _buildTextField(
                label: 'الديون المستحقة لك',
                controller: _debtsOwedController,
                helperText: 'أدخل قيمة الديون التي لك على الآخرين',
              ),
              _buildTextField(
                label: 'الديون المستحقة عليك',
                controller: _debtsToOthersController,
                helperText: 'أدخل قيمة الديون التي عليك للآخرين',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateZakat,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'احسب الزكاة',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              if (_calculation != null) ...[                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'نتيجة حساب الزكاة',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        _buildResultRow('إجمالي الأصول:', _calculation!.totalAssets),
                        _buildResultRow('إجمالي الديون:', _calculation!.totalLiabilities),
                        _buildResultRow('صافي الثروة:', _calculation!.netWorth),
                        const Divider(),
                        _buildResultRow(
                          'مقدار الزكاة المستحقة:',
                          _calculation!.zakatAmount,
                          isZakat: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value, {bool isZakat = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isZakat ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} ريال',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isZakat ? FontWeight.bold : FontWeight.normal,
              color: isZakat ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}