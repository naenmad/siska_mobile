import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class StatisticWidgets {
  static Widget buildSksChartCard(
    BuildContext context,
    List<dynamic> chronological,
  ) {
    if (chronological.isEmpty) return const SizedBox();

    double maxSks = 0;
    for (var r in chronological) {
      if (r.sksSemester > maxSks) maxSks = r.sksSemester.toDouble();
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(10, 24, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
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
                  value.toInt().toString(),
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          maxY: maxSks + (maxSks * 0.2), // 20% padding above
          barGroups: chronological.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.sksSemester.toDouble(),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                  ),
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  static Widget buildGradeDistributionChart(List<dynamic> chronological) {
    Map<String, int> gradeCounts = {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0};
    int totalGrades = 0;

    for (var r in chronological) {
      if (r.mataKuliah != null) {
        for (var mk in r.mataKuliah) {
          String originalGrade = mk.nilaiHuruf ?? '';
          String grade = 'E'; // default to lowest if unrecognized
          if (originalGrade.contains('A')) {
            grade = 'A';
          } else if (originalGrade.contains('B')) {
            grade = 'B';
          } else if (originalGrade.contains('C')) {
            grade = 'C';
          } else if (originalGrade.contains('D')) {
            grade = 'D';
          }

          if (gradeCounts.containsKey(grade)) {
            gradeCounts[grade] = (gradeCounts[grade] ?? 0) + 1;
            totalGrades++;
          }
        }
      }
    }

    if (totalGrades == 0) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('Belum ada data nilai'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: [
                  if (gradeCounts['A']! > 0)
                    PieChartSectionData(
                      color: Colors.green,
                      value: gradeCounts['A']!.toDouble(),
                      title: '${gradeCounts['A']}',
                      radius: 20,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (gradeCounts['B']! > 0)
                    PieChartSectionData(
                      color: Colors.blue,
                      value: gradeCounts['B']!.toDouble(),
                      title: '${gradeCounts['B']}',
                      radius: 20,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (gradeCounts['C']! > 0)
                    PieChartSectionData(
                      color: Colors.orange,
                      value: gradeCounts['C']!.toDouble(),
                      title: '${gradeCounts['C']}',
                      radius: 20,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (gradeCounts['D']! > 0)
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: gradeCounts['D']!.toDouble(),
                      title: '${gradeCounts['D']}',
                      radius: 20,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  if (gradeCounts['E']! > 0)
                    PieChartSectionData(
                      color: Colors.red,
                      value: gradeCounts['E']!.toDouble(),
                      title: '${gradeCounts['E']}',
                      radius: 20,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGradeLegend(
                  'A (Sangat Baik)',
                  Colors.green,
                  gradeCounts['A']!,
                  totalGrades,
                ),
                if (gradeCounts['A']! > 0) const SizedBox(height: 8),
                _buildGradeLegend(
                  'B (Baik)',
                  Colors.blue,
                  gradeCounts['B']!,
                  totalGrades,
                ),
                if (gradeCounts['B']! > 0) const SizedBox(height: 8),
                _buildGradeLegend(
                  'C (Cukup)',
                  Colors.orange,
                  gradeCounts['C']!,
                  totalGrades,
                ),
                if (gradeCounts['C']! > 0) const SizedBox(height: 8),
                if (gradeCounts['D']! > 0) ...[
                  _buildGradeLegend(
                    'D (Kurang)',
                    Colors.redAccent,
                    gradeCounts['D']!,
                    totalGrades,
                  ),
                  const SizedBox(height: 8),
                ],
                if (gradeCounts['E']! > 0) ...[
                  _buildGradeLegend(
                    'E (Gagal)',
                    Colors.red,
                    gradeCounts['E']!,
                    totalGrades,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildGradeLegend(
    String label,
    Color color,
    int count,
    int total,
  ) {
    if (count == 0) return const SizedBox();
    final percentage = (count / total * 100).toStringAsFixed(1);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 12),
          ),
        ),
        Text(
          '$percentage%',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget buildFinancialSummary(List<dynamic> registrasi) {
    int totalInt = 0;
    for (var r in registrasi) {
      String numOnly = r.jumlah.replaceAll(RegExp(r'[^0-9]'), '');
      if (numOnly.isNotEmpty) {
        totalInt += int.parse(numOnly);
      }
    }

    String formattedTotal = totalInt.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Biaya Pendidikan',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp $formattedTotal',
                  style: AppTextStyles.heading2.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSemesterGradeCharts(dynamic semesterData) {
    Map<String, int> gradeFrequencies = {};
    Map<String, int> sksPerGrade = {};
    int totalGrades = 0;

    for (var mk in semesterData.mataKuliah) {
      String grade = mk.nilaiHuruf ?? 'E';
      if (grade.isEmpty) grade = '-';

      gradeFrequencies[grade] = (gradeFrequencies[grade] ?? 0) + 1;
      sksPerGrade[grade] = (sksPerGrade[grade] ?? 0) + (mk.sks as int);
      totalGrades++;
    }

    if (totalGrades == 0) return const SizedBox();

    final sortedGrades = gradeFrequencies.keys.toList()..sort();

    Color getColorForGrade(String grade) {
      switch (grade.toUpperCase()) {
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
          return Colors.grey;
      }
    }

    final pieSections = sortedGrades.map((grade) {
      return PieChartSectionData(
        color: getColorForGrade(grade),
        value: gradeFrequencies[grade]!.toDouble(),
        title: '$grade\n${gradeFrequencies[grade]}',
        radius: 30,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    final barGroups = sortedGrades.asMap().entries.map((e) {
      final grade = e.value;
      return BarChartGroupData(
        x: e.key,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: sksPerGrade[grade]!.toDouble(),
            color: getColorForGrade(grade),
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
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
              children: [
                Text(
                  'Sebaran Nilai',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Expanded(child: SizedBox(height: 8)),
                SizedBox(
                  height: 100,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 20,
                      sections: pieSections,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
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
              children: [
                Text(
                  'SKS per Nilai',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < sortedGrades.length) {
                                return Text(
                                  sortedGrades[index],
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 10,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barTouchData: BarTouchData(
                        enabled: false,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Colors.transparent,
                          tooltipPadding: EdgeInsets.zero,
                          tooltipMargin: 0,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.round().toString(),
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      maxY: sksPerGrade.values.isEmpty
                          ? 10
                          : (sksPerGrade.values.reduce(
                                  (a, b) => a > b ? a : b,
                                ) +
                                4.0),
                      barGroups: barGroups,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
