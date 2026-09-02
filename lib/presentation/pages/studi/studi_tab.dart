import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';

class StudiTab extends StatefulWidget {
  const StudiTab({super.key});

  @override
  State<StudiTab> createState() => _StudiTabState();
}

class _StudiTabState extends State<StudiTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  void _showRegistrasiPrintDialog(BuildContext context, String actionUrl) {
    String fromSemester = '';
    String tillSemester = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.print_rounded,
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 16),
                Text('Cetak Tagihan', style: AppTextStyles.heading2),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Masukkan range semester yang ingin dicetak:',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Dari (e.g. 20212)',
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => fromSemester = v,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    's/d',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Sampai (e.g. 20232)',
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => tillSemester = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (fromSemester.isNotEmpty && tillSemester.isNotEmpty) {
                    Navigator.pop(context);
                    final uri = Uri.parse(actionUrl);
                    final finalUrl =
                        '${uri.origin}${uri.path}?from=$fromSemester&till=$tillSemester';
                    _launchUrl(finalUrl);
                  }
                },
                child: const Text(
                  'Download PDF',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                      child: Text('Data Studi', style: AppTextStyles.heading2),
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
                      labelPadding: EdgeInsets.zero,
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
                              const Icon(Icons.book_rounded, size: 16),
                              const SizedBox(width: 4),
                              const Flexible(
                                child: Text(
                                  'KRS',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.school_rounded, size: 16),
                              const SizedBox(width: 4),
                              const Flexible(
                                child: Text(
                                  'Kurikulum',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.app_registration_rounded,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Flexible(
                                child: Text(
                                  'Registrasi',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
              // Tab 1: Rencana Studi
              _buildKrsTab(userData),
              // Tab 2: Kurikulum
              _buildKurikulumTab(userData.kurikulum),
              // Tab 3: Registrasi
              _buildRegistrasiTab(context, userData),
            ],
          ),
        ),
    );
  }

  Widget _buildKrsTab(dynamic userData) {
    final krs = userData.krs;
    if (krs.mataKuliah.isEmpty) {
      return _buildEmptyState('Tidak ada Rencana Studi', Icons.edit_document);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 120,
        ),
        itemCount: krs.mataKuliah.length,
        itemBuilder: (context, index) {
          final mk = krs.mataKuliah[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.primaryLight,
                          ),
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mk.kodeMk,
                              style: AppTextStyles.caption.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                mk.dosen.isNotEmpty ? mk.dosen : '-',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                mk.waktu ?? 'Waktu belum ditentukan',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(
                        '${mk.sks} SKS',
                        AppColors.textPrimary,
                        AppColors.surfaceLight,
                      ),
                      _buildTag(
                        mk.jenis,
                        AppColors.primaryLight,
                        AppColors.primary.withValues(alpha: 0.15),
                      ),
                      if (mk.statusKrs.isNotEmpty)
                        _buildTag(
                          mk.statusKrs,
                          AppColors.success,
                          AppColors.success.withValues(alpha: 0.15),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: krs.urlCetakKrs != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: AppColors.primary,
                onPressed: () => _launchUrl(krs.urlCetakKrs!),
                icon: const Icon(Icons.print_rounded, color: Colors.white),
                label: const Text(
                  'Cetak KRS',
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

  Widget _buildTag(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withValues(alpha: 0.1)),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRegistrasiTab(BuildContext context, dynamic userData) {
    final data = userData.registrasi;
    if (data.isEmpty) {
      return _buildEmptyState(
        'Belum ada data registrasi',
        Icons.payment_rounded,
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 120,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final reg = data[index];
          final bool isLunas =
              reg.statusLunas.toLowerCase().contains('lunas') &&
              !reg.statusLunas.toLowerCase().contains('belum');
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Semester ${reg.semesterKe}',
                      style: AppTextStyles.heading2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isLunas
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        reg.statusLunas,
                        style: AppTextStyles.caption.copyWith(
                          color: isLunas ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${reg.jumlah}',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              reg.metodePembayaran,
                              style: AppTextStyles.caption.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              reg.tanggalBayar ?? 'Belum ada data pembayaran',
                              style: AppTextStyles.caption.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: userData.urlCetakRegistrasi != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.indigo,
                onPressed: () => _showRegistrasiPrintDialog(
                  context,
                  userData.urlCetakRegistrasi!,
                ),
                icon: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  'Cetak Tagihan',
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
          Text(msg, style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildKurikulumTab(List<dynamic> data) {
    if (data.isEmpty) {
      return _buildEmptyState(
        'Belum ada data kurikulum',
        Icons.menu_book_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final semester = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ExpansionTile(
            collapsedIconColor: AppColors.primaryLight,
            iconColor: AppColors.primary,
            shape: const Border(),
            title: Text(semester.semester, style: AppTextStyles.heading3),
            subtitle: Text(
              '${semester.totalSks} SKS Total',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: semester.mataKuliah.length,
                separatorBuilder: (context, idx) =>
                    const Divider(color: AppColors.surfaceLight, height: 24),
                itemBuilder: (context, mkIdx) {
                  final mk = semester.mataKuliah[mkIdx];
                  final isDone = mk.statusMk.toLowerCase().contains('sudah');

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.success
                              : AppColors.background,
                          shape: BoxShape.circle,
                          border: isDone
                              ? null
                              : Border.all(
                                  color: AppColors.textMuted.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 2,
                                ),
                        ),
                        child: Icon(
                          isDone
                              ? Icons.check_rounded
                              : Icons.lock_outline_rounded,
                          size: 16,
                          color: isDone ? Colors.white : AppColors.textMuted,
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
                                color: isDone
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mk.kodeMk,
                              style: AppTextStyles.caption.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildTag(
                                  '${mk.sks} SKS',
                                  AppColors.textPrimary,
                                  AppColors.background,
                                ),
                                _buildTag(
                                  mk.sifat,
                                  isDone
                                      ? Colors.amber.shade700
                                      : AppColors.textMuted,
                                  isDone
                                      ? Colors.amber.withValues(alpha: 0.15)
                                      : AppColors.background,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
