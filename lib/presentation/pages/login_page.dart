import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _npmController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _npmController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Handle raw NPM vs full email
    String rawUsername = _npmController.text.trim();
    if (RegExp(r'^\d+$').hasMatch(rawUsername)) {
      rawUsername = '$rawUsername@student.unsika.ac.id';
    }

    final success = await authProvider.login(
      rawUsername,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Terjadi kesalahan',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 64, 
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(flex: 1),
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.surfaceLight,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 40,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text('Welcome back,', style: AppTextStyles.heading1),
                    const SizedBox(height: 8),
                    Text(
                      'Login ke akun SISKA kamu',
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: 48),

                    // Form
                    CustomTextField(
                      label: 'NPM / Email Unsika',
                      hint: 'Contoh: 2310631170064',
                      controller: _npmController,
                      prefixIcon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.emailAddress, 
                      validator: (v) =>
                          v!.isEmpty ? 'NPM tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Password',
                      hint: 'Masukkan password siska',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (v) =>
                          v!.isEmpty ? 'Password tidak boleh kosong' : null,
                    ),

                    // Error message provider
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        if (auth.errorMessage != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: AppColors.error,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    auth.errorMessage!,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 32),
                    const Spacer(flex: 2),

                    // Login Button
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Column(
                          children: [
                            CustomButton(
                              text: 'Masuk ke SISKA',
                              icon: Icons.login_rounded,
                              isLoading: auth.isLoading,
                              onPressed: _handleLogin,
                            ),
                            if (auth.isLoading) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Memproses data akademik...\n(Mohon tunggu ±30 detik, jangan tutup aplikasi)',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.bold),
                              ),
                            ]
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Disclaimer / Info
                    Center(
                      child: Text(
                        'Data kamu aman dan hanya digunakan untuk login',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
