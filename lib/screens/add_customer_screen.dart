import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../blocs/customer/customer_cubit.dart';
import '../data/models/customer_model.dart';
import '../data/models/transaction_model.dart';

class AddCustomerScreen extends StatefulWidget {
  final CustomerModel? customer;
  final bool isEdit;

  const AddCustomerScreen({super.key, this.customer, this.isEdit = false});

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

  CurrencyType selectedCurrency = CurrencyType.inr;
  String selectedGoldBalanceType = 'NAMAE';
  String selectedJewelleryBalanceType = 'NAMAE';
  String selectedPaymentDueType = 'NAMAE';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.customer != null) {
      nameController.text = widget.customer!.name;
      mobileController.text = widget.customer!.phone ?? '';
      addressController.text = widget.customer!.address ?? '';
      aadhaarController.text = widget.customer!.aadhaar ?? '';
      gstController.text = widget.customer!.gst ?? '';
      goldController.text = widget.customer!.goldBalance.toString();
      jewelleryController.text = widget.customer!.jewelleryBalance.toString();
      dueController.text = widget.customer!.cashBalance.toString();
    }
  }

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
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
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
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios),
            ),
            Expanded(child: Center(child: const Text("Add Customer"))),
          ],
        ),
        backgroundColor: kBg,
      ),
      body: BlocConsumer<CustomerCubit, CustomerState>(
        listener: (context, state) {
          if (state is CustomerOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          } else if (state is CustomerError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),

                const SizedBox(height: 16),

                buildFieldTitle("Address"),
                buildTextField(
                  controller: addressController,
                  hint: "Enter full address",
                  maxLines: 3,
                ),

                // const SizedBox(height: 16),

                // buildFieldTitle("Aadhaar Number"),
                // buildTextField(
                //   controller: aadhaarController,
                //   hint: "Enter Aadhaar number",
                //   keyboardType: TextInputType.number,
                // ),

                // const SizedBox(height: 16),

                // buildFieldTitle("GST Number"),
                // buildTextField(
                //   controller: gstController,
                //   hint: "Enter GST number",
                // ),
                if (!widget.isEdit) ...[
                  const SizedBox(height: 16),

                  buildFieldTitle("Opening Gold Balance (Gram)"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: buildTextField(
                          controller: goldController,
                          hint: "Enter gold balance in gram",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: _buildTypeDropdown(
                          value: selectedGoldBalanceType,
                          onChanged: (val) {
                            setState(() {
                              selectedGoldBalanceType = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  buildFieldTitle("Opening Jewellery Balance (Gram)"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: buildTextField(
                          controller: jewelleryController,
                          hint: "Enter jewellery balance in gram",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: _buildTypeDropdown(
                          value: selectedJewelleryBalanceType,
                          onChanged: (val) {
                            setState(() {
                              selectedJewelleryBalanceType = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  buildFieldTitle("Opening Payment Due (Amount & Currency)"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(
                          controller: dueController,
                          hint: "Enter pending amount",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: _buildTypeDropdown(
                          value: selectedPaymentDueType,
                          onChanged: (val) {
                            setState(() {
                              selectedPaymentDueType = val!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<CurrencyType>(
                          initialValue: selectedCurrency,
                          dropdownColor: kBg,
                          decoration: InputDecoration(
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
                          ),
                          items: CurrencyType.values.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedCurrency = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],

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
                        if (widget.isEdit && widget.customer != null) {
                          context.read<CustomerCubit>().updateCustomer(
                            id: widget.customer!.id,
                            name: nameController.text.trim(),
                            mobile: mobileController.text.trim().isEmpty
                                ? null
                                : mobileController.text.trim(),
                            address: addressController.text.trim().isEmpty
                                ? null
                                : addressController.text.trim(),
                            aadhaar: aadhaarController.text.trim().isEmpty
                                ? null
                                : aadhaarController.text.trim(),
                            gst: gstController.text.trim().isEmpty
                                ? null
                                : gstController.text.trim(),
                          );
                        } else {
                          context.read<CustomerCubit>().createCustomer(
                            name: nameController.text.trim(),
                            mobile: mobileController.text.trim().isEmpty
                                ? null
                                : mobileController.text.trim(),
                            address: addressController.text.trim().isEmpty
                                ? null
                                : addressController.text.trim(),
                            aadhaar: aadhaarController.text.trim().isEmpty
                                ? null
                                : aadhaarController.text.trim(),
                            gst: gstController.text.trim().isEmpty
                                ? null
                                : gstController.text.trim(),
                            goldBalance: goldController.text.trim().isEmpty
                                ? null
                                : double.tryParse(goldController.text.trim()),
                            goldBalanceType: selectedGoldBalanceType,
                            jewelleryBalance:
                                jewelleryController.text.trim().isEmpty
                                ? null
                                : double.tryParse(
                                    jewelleryController.text.trim(),
                                  ),
                            jewelleryBalanceType: selectedJewelleryBalanceType,
                            paymentDue: dueController.text.trim().isEmpty
                                ? null
                                : double.tryParse(dueController.text.trim()),
                            paymentDueType: selectedPaymentDueType,
                            currency: dueController.text.trim().isEmpty
                                ? null
                                : selectedCurrency,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Save Customer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

  Widget _buildTypeDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: kBg,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'NAMAE', child: Text('NAMAE')),
        DropdownMenuItem(value: 'JAMA', child: Text('JAMA')),
      ],
      onChanged: onChanged,
    );
  }
}
