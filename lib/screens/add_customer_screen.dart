import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../blocs/customer_cubit.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final aadhaarController = TextEditingController();
  final gstController = TextEditingController();
  final goldController = TextEditingController();
  final jewelleryController = TextEditingController();
  final dueController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    aadhaarController.dispose();
    gstController.dispose();
    goldController.dispose();
    jewelleryController.dispose();
    dueController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Widget buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.goldDark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE6D8A8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE6D8A8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.gold,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios)),
            Expanded(child: Center(child: const Text("Add Customer"))),
          ],
        ),
        backgroundColor: AppTheme.gold,
      ),
      body: BlocConsumer<CustomerCubit, CustomerState>(
        listener: (context, state) {
          if (state is CustomerOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is CustomerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
            buildFieldTitle("Customer Name"),
            buildTextField(
              controller: nameController,
              hint: "Enter customer name",
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Mobile Number"),
            buildTextField(
              controller: mobileController,
              hint: "Enter mobile number",
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Address"),
            buildTextField(
              controller: addressController,
              hint: "Enter full address",
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Aadhaar Number"),
            buildTextField(
              controller: aadhaarController,
              hint: "Enter Aadhaar number",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            buildFieldTitle("GST Number"),
            buildTextField(
              controller: gstController,
              hint: "Enter GST number",
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Opening Gold Balance (Gram)"),
            buildTextField(
              controller: goldController,
              hint: "Enter gold balance in gram",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Opening Jewellery Balance (Gram)"),
            buildTextField(
              controller: jewelleryController,
              hint: "Enter jewellery balance in gram",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Opening Payment Due (₹)"),
            buildTextField(
              controller: dueController,
              hint: "Enter pending amount",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            buildFieldTitle("Notes"),
            buildTextField(
              controller: notesController,
              hint: "Enter remarks",
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            if (state is CustomerLoading)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter customer name"),
                        ),
                      );
                      return;
                    }
                    if (mobileController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter mobile number"),
                        ),
                      );
                      return;
                    }
                    if (addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter address"),
                        ),
                      );
                      return;
                    }
                    
                    context.read<CustomerCubit>().createCustomer(
                      name: nameController.text.trim(),
                      mobile: mobileController.text.trim(),
                      address: addressController.text.trim(),
                      aadhaar: aadhaarController.text.trim().isEmpty ? null : aadhaarController.text.trim(),
                      gst: gstController.text.trim().isEmpty ? null : gstController.text.trim(),
                      goldBalance: goldController.text.trim().isEmpty ? null : double.tryParse(goldController.text.trim()),
                      jewelleryBalance: jewelleryController.text.trim().isEmpty ? null : double.tryParse(jewelleryController.text.trim()),
                      paymentDue: dueController.text.trim().isEmpty ? null : double.tryParse(dueController.text.trim()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Customer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      );
    },
  ),
);
  }
}