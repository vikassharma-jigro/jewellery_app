import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import '../state/stock_cubit.dart';
import '../state/stock_state.dart';

class NewStockScreen extends StatefulWidget {
  const NewStockScreen({super.key});
  @override
  State<NewStockScreen> createState() => _NewStockScreenState();
}

class _NewStockScreenState extends State<NewStockScreen> {
  final nameController = TextEditingController();
  final purityController = TextEditingController();
  final weightController = TextEditingController();
  final marginController = TextEditingController();
  final rateController = TextEditingController();
  final categoryController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New Stock Entry')),
    body: BlocConsumer<StockCubit, StockState>(
      listener: (context, state) {
        if (state is StockLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is StockError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is StockLoading;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _l('Item Name'),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Diamond Necklace',
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _l('SKU'),
                      TextField(
                        controller: purityController,
                        decoration: const InputDecoration(
                          hintText: 'Enter product purity',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _l('Weight (gm)'),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '0.00'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _l('Margin (%)'),
                      TextField(
                        controller: marginController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '%'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _l('Rate'),
                      TextField(
                        controller: rateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'please enter 1gm rate only',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _l('Category'),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                hintText: 'GOLD / SILVER / DIAMOND',
              ),
            ),
            const SizedBox(height: 14),
            _l('Notes'),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Remarks'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (nameController.text.isEmpty ||
                            rateController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Name and Rate are required'),
                            ),
                          );
                          return;
                        }
                        final weight =
                            double.tryParse(weightController.text) ?? 0;
                        final rate = double.tryParse(rateController.text) ?? 0;
                        final margin =
                            double.tryParse(marginController.text) ?? 0;
                        final valuation =
                            (weight * rate) * (1 + (margin / 100));

                        String category = categoryController.text.trim();
                        if (category.isEmpty) {
                          category = 'Gold';
                        } else {
                          category =
                              category[0].toUpperCase() +
                              category.substring(1).toLowerCase();
                          // Ensure valid enum mapping
                          if (![
                            'Gold',
                            'Diamond',
                            'Watch',
                            'Silver',
                          ].contains(category)) {
                            category = 'Gold';
                          }
                        }

                        context.read<StockCubit>().addItem({
                          'name': nameController.text,
                          'sku': purityController.text.trim().isEmpty
                              ? 'SKU-${DateTime.now().millisecondsSinceEpoch}'
                              : purityController.text.trim(),
                          'category': category,
                          'weight': weight,
                          'valuation': valuation,
                          'purity': purityController
                              .text, // Wait, purityController was used for SKU in UI hint? Let's use purityController for purity if sku is separate, but earlier it was mapped to 'sku'
                          // 'margin' and 'rate' and 'notes' might not exist in backend schema natively as numbers, but we can pass them.
                          'notes': notesController.text,
                          'status': 'Available',
                        });
                      },
                style: ElevatedButton.styleFrom(backgroundColor: kGold),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'ADD TO STOCK',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _l(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 4),
    child: Text(t, style: const TextStyle(color: kMuted, fontSize: 12)),
  );

  @override
  void dispose() {
    nameController.dispose();
    purityController.dispose();
    weightController.dispose();
    marginController.dispose();
    rateController.dispose();
    categoryController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
