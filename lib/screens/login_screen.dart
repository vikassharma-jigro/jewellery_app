import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../blocs/auth_cubit.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Image.asset('assets/images/appLogo.jpeg').center(),
                  const SizedBox(height: 28),
                  const Text(
                    'Jewellery Manager',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ).center(),
                  const SizedBox(height: 6),
                  const Text(
                    'Stock & Ledger Management',
                    style: TextStyle(color: AppTheme.muted),
                  ).center(),
                  const SizedBox(height: 40),
                  const Text(
                    'User ID',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _userCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Enter user ID',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: const Text(
                  //       'Change Password',
                  //       style: TextStyle(color: AppTheme.goldDark),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.goldDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                      ),
                      onPressed: () {
                        final userId = _userCtrl.text.trim();
                        final password = _passCtrl.text;
                        if (userId.isNotEmpty && password.isNotEmpty) {
                          context.read<AuthCubit>().login(userId, password);
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'Secure access · Encrypted data',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

extension _Center on Widget {
  Widget center() => Center(child: this);
}
