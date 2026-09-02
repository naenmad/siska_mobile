import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/haptic_utils.dart';
import '../providers/auth_provider.dart';
import '../widgets/statistic_widgets.dart';
import 'studi/ip_simulator_page.dart';

import '../widgets/custom_bottom_gradient.dart';

class IpStatsPage extends StatelessWidget {
  const IpStatsPage({super.key});

  int _getSemesterValue(String title) {
    // Extract year (e.g. 2023)
    final yearMatch = RegExp(r'(\d{4})').firstMatch(title);
    int year = yearMatch != null ? int.parse(yearMatch.group(1)!) : 0;

    // Determine term (1 for Ganjil/Odd, 2 for Genap/Even)
    int term = 1;
    if (title.toLowerCase().contains('genap')) {
      term = 2;
    } else if (title.toLowerCase().contains('ganjil')) {
      term = 1;
    }

    return (year * 10) + term;
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;
    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 1. Create sortable pairs
    final rawList = userData.riwayatSemester;

    // Filter out semesters that don't have IPS yet (e.g. current/new semester with 0)
    final filteredList = rawList.where((r) => r.ips > 0).toList();

    final List<Map<String, dynamic>> enrichedList = filteredList
        .map((r) => {'data': r, 'val': _getSemesterValue(r.semester)})
        .toList();

    // 2. Sort by numerical value (Oldest to Newest)
    enrichedList.sort((a, b) => (a['val'] as int).compareTo(b['val'] as int));

    // 3. Chronological list (Semester 1 at index 0)
    final chronological = enrichedList.map((e) => e['data']).toList();

    // 4. Newest first list (List for the details section)
    final newestFirst = chronological.reversed.toList();

    final akademik = userData.akademikSummary;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Statistik Akademik'),
      bottomNavigationBar: const CustomBottomGradient(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallSummary(akademik),
            const SizedBox(height: 24),

            _buildInsightsRow(akademik, chronological),
            const SizedBox(height: 32),

            _buildSimulatorButton(context),
            const SizedBox(height: 32),

            Text('Grafik Perkembangan IPS', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            _buildChartCard(context, chronological),
            const SizedBox(height: 32),

            Text('Grafik Beban SKS', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            StatisticWidgets.buildSksChartCard(context, chronological),
            const SizedBox(height: 32),

            Text('Distribusi Nilai', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            StatisticWidgets.buildGradeDistributionChart(chronological),
            const SizedBox(height: 32),

            Text('Riwayat IPS Semester', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            _buildTrendDetails(newestFirst, chronological),
            const SizedBox(height: 32),

            Text('Rekap Finansial', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            StatisticWidgets.buildFinancialSummary(userData.registrasi),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorButton(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticUtils.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IpSimulatorPage()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calculate_rounded,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Simulator Target IPK', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text(
                    'Hitung target IPK dan target SKS-mu!',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.primaryLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallSummary(dynamic akademik) {
    return Container(
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
          const Text(
            'IPK Kumulatif Saat Ini',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            akademik.ipkKumulatif.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                akademik.totalSksKumulatif.toString(),
                'Total SKS',
              ),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildSummaryItem('Aktif', 'Status'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildSummaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInsightsRow(dynamic akademik, List<dynamic> chronological) {
    String predikat = 'Memuaskan';
    final double ipk = akademik.ipkKumulatif.toDouble();
    if (ipk >= 3.51) {
      predikat = 'Dengan Pujian\n(Cum Laude)';
    } else if (ipk >= 2.76) {
      predikat = 'Sangat\nMemuaskan';
    } else if (ipk >= 2.00) {
      predikat = 'Memuaskan';
    } else {
      predikat = 'Cukup';
    }

    double highestIps = 0;
    int semesterTertinggi = 0;

    for (int i = 0; i < chronological.length; i++) {
      final double ips = chronological[i].ips.toDouble();
      if (ips > highestIps) {
        highestIps = ips;
        // Search index originally in real value
        semesterTertinggi = i + 1;
      }
    }

    return Row(
      children: [
        Expanded(
          child: _buildInsightCard(
            'Predikat',
            predikat,
            Icons.workspace_premium_rounded,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInsightCard(
            'IPS Tertinggi',
            '${highestIps.toStringAsFixed(2)}\nSemester $semesterTertinggi',
            Icons.stars_rounded,
            Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, List<dynamic> chronological) {
    if (chronological.isEmpty) return const SizedBox();

    return Container(
      height: 350,
      padding: const EdgeInsets.fromLTRB(10, 24, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.surfaceLight.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < chronological.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'S${index + 1}',
                        style: AppTextStyles.caption.copyWith(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(1),
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          // Handle case if chronological contains only 1 element so maxX avoids being 0 which crashes LineChart
          maxX: chronological.length > 1
              ? (chronological.length - 1).toDouble()
              : 1.0,
          minY: 0,
          maxY: 4.1, // Slight padding above 4.0
          lineBarsData: [
            LineChartBarData(
              spots: chronological
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.ips))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.35,
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.primaryLight,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendDetails(
    List<dynamic> newestFirst,
    List<dynamic> chronological,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newestFirst.length,
      itemBuilder: (context, index) {
        final r = newestFirst[index];

        // Find actual semester index (chronological) to label correctly (Semester 1, Semester 2...)
        final chronoIndex = chronological.indexOf(r);

        // Calculate difference with the semester BEFORE this in time (index - 1 in chrono)
        double diff = 0;
        if (chronoIndex > 0) {
          diff = r.ips - chronological[chronoIndex - 1].ips;
        }

        final bool isUp = diff > 0;
        final bool isDown = diff < 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      (isUp
                              ? Colors.green
                              : (isDown ? Colors.red : AppColors.textMuted))
                          .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUp
                      ? Icons.trending_up
                      : (isDown
                            ? Icons.trending_down
                            : Icons.horizontal_rule_rounded),
                  color: isUp
                      ? Colors.green
                      : (isDown ? Colors.red : AppColors.textMuted),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semester ${chronoIndex + 1}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${r.sksSemester} SKS • ${r.semester}',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    r.ips.toStringAsFixed(2),
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primaryLight,
                    ),
                  ),
                  if (chronoIndex > 0)
                    Text(
                      '${diff > 0 ? "+" : ""}${diff.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isUp
                            ? Colors.green
                            : (isDown ? Colors.red : AppColors.textMuted),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
