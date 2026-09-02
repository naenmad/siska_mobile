import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;

    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profil = userData.profil;
    final akademik = userData.akademikSummary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Profile ──
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.surfaceLight,
                    child: Text(
                      profil.nama.substring(0, 1).toUpperCase(),
                      style: AppTextStyles.heading2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profil.nama,
                          style: AppTextStyles.heading3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profil.nim} • ${profil.prodi}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),

              // ── IPK Summary Cards ──
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      'IPK Kumulatif',
                      akademik.ipkKumulatif.toStringAsFixed(2),
                      Icons.star_rounded,
                      Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      'SKS Lulus',
                      akademik.totalSksKumulatif.toString(),
                      Icons.book_rounded,
                      AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Jadwal Hari Ini / KRS ──
              Text('KRS Semester Ini', style: AppTextStyles.heading2),
              const SizedBox(height: 4),
              Text(userData.krs.periode ?? 'Semester berjalan', style: AppTextStyles.caption),
              const SizedBox(height: 16),

              if (userData.krs.mataKuliah.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.history_edu_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text('Tidak ada mata kuliah', style: AppTextStyles.body),
                        Text('Mungkin sedang ikut program MBKM?', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userData.krs.mataKuliah.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mk = userData.krs.mataKuliah[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceLight, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.class_rounded, color: AppColors.primaryLight),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mk.namaMk,
                                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('${mk.sks} SKS', style: AppTextStyles.caption),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(mk.jenis, style: AppTextStyles.caption.copyWith(fontSize: 10)),
                                    ),
                                    if (mk.statusKrs.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(mk.statusKrs, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.success)),
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 16),
          Text(value, style: AppTextStyles.heading1),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
