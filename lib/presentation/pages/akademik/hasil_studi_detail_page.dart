import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_gradient.dart';
import '../../widgets/statistic_widgets.dart';

class HasilStudiDetailPage extends StatelessWidget {
  final dynamic semesterData;
  final String nama;
  final String semesterTitle;

  const HasilStudiDetailPage({
    super.key,
    required this.semesterData,
    this.nama = '',
    this.semesterTitle = '',
  });

  Color _getScoreColor(String score) {
    switch (score.toUpperCase()) {
      case 'A':
        return Colors.green[700]!;
      case 'A-':
        return Colors.green[400]!;
      case 'B+':
        return Colors.blue[700]!;
      case 'B':
        return Colors.blue[500]!;
      case 'B-':
        return Colors.blue[300]!;
      case 'C+':
        return Colors.orange[600]!;
      case 'C':
        return Colors.orange[400]!;
      case 'D':
        return Colors.redAccent;
      case 'E':
        return Colors.red;
      default:
        return AppColors.textMuted;
    }
  }

  Widget _buildBelumDinilaiState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.hourglass_empty_rounded,
            size: 80,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Belum Ada Nilai',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Mata kuliah pada semester ini sedang berlangsung atau belum dinilai oleh dosen pengampu.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isBelumDinilai = semesterData.mataKuliah.every(
      (mk) => mk.nilaiHuruf == '-' || mk.nilaiHuruf == '',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: '$semesterTitle (${semesterData.semester})',
        actions: [
          IconButton(
            onPressed: () {
              String shareText =
                  'KHS $semesterTitle (${semesterData.semester})\n'
                  'Nama: $nama\n'
                  'IPS: ${semesterData.ips.toStringAsFixed(2)} | SKS: ${semesterData.sksSemester}\n\n';
              for (var mk in semesterData.mataKuliah) {
                shareText +=
                    '- ${mk.namaMk} (${mk.kodeMk}): ${mk.nilaiHuruf}\n';
              }
              SharePlus.instance.share(
                ShareParams(
                  text: shareText,
                  subject: 'KHS $semesterTitle',
                ),
              );
            },
            icon: const Icon(
              Icons.share_rounded,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomGradient(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 120, 16, 100),
        child: isBelumDinilai
            ? _buildBelumDinilaiState()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Indeks Prestasi Semester',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          semesterData.ips.toStringAsFixed(2),
                          style: AppTextStyles.heading1.copyWith(
                            color: Colors.white,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${semesterData.sksSemester} SKS Total',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Daftar Mata Kuliah', style: AppTextStyles.heading2),
                  const SizedBox(height: 16),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: semesterData.mataKuliah.length,
                    separatorBuilder: (context, idx) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, mkIndex) {
                      final mk = semesterData.mataKuliah[mkIndex];
                      final scoreColor = _getScoreColor(mk.nilaiHuruf);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: scoreColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mk.namaMk,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${mk.kodeMk} • ${mk.sks} SKS',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: scoreColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: scoreColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              mk.nilaiHuruf,
                              style: AppTextStyles.heading2.copyWith(
                                color: scoreColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Statistik Nilai', style: AppTextStyles.heading2),
                  const SizedBox(height: 16),
                  StatisticWidgets.buildSemesterGradeCharts(semesterData),
                ],
              ),
      ),
    );
  }
}
