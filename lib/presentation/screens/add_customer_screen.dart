import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import '../state/customer_cubit.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxIdController = TextEditingController();

  /// Regex
  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  final gstRegex = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );
  final phoneRegex = RegExp(r'^[6-9]\d{0,9}$');
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and Mobile Number are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    context
        .read<CustomerCubit>()
        .addCustomer({
          'fullName': _nameController.text.trim(),
          'mobile': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'address': _addressController.text.trim(),
          'gstNumber': _taxIdController.text.trim(),
          'outstandingBalance': 0,
          'status': 'Active',
        })
        .then((_) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Customer saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add New Customer')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _label('Full Name *'),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter full name'),
          ),
          const SizedBox(height: 14),
          _label('Mobile Number *'),
          TextFormField(
            controller: _phoneController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.allow(RegExp(r'^[6-9]\d{0,9}$')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter mobile number';
              }
              if (value.length != 10) {
                return 'Please enter a valid 10-digit mobile number';
              }
              if (!phoneRegex.hasMatch(value)) {
                return 'Please enter a valid mobile number starting with 6, 7, 8, or 9';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: '+91'),
          ),
          const SizedBox(height: 14),
          _label('Email'),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'name@example.com'),
            validator: (value) {
              if (!emailRegex.hasMatch(value ?? '')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _label('Address'),
          TextFormField(
            controller: _addressController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'House, Street, City'),
          ),
          const SizedBox(height: 14),
          _label('GST / PAN'),
          TextFormField(
            controller: _taxIdController,
            validator: (value) {
              final input = value?.toUpperCase() ?? '';
              if (input.isEmpty) {
                return 'Please enter GST / PAN';
              }
              if (input.length > 15) {
                return 'Please enter a valid GST / PAN';
              }
              if (!panRegex.hasMatch(input) && !gstRegex.hasMatch(input)) {
                return 'Please enter a valid PAN or GST number';
              }
              return null;
            },
            decoration: const InputDecoration(hintText: 'Optional'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(_isLoading ? 'SAVING...' : 'SAVE CUSTOMER'),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 4),
    child: Text(
      t,
      style: const TextStyle(
        color: kMuted,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }
}
