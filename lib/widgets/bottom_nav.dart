import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../../core/network/api_endpoints.dart';
import '../screens/dashboard_screen.dart';
import '../screens/customers_screen.dart';
import '../screens/category_summary_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/profile_screen.dart';
import '../blocs/auth/auth_cubit.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final List<Widget>? actions;
  final Widget? fab;

  const AppScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.currentIndex,
    this.actions,
    this.fab,
  });

  void _go(BuildContext c, int i) {
    if (i == currentIndex) return;
    Widget w;
    switch (i) {
      case 0:
        w = const DashboardScreen();
        break;
      case 1:
        w = const CategorySummaryScreen();
        break;
      case 2:
        w = const CustomersScreen();
        break;
      case 3:
        w = const ReportsScreen();
        break;
      case 4:
        w = const ProfileScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(c, MaterialPageRoute(builder: (_) => w));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: kCard2,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: kDivider.withValues(alpha: 0.2), width: 1),
        ),
        leadingWidth: Navigator.canPop(context) ? 56 : (isDesktop ? 240 : 180),
        leading: Navigator.canPop(context)
            ? BackButton(color: kGold)
            : Row(
                children: [
                  const SizedBox(width: 16),
                  // Profile Image Avatar
                  GestureDetector(
                    onTap: () => _go(context, 4),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        final user = authState is AuthAuthenticated
                            ? authState.user
                            : null;
                        final avatarUrl = '';
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kGold.withValues(alpha: 0.2),
                            ),
                            image: avatarUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                      '${ApiEndpoints.baseUrl.replaceAll("/api", "")}$avatarUrl',
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: avatarUrl.isEmpty
                              ? Center(
                                  child: Text(
                                    user?.username.isNotEmpty == true
                                        ? user!.username[0].toUpperCase()
                                        : 'A',
                                    style: const TextStyle(
                                      color: kGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Header / App Title
                  Text(
                    isDesktop ? 'Aurelian Ledger' : 'Aurelian',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kGold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
        centerTitle: true,
        title: isDesktop
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _navTextItem(context, 0, 'Dashboard'),
                  const SizedBox(width: 32),
                  _navTextItem(context, 1, 'Stock'),
                  const SizedBox(width: 32),
                  _navTextItem(context, 2, 'Customers'),
                  const SizedBox(width: 32),
                  _navTextItem(context, 3, 'Ledger'),
                ],
              )
            : null,
        actions: [...?actions, const SizedBox(width: 16)],
      ),
      body: body,
      floatingActionButton: fab,
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                color: kBg,
                border: Border(
                  top: BorderSide(color: kDivider.withValues(alpha: 0.1)),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(
                        context,
                        0,
                        Icons.dashboard_rounded,
                        'Dashboard',
                      ),
                      _navItem(context, 1, Icons.inventory_2_rounded, 'Stock'),
                      _navItem(
                        context,
                        2,
                        Icons.people_alt_rounded,
                        'Customers',
                      ),
                      _navItem(
                        context,
                        3,
                        Icons.account_balance_wallet_rounded,
                        'Ledger',
                      ),
                      _navItem(context, 4, Icons.person_rounded, 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _navTextItem(BuildContext context, int i, String label) {
    final active = i == currentIndex;
    return InkWell(
      onTap: () => _go(context, i),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: active ? kGold : kMuted,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext c, int i, IconData ic, String l) {
    final active = i == currentIndex;
    return InkWell(
      onTap: () => _go(c, i),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? kGoldContainer.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ic,
              color: active ? kGold : kMuted.withValues(alpha: 0.6),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              l,
              style: TextStyle(
                fontSize: 10,
                color: active ? kGold : kMuted.withValues(alpha: 0.6),
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
