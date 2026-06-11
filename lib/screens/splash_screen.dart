import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/calculator_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../screens/dashboard_screen.dart';
import '../blocs/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minTimeElapsed = false;
  AuthState? _pendingState;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _minTimeElapsed = true;
        });
        if (_pendingState != null) {
          _navigateBasedOnState(_pendingState!);
        }
      }
    });
  }

  void _navigateBasedOnState(AuthState state) {
    if (!mounted) return;
    if (state is AuthAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (state is AuthUnauthenticated || state is AuthError) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CalculatorScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial || state is AuthLoading) return;

        if (_minTimeElapsed) {
          _navigateBasedOnState(state);
        } else {
          _pendingState = state;
        }
      },
      child: const Scaffold(
        backgroundColor: kBg,
        body: Center(child: BrandHeader(subtitle: 'PREMIUM JEWELLERY ERP')),
      ),
    );
  }
}
