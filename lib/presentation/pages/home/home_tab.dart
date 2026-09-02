import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../ip_stats_page.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userData = authProvider.userData;
    
    if (userData == null) return const Center(child: CircularProgressIndicator());

    final profil = userData.profil;
    final akademik = userData.akademikSummary;
    final firstName = profil.nama.split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, firstName),
              const SizedBox(height: 32),

              // IPK Highlight Card
              _buildIpkHighlightCard(context, akademik),
              const SizedBox(height: 32),

              // Graduation Tracker
              _buildGraduationTracker(akademik),
              const SizedBox(height: 32),

              // Stats Resume Section
              _buildStatsResumeSection(context, userData.riwayatSemester),
              const SizedBox(height: 32),

              // Next Class / Today's Schedule Highlight
              _buildTodayScheduleSection(userData.jadwal, context),
              const SizedBox(height: 32),

              // Announcements
              _buildAnnouncementsSection(context, userData.pengumuman),
              const SizedBox(height: 32),
            ],
          ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String firstName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            firstName[0].toUpperCase(),
            style: AppTextStyles.heading2.copyWith(color: AppColors.primaryLight),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getGreeting(), style: AppTextStyles.caption),
              Text(firstName, style: AppTextStyles.heading2, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_rounded, color: AppColors.primaryLight),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildIpkHighlightCard(BuildContext context, dynamic akademik) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        HapticUtils.lightImpact();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const IpStatsPage()));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('IPK Kumulatif', style: AppTextStyles.body.copyWith(color: Colors.white70)),
                const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  akademik.ipkKumulatif.toStringAsFixed(2),
                  style: AppTextStyles.heading1.copyWith(fontSize: 48, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text('/ 4.00', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text('Total ${akademik.totalSksKumulatif} SKS', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGraduationTracker(dynamic akademik) {
    int totalSks = akademik.totalSksKumulatif;
    const int targetSks = 144;
    double progress = totalSks / targetSks;
    if (progress > 1.0) progress = 1.0;
    final int sksSisa = (targetSks - totalSks) > 0 ? (targetSks - totalSks) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progres Kelulusan', style: AppTextStyles.heading2),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceLight),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Menuju Sarjana 🎓', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primaryLight),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sksSisa > 0 
                        ? 'Tinggal sisa $sksSisa SKS lagi. Tetap semangat!' 
                        : 'SKS sudah memenuhi syarat kelulusan!',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsResumeSection(BuildContext context, List<dynamic> riwayat) {
    if (riwayat.isEmpty) return const SizedBox();
    final lastIps = riwayat.reversed.toList().last.ips;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Statistik Akademik', style: AppTextStyles.heading2),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IpStatsPage())),
              child: Text('Detail', style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceLight),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('IPS Terakhir', style: AppTextStyles.caption),
                  Text(lastIps.toStringAsFixed(2), style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: lastIps / 4.0,
                backgroundColor: AppColors.background,
                color: AppColors.primaryLight,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodayScheduleSection(List<dynamic> jadwal, BuildContext context) {
    // Tentukan hari ini
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    final todayStr = days[DateTime.now().weekday - 1]; // exp: "Senin"

    // Filter jadwal yang harinya mengandung hari ini pada ruangWaktu
    final todaySchedule = jadwal.where((j) {
      final rw = j.ruangWaktu?.toLowerCase() ?? '';
      return rw.contains(todayStr.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jadwal Kuliah Hari Ini', style: AppTextStyles.heading2),
            if (todaySchedule.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                   NotificationService().showInstantNotification(
                     'Pengingat Jadwal Aktif',
                     'Sistem akan mengingatkanmu 15 menit sebelum kelas dimulai!',
                   );
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Pengingat kuliah hari ini diaktifkan!', style: TextStyle(color: Colors.white)), 
                      backgroundColor: AppColors.success
                   ));
                },
                icon: const Icon(Icons.notifications_active_rounded, size: 16, color: AppColors.primaryLight),
                label: Text('Ingatkan', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            else
              Text(todayStr, style: AppTextStyles.caption.copyWith(color: AppColors.primaryLight)),
          ],
        ),
        const SizedBox(height: 16),
        if (todaySchedule.isEmpty)
          _buildEmptyCard(context, Icons.event_busy_rounded, 'Tidak ada jadwal kuliah hari ini')
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: todaySchedule.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final j = todaySchedule[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceLight),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(j.namaMk, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(j.ruangWaktu ?? 'Belum ditentukan', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAnnouncementsSection(BuildContext context, List<dynamic> pengumuman) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pengumuman', style: AppTextStyles.heading2),
        const SizedBox(height: 16),
        if (pengumuman.isEmpty)
          _buildEmptyCard(context, Icons.campaign_rounded, 'Belum ada pengumuman')
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: pengumuman.length > 3 ? 3 : pengumuman.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = pengumuman[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceLight),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.campaign_rounded, color: AppColors.primaryLight, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.judul, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(p.deskripsi, style: AppTextStyles.caption.copyWith(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context, IconData icon, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
