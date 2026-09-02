import 'package:flutter/material.dart';
import 'hasil_studi_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';

class AkademikTab extends StatefulWidget {
  const AkademikTab({super.key});

  @override
  State<AkademikTab> createState() => _AkademikTabState();
}

class _AkademikTabState extends State<AkademikTab>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        _currentIndex = _tabController.index;
        HapticUtils.selectionClick();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak dapat membuka link tersebut',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(showBackButton: false),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 12),
                  child: Center(
                    child: Text('Akademik', style: AppTextStyles.heading2),
                  ),
                ),
                // iOS-style Segmented Control
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    indicatorPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: AppTextStyles.label,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule_rounded, size: 18),
                            const SizedBox(width: 8),
                            const Text('Jadwal'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grade_rounded, size: 18),
                            const SizedBox(width: 8),
                            const Text('Hasil Studi'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildJadwalTab(userData.jadwal),
            _buildHasilStudiTab(userData),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalTab(List<dynamic> jadwalList) {
    if (jadwalList.isEmpty) {
      return _buildEmptyState(
        'Tidak ada jadwal aktif\nGagal merender atau kosong',
        Icons.event_busy_rounded,
      );
    }

    final Map<String, List<dynamic>> groupedJadwal = {
      'Senin': [],
      'Selasa': [],
      'Rabu': [],
      'Kamis': [],
      'Jumat': [],
      'Sabtu': [],
      'Minggu': [],
      'MBKM/Lainnya': [],
    };

    for (var j in jadwalList) {
      final String waktu = (j.ruangWaktu ?? '').toLowerCase();
      if (waktu.isEmpty || waktu.contains('mbkm') || j.kodeMk.toString().toLowerCase().contains('mbkm')) {
        groupedJadwal['MBKM/Lainnya']!.add(j);
      } else if (waktu.startsWith('sen')) {
        groupedJadwal['Senin']!.add(j);
      } else if (waktu.startsWith('sel')) {
        groupedJadwal['Selasa']!.add(j);
      } else if (waktu.startsWith('rab')) {
        groupedJadwal['Rabu']!.add(j);
      } else if (waktu.startsWith('kam')) {
        groupedJadwal['Kamis']!.add(j);
      } else if (waktu.startsWith('jum')) {
        groupedJadwal['Jumat']!.add(j);
      } else if (waktu.startsWith('sab')) {
        groupedJadwal['Sabtu']!.add(j);
      } else if (waktu.startsWith('min')) {
        groupedJadwal['Minggu']!.add(j);
      } else {
        groupedJadwal['MBKM/Lainnya']!.add(j);
      }
    }

    final activeDays = groupedJadwal.keys.where((k) => groupedJadwal[k]!.isNotEmpty).toList();
    String selectedDay = activeDays.isNotEmpty ? activeDays.first : 'Senin';

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final courses = groupedJadwal[selectedDay] ?? [];

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: SizedBox(
                  height: 85,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activeDays.length,
                    itemBuilder: (context, index) {
                      final day = activeDays[index];
                      final isSelected = day == selectedDay;

                      return GestureDetector(
                        onTap: () {
                          HapticUtils.lightImpact();
                          setState(() {
                            selectedDay = day;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                day == 'MBKM/Lainnya' ? 'MBKM' : day.substring(0, 3).toUpperCase(),
                                style: AppTextStyles.caption.copyWith(
                                  color: isSelected ? AppColors.background.withValues(alpha: 0.9) : AppColors.textMuted,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.background.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${groupedJadwal[day]!.length} Matkul',
                                  style: AppTextStyles.caption.copyWith(
                                    color: isSelected ? AppColors.background : AppColors.primaryLight,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, cIndex) {
                    final j = courses[cIndex];
                    final String waktu = j.ruangWaktu ?? '';
                    
                    bool isMbkm = waktu.isEmpty || waktu.toLowerCase().contains('mbkm') || j.kodeMk.toString().toLowerCase().contains('mbkm') || selectedDay == 'MBKM/Lainnya';
                    String jam = waktu;
                    int spaceIdx = waktu.indexOf(' ');
                    if (spaceIdx != -1) jam = waktu.substring(spaceIdx).trim();
                    if (isMbkm) jam = 'Tanpa Jadwal';

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMbkm ? Colors.orange.withValues(alpha: 0.3) : AppColors.surfaceLight,
                          width: isMbkm ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isMbkm ? Colors.orange.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isMbkm ? Icons.travel_explore_rounded : Icons.import_contacts_rounded,
                                  color: isMbkm ? Colors.orange : AppColors.primaryLight,
                                  size: 20,
                                ),
                              ),
                              if (isMbkm)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    'MBKM',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            j.namaMk,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.meeting_room_rounded, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Expanded(child: Text(
                                'Kls ${j.kelas}',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isMbkm ? Colors.orange.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isMbkm ? Icons.info_outline_rounded : Icons.access_time_rounded, 
                                  size: 12, 
                                  color: isMbkm ? Colors.orange : AppColors.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    jam,
                                    style: AppTextStyles.caption.copyWith(
                                      color: isMbkm ? Colors.orange : AppColors.primaryLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHasilStudiTab(dynamic userData) {
    if (userData.riwayatSemester.isEmpty) {
      return _buildEmptyState(
        'Belum ada hasil studi',
        Icons.history_edu_rounded,
      );
    }

    // Lakukan filter dari list asli berdasarkan nama mata kuliah atau semester
    final rawRiwayat = userData.riwayatSemester as List<dynamic>;
    List<dynamic> filteredRiwayat = [];

    if (_searchQuery.isEmpty) {
      filteredRiwayat = List.from(rawRiwayat);
    } else {
      for (var r in rawRiwayat) {
        var matchesSemester = r.semester.toString().toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        var matchedMataKuliah = r.mataKuliah
            .where(
              (mk) =>
                  mk.namaMk.toString().toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  mk.kodeMk.toString().toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            )
            .toList();

        if (matchesSemester || matchedMataKuliah.isNotEmpty) {
          // Buat salinan instance agar tidak merubah data asli
          // Jika mau exact match matkul, kita bisa timpa, tapi karna ini re-mapping UI kita lewati dan tampilkan seluruh data semester jika cocok
          filteredRiwayat.add(r);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari matkul, kode, atau semester...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 120,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: filteredRiwayat.length,
              itemBuilder: (context, index) {
                final r = filteredRiwayat[index];

                // Hitung semester keberapa berdasarkan index asli di rawRiwayat
                final int originalIndex = rawRiwayat.indexOf(r);
                final int semesterKe = originalIndex + 1;
                final namaPengguna = userData.profil.nama ?? '';

                return InkWell(
                  onTap: () {
                    HapticUtils.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasilStudiDetailPage(
                          semesterData: r,
                          nama: namaPengguna,
                          semesterTitle: 'Semester $semesterKe',
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: AppColors.primaryLight,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Semester $semesterKe',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.semester,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.analytics_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'IPS: ${r.ips.toStringAsFixed(2)}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${r.sksSemester} SKS',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: userData.urlTranskripSementara != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.teal,
                onPressed: () => _launchUrl(userData.urlTranskripSementara!),
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text(
                  'Cetak Transkrip',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.surfaceLight),
          const SizedBox(height: 16),
          Text(msg, style: AppTextStyles.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
