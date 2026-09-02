import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../login_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;
    if (userData == null) return const Center(child: CircularProgressIndicator());

    final profil = userData.profil;
    final detail = userData.detail;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
        child: Column(
          children: [
            // Page Title
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 0),
                child: Text('Profil Saya', style: AppTextStyles.heading2),
              ),
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      profil.nama.substring(0, 1).toUpperCase(),
                      style: AppTextStyles.heading1.copyWith(color: AppColors.primaryLight, fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(profil.nama, style: AppTextStyles.heading2, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(profil.nim, style: AppTextStyles.subtitle.copyWith(color: AppColors.primaryLight)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showKtmDigital(context, profil),
                    icon: const Icon(Icons.badge_rounded, size: 18),
                    label: const Text('KTM Digital'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Card Akademik (Prodi, Angkatan, Dosen)
            _buildSection(
              title: 'Informasi Akademik',
              icon: Icons.school_rounded,
              children: [
                _buildInfoRow('Program Studi', profil.prodi),
                _buildInfoRow('Angkatan', profil.angkatan),
                _buildInfoRow('Dosen Wali', profil.dosenWali),
              ],
            ),
            const SizedBox(height: 24),

            // Card Pribadi (TTL, NIK, Agama, Email)
            _buildSection(
              title: 'Informasi Pribadi',
              icon: Icons.person_rounded,
              children: [
                _buildInfoRow('Email', detail.email),
                _buildInfoRow('Agama', detail.agama),
                _buildInfoRow('Jenis Kelamin', detail.jenisKelamin),
                _buildInfoRow('Status Kawin', detail.statusKawin),
                _buildInfoRow('Tempat, Tgl Lahir', detail.ttl),
                _buildInfoRow('No. Handphone', detail.noHp),
                _buildInfoRow('Alamat Asal', detail.alamat),
              ],
            ),
            const SizedBox(height: 32),

              // Logout Button
              CustomButton(
                text: 'Keluar (Logout)',
                icon: Icons.logout_rounded,
                isOutlined: true,
                onPressed: () {
                  _showLogoutDialog(context);
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryLight, size: 24),
                const SizedBox(width: 12),
                Text(title, style: AppTextStyles.heading3),
              ],
            ),
          ),
          Divider(color: AppColors.surfaceLight, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTextStyles.caption)),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? '-' : value,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Konfirmasi Logout', style: AppTextStyles.heading3),
        content: Text('Apakah kamu yakin ingin keluar dari SISKA?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: AppTextStyles.button.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text('Keluar', style: AppTextStyles.button.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showKtmDigital(BuildContext context, dynamic profil) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'KTM Digital',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.credit_card, color: Colors.white, size: 32),
                      Text(
                        'KTM DIGITAL',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      child: Text(
                        profil?.nama?.isNotEmpty == true
                            ? profil!.nama![0].toUpperCase()
                            : '?',
                        style: AppTextStyles.heading1.copyWith(
                            color: AppColors.primary, fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    profil?.nama ?? '-',
                    style: AppTextStyles.heading2.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profil?.nim ?? '-',
                    style: AppTextStyles.heading3.copyWith(
                        color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildKtmRow('Program Studi', profil?.prodi ?? '-'),
                        const SizedBox(height: 8),
                        _buildKtmRow('Angkatan', profil?.angkatan ?? '-'),
                        const SizedBox(height: 8),
                        _buildKtmRow('Dosen Wali', profil?.dosenWali ?? '-'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Mock Barcode
                  Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        30,
                        (index) => Container(
                          width: (index % 3 + 1) * 2.0,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          color: index % 5 == 0 ? Colors.transparent : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Tap luar untuk menutup',
                      style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildKtmRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
        Text(value, style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
