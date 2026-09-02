import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../providers/auth_provider.dart';

class AdministrasiTab extends StatefulWidget {
  const AdministrasiTab({super.key});

  @override
  State<AdministrasiTab> createState() => _AdministrasiTabState();
}

class _AdministrasiTabState extends State<AdministrasiTab> with SingleTickerProviderStateMixin {
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
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: Border(
            top: BorderSide(color: AppColors.surfaceLight, width: 1),
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
                      labelText: 'Dari (e.g. 20211)',
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Sampai (e.g. 20232)',
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => tillSemester = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
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
                    fontSize: 16,
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
        appBar: AppBar(
          title: Text('Administrasi', style: AppTextStyles.heading3),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: AppTextStyles.label,
                tabs: const [
                  Tab(text: 'Registrasi Keuangan'),
                  Tab(text: 'Kurikulum'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRegistrasiTab(context, userData),
            _buildKurikulumTab(userData.kurikulum),
          ],
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
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: AppColors.primaryLight,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Semester ${reg.semesterKe}',
                          style: AppTextStyles.heading2,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isLunas
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isLunas
                              ? AppColors.success.withValues(alpha: 0.3)
                              : AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        reg.statusLunas,
                        style: AppTextStyles.caption.copyWith(
                          color: isLunas
                              ? AppColors.success
                              : AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Total Tagihan', style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  'Rp ${reg.jumlah}',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primaryLight,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reg.metodePembayaran,
                              style: AppTextStyles.caption.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          color: AppColors.surfaceLight,
                          height: 1,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reg.tanggalBayar ?? 'Belum ada data pembayaran',
                              style: AppTextStyles.caption.copyWith(
                                height: 1.4,
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
                backgroundColor: AppColors.primary,
                onPressed: () => _showRegistrasiPrintDialog(
                  context,
                  userData.urlCetakRegistrasi!,
                ),
                icon: const Icon(Icons.download_rounded, color: Colors.white),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.primaryLight),
          ),
          const SizedBox(height: 24),
          Text(
            msg,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
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

  Widget _buildKurikulumTab(List<dynamic> data) {
    if (data.isEmpty) {
      return _buildEmptyState(
        'Belum ada data kurikulum',
        Icons.menu_book_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final semester = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor),
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
            title: Text(semester.semester, style: AppTextStyles.heading2),
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.background,
                          shape: BoxShape.circle,
                          border: isDone
                              ? Border.all(
                                  color: AppColors.success.withValues(
                                    alpha: 0.5,
                                  ),
                                )
                              : Border.all(
                                  color: AppColors.textMuted.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                        ),
                        child: Icon(
                          isDone
                              ? Icons.check_rounded
                              : Icons.lock_outline_rounded,
                          size: 16,
                          color: isDone
                              ? AppColors.success
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 16),
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
                            const SizedBox(height: 6),
                            Text(
                              mk.kodeMk,
                              style: AppTextStyles.caption.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
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
                                _buildTag(
                                  mk.statusMk,
                                  isDone
                                      ? AppColors.success
                                      : AppColors.textMuted,
                                  isDone
                                      ? AppColors.success.withValues(
                                          alpha: 0.15,
                                        )
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
