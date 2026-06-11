import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../../core/network/api_endpoints.dart';
import 'login_screen.dart';
import '../blocs/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return AppScaffold(
      title: 'Profile',
      currentIndex: 4,
      body: Stack(
        children: [
          // Subtle Ambient background blur circles
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withValues(alpha: 0.03),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withValues(alpha: 0.01),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 16,
                vertical: 24,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section with Luxury Gradient
                      _buildHeaderSection(isDesktop),
                      const SizedBox(height: 24),

                      // Bento Grid Layout
                      if (isDesktop)
                        Column(
                          children: [
                            _buildBusinessInfoCard(user),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildAccountSettings()),
                              ],
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildBusinessInfoCard(user),
                            const SizedBox(height: 20),
                            _buildAccountSettings(),
                          ],
                        ),

                      const SizedBox(height: 32),

                      // Logout CTA
                      _buildLogoutButton(context),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(bool isDesktop) {
    final authState = context.read<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    final avatar = Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kCard,
            border: Border.all(color: kGold, width: 2),
          ),
          child: user?.avatarUrl?.isNotEmpty == true
              ? ClipOval(
                  child: Image.network(
                    '${ApiEndpoints.baseUrl.replaceAll('/api', '')}${user!.avatarUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.business, color: kGold, size: 32),
                    ),
                  ),
                )
              : const Center(
                  child: Icon(Icons.business, color: kGold, size: 32),
                ),
        ),
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: Container(
        //     padding: const EdgeInsets.all(6),
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: kGold,
        //     ),
        //     child: const Icon(Icons.edit, size: 14, color: Color(0xFF241A00)),
        //   ),
        // ),
      ],
    );

    final details = Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          user?.name.isNotEmpty == true ? user!.name : 'No Name Set',
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: kText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: kGoldContainer.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kGold.withValues(alpha: 0.3)),
          ),
          child: const Text(
            'ADMIN',
            style: TextStyle(
              color: kGold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user?.emailOrPhone ?? '',
          style: TextStyle(fontSize: 14, color: kMuted.withValues(alpha: 0.8)),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
        gradient: LinearGradient(
          colors: [kGold.withValues(alpha: 0.08), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avatar,
          SizedBox(width: isDesktop ? 28 : 0, height: isDesktop ? 0 : 20),
          if (isDesktop) Expanded(child: details) else details,
        ],
      ),
    );
  }

  Widget _buildBusinessInfoCard(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.domain_outlined, color: kGold, size: 20),
              SizedBox(width: 10),
              Text(
                'Business Info',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: kDivider.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final useRow = constraints.maxWidth > 550;
              return useRow
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Business Name',
                            // user?.businessName?.isNotEmpty == true
                            //     ? user!.businessName
                            //     : 'Not provided',
                            'Not provided',
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'GST Registration',
                            // user?.gstNumber?.isNotEmpty == true
                            //     ? user!.gstNumber
                            //     : 'Not provided',
                            'Not provided',
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Registered Address',
                            // user?.address?.isNotEmpty == true
                            //     ? user!.address
                            //     : 'Not provided',
                            'Not provided',
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(
                          'Business Name',
                          // user?.businessName?.isNotEmpty == true
                          //     ? user!.businessName
                          //     : 'Not provided',
                          'Not provided',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          'GST Registration',
                          // user?.gstNumber?.isNotEmpty == true
                          //     ? user!.gstNumber
                          //     : 'Not provided',
                          'Not provided',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          'Registered Address',
                          // user?.address?.isNotEmpty == true
                          //     ? user!.address
                          //     : 'Not provided',
                          'Not provided',
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: kGold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kText,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.person_outline_rounded, color: kGold, size: 20),
              SizedBox(width: 10),
              Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: kDivider.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 8),
          _buildActionItem(
            'Update Profile',
            trailing: const Icon(Icons.chevron_right, color: kMuted, size: 18),
            onTap: () => _showUpdateProfileDialog(context),
          ),
          // _buildActionItem(
          //   'Notification Preferences',
          //   trailing: const Icon(Icons.chevron_right, color: kMuted, size: 18),
          // ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String title, {
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title action clicked'),
                backgroundColor: kCard2,
              ),
            );
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: kText,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 48,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: kError,
            side: const BorderSide(color: kError),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          onPressed: () {
            // Confirm logout
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: kMuted),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // pop dialog
                      context.read<AuthCubit>().logout().then((_) {
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    },
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
          },
        ),
      ),
    );
  }

  void _showUpdateProfileDialog(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    final fullNameController = TextEditingController(text: user?.name ?? '');
    final businessNameController = TextEditingController(
      text: '', // user?.businessName ?? '',
    );
    final gstController = TextEditingController(
      text: '',
    ); // user?.gstNumber ?? '');
    final addressController = TextEditingController(
      text: '', // user?.address ?? '',
    );

    String? pickedImagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: kCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: kDivider.withValues(alpha: 0.3)),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kGold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              setState(() {
                                pickedImagePath = pickedFile.path;
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kGold, width: 2),
                                  color: kCardHigh,
                                  image: pickedImagePath != null
                                      ? DecorationImage(
                                          image: FileImage(
                                            File(pickedImagePath!),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: pickedImagePath == null
                                    ? (user?.avatarUrl?.isNotEmpty == true
                                          ? ClipOval(
                                              child: Image.network(
                                                '${ApiEndpoints.baseUrl.replaceAll('/api', '')}${user!.avatarUrl}',
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const Center(
                                                      child: Icon(
                                                        Icons.person_outline,
                                                        size: 40,
                                                        color: kGold,
                                                      ),
                                                    ),
                                              ),
                                            )
                                          : const Center(
                                              child: Icon(
                                                Icons.person_outline,
                                                size: 40,
                                                color: kGold,
                                              ),
                                            ))
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kGold,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        fullNameController,
                        'Full Name',
                        Icons.person,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        businessNameController,
                        'Business Name',
                        Icons.business,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        gstController,
                        'GST Registration',
                        Icons.receipt,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter GST number';
                          }

                          if (!RegExp(
                            r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
                          ).hasMatch(value.trim().toUpperCase())) {
                            return 'Please enter a valid GST number';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        addressController,
                        'Registered Address',
                        Icons.location_on,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your registered address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: kMuted),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kGold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              // API call not implemented in core yet
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: kText),
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kMuted),
        prefixIcon: Icon(icon, color: kGold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kDivider.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kGold),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
