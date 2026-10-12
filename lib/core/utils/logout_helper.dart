import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../screens/login_screen.dart';
import '../../theme/app_theme.dart';
import 'navigator_key.dart';

Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kDivider.withValues(alpha: 0.3)),
      ),
      title: const Text(
        'Confirm Logout',
        style: TextStyle(
          fontFamily: 'Playfair Display',
          color: kGold,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Are you sure you want to securely close the ledger session?',
        style: TextStyle(color: kText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text(
            'CANCEL',
            style: TextStyle(color: kMuted),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text(
            'LOGOUT',
            style: TextStyle(
              color: kError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  if (shouldLogout == true && context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(color: kGold),
        ),
      ),
    );

    try {
      await context.read<AuthCubit>().logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    }

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    final navState = navigatorKey.currentState;
    if (navState != null) {
      navState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
