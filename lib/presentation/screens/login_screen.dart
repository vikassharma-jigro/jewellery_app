import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import 'dashboard_screen.dart';
import '../../blocs/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _userIdFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _userIdFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_userIdController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (!isValidEmail(_userIdController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<AuthCubit>().login(
      _userIdController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: kBg,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Ambient Background Gradients
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGold.withValues(alpha: 0.08),
                ),
                child: const SizedBox(),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGoldSoft.withValues(alpha: 0.05),
                ),
                child: const SizedBox(),
              ),
            ),

            // Main Layout
            Row(
              children: [
                // Left content (Form & Brand)
                Expanded(
                  flex: isDesktop ? 2 : 1,
                  child: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header / Brand
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: kGold.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.diamond,
                                      size: 56,
                                      color: kGold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Aurelian Ledger',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Playfair Display',
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: kGold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'PRIVATE VAULT ACCESS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: kMuted,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),

                              // Auth Card
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: kCard2,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: kDivider.withValues(alpha: 0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // // Role Selection label
                                    // Text(
                                    //   'DESIGNATION',
                                    //   style: TextStyle(
                                    //     fontSize: 11,
                                    //     fontWeight: FontWeight.w600,
                                    //     color: kMuted,
                                    //     letterSpacing: 1.0,
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 8),

                                    // // Role Selection Buttons
                                    // Container(
                                    //   padding: const EdgeInsets.all(4),
                                    //   decoration: BoxDecoration(
                                    //     color: kCardHigh,
                                    //     borderRadius: BorderRadius.circular(8),
                                    //     border: Border.all(
                                    //       color: kDivider.withValues(alpha: 0.1),
                                    //     ),
                                    //   ),
                                    //   child: Row(
                                    //     children: [
                                    //       _buildRoleTab('Admin'),
                                    //       _buildRoleTab('Manager'),
                                    //       _buildRoleTab('Staff'),
                                    //     ],
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 24),

                                    // User ID Field
                                    AnimatedBuilder(
                                      animation: _userIdFocus,
                                      builder: (context, _) => Text(
                                        'USER IDENTIFIER',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _userIdFocus.hasFocus
                                              ? kGold
                                              : kMuted,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInputField(
                                      controller: _userIdController,
                                      focusNode: _userIdFocus,
                                      hintText: 'Email or Phone Number',
                                      prefixIcon: Icons.person_outline,
                                    ),
                                    const SizedBox(height: 24),

                                    // Password Field
                                    AnimatedBuilder(
                                      animation: _passwordFocus,
                                      builder: (context, _) => Text(
                                        'VAULT KEY',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _passwordFocus.hasFocus
                                              ? kGold
                                              : kMuted,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInputField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocus,
                                      hintText: '••••••••',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscurePassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: kOutline,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // Submit button
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, state) {
                                        final isAuthorizing =
                                            state is AuthLoading;
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 52,
                                          child: ElevatedButton(
                                            onPressed: isAuthorizing
                                                ? null
                                                : _handleLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kGoldContainer,
                                              foregroundColor: const Color(
                                                0xFF241A00,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: isAuthorizing
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Color(
                                                            0xFF241A00,
                                                          ),
                                                        ),
                                                  )
                                                : const Text(
                                                    'SECURE LOGIN',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),

                                    // Forgot Password
                                    // Center(
                                    //   child: TextButton(
                                    //     onPressed: () {},
                                    //     child: const Text(
                                    //       'Forgot Password?',
                                    //       style: TextStyle(
                                    //         color: kGold,
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.w600,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Footer Info
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    size: 14,
                                    color: kOutline.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'AES-256 Encrypted Connection',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: kOutline.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Right image banner (Large screen overlay)
                if (isDesktop)
                  Expanded(
                    flex: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDdJ7WGg2ceOaRaX6qN9-v3isWuTnyZ364q3B479WYtTn8cgNthowxYliEITEwHyXT0wu9MG9_bn-dhN5xjzI-EMSwh7LLkDMFsV8rlpO6oQMfBqZ-C2BFjSC7bZPJtGQLOdhG-TzazynKH0dReUxKlpiGS9tZITD3Pd4e5A4A_58Uo78DEn2RQties7Xa84Z4MC_b0ggoQ3T1l6-lw6ZZh-K3rFrYZ5ZcrKeYFm1bN3Z5PzHGkr63vqPwz8LecddgWNraJPEKnxfWS',
                          fit: BoxFit.cover,
                          color: Colors.black.withValues(alpha: 0.7),
                          colorBlendMode: BlendMode.dstATop,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kBg,
                                kBg.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final hasFocus = focusNode.hasFocus;
        return Container(
          decoration: BoxDecoration(
            color: kCardHigh,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            border: Border(
              bottom: BorderSide(
                color: hasFocus ? kGold : kDivider.withValues(alpha: 0.3),
                width: hasFocus ? 2.0 : 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(prefixIcon, color: kOutline, size: 20),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  style: const TextStyle(color: kText, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: kOutline.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              ?suffixIcon,
            ],
          ),
        );
      },
    );
  }
}
