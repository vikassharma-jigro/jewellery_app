import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewellary_stock/screens/home_screen.dart';
import 'package:jewellary_stock/screens/login_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../blocs/auth/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minTimeElapsed = false;
  AuthState? _pendingState;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentState = context.read<AuthCubit>().state;
        if (currentState is! AuthInitial && currentState is! AuthLoading) {
          _pendingState = currentState;
        }
      }
    });

    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _minTimeElapsed = true;
        });
        final stateToNavigate =
            _pendingState ?? context.read<AuthCubit>().state;
        if (stateToNavigate is! AuthInitial &&
            stateToNavigate is! AuthLoading) {
          _navigateBasedOnState(stateToNavigate);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateBasedOnState(AuthState state) {
    if (!mounted) return;
    if (state is AuthAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
