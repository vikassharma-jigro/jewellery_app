import 'package:flutter/material.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final itemController = TextEditingController();
  final weightController = TextEditingController();
  final quantityController = TextEditingController();
  final remarkController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate;
  String stockType = "Stock In";
  String stockItemType = "Gold";

  @override
  void dispose() {
    itemController.dispose();
    weightController.dispose();
    remarkController.dispose();
    dateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios)),
            Expanded(child: Center(child: const Text("Add Stock"))),
          ],
        ),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text("Stock Type",),
            SizedBox(height: 10,),
            DropdownButtonFormField(
              value: stockType,
              decoration: const InputDecoration(
                hintText: "Stock Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Stock In",
                  child: Text("Stock In"),
                ),
                DropdownMenuItem(
                  value: "Stock Out",
                  child: Text("Stock Out"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  stockType = value!;
                });
              },
            ),

            const SizedBox(height: 15),
            Text("Item Name",),
            SizedBox(height: 10,),
            DropdownButtonFormField(
              value: stockItemType,
              decoration: const InputDecoration(
                hintText: "Stock Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Gold",
                  child: Text("Gold"),
                ),
                // DropdownMenuItem(
                //   value: "Stock Out",
                //   child: Text("Stock Out"),
                // ),
              ],
              onChanged: (value) {
                setState(() {
                  stockItemType = value!;
                });
              },
            ),

            const SizedBox(height: 15),
            Text("Weight (Gram)",),
            SizedBox(height: 10,),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Weight (Gram)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Text("Date",),
            SizedBox(height: 10,),
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_month),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    dateController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            // const SizedBox(height: 15),
            //
            // TextFormField(
            //   controller: quantityController,
            //   keyboardType: TextInputType.number,
            //   decoration: const InputDecoration(
            //     labelText: "Quantity",
            //     border: OutlineInputBorder(),
            //   ),
            // ),

            const SizedBox(height: 15),

            Text("Remark",),
            const SizedBox(height: 15),
            TextFormField(
              controller: remarkController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Remark",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Stock Added Successfully"),
                    ),
                  );
                },
                child: const Text(
                  "SAVE STOCK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}