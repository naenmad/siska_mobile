import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_gradient.dart';

class IpSimulatorPage extends StatefulWidget {
  const IpSimulatorPage({super.key});

  @override
  State<IpSimulatorPage> createState() => _IpSimulatorPageState();
}

class _IpSimulatorPageState extends State<IpSimulatorPage> {
  double targetIpk = 3.5;
  int targetSks = 144;

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;
    if (userData == null) return const Scaffold();

    final currentIpk = userData.akademikSummary.ipkKumulatif;
    final currentSks = userData.akademikSummary.totalSksKumulatif;

    if (currentSks == 0) return const Scaffold(appBar: CustomAppBar(title: 'Simulator IPK'));

    final remainingSks = targetSks - currentSks;
    
    // (Target SKS * Target IPK) - (Current SKS * Current IPK) = Required Point
    final requiredPoints = (targetSks * targetIpk) - (currentSks * currentIpk);
    double requiredIps = 0;
    
    if (remainingSks > 0) {
      requiredIps = requiredPoints / remainingSks;
    }

    bool isImpossible = requiredIps > 4.0 || requiredIps < 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Simulator Target IPK'),
      bottomNavigationBar: const CustomBottomGradient(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 110, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text('Simulasi Kelulusan', style: AppTextStyles.heading1, textAlign: TextAlign.center)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Kira-kira butuh IPS berapa ya biar bisa lulus dengan IPK idaman?',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            
            // Current Data Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('IPK Saat Ini', currentIpk.toStringAsFixed(2)),
                  Container(height: 40, width: 1, color: AppColors.surfaceLight),
                  _buildStatItem('SKS Diperoleh', currentSks.toString()),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Target Controls
            Text('Tentukan Targetmu', style: AppTextStyles.heading2),
            const SizedBox(height: 24),
            
            _buildSliderLabel('Target Lulus SKS', targetSks.toString()),
            Slider(
              value: targetSks.toDouble(),
              min: 144,
              max: 160,
              divisions: 16,
              activeColor: AppColors.primaryLight,
              inactiveColor: AppColors.surfaceLight,
              onChanged: (val) {
                if (val >= currentSks) {
                   HapticUtils.selectionClick();
                   setState(() => targetSks = val.toInt());
                }
              },
            ),
            if (targetSks < currentSks)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Target SKS tidak boleh kurang dari SKS saat ini', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
              ),
            
            const SizedBox(height: 16),

            _buildSliderLabel('Target IPK Akhir', targetIpk.toStringAsFixed(2)),
            Slider(
              value: targetIpk,
              min: 2.0,
              max: 4.0,
              divisions: 40, // steps of 0.05
              activeColor: AppColors.primaryLight,
              inactiveColor: AppColors.surfaceLight,
              onChanged: (val) {
                HapticUtils.selectionClick();
                setState(() => targetIpk = val);
              },
            ),
            const SizedBox(height: 32),

            // Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isImpossible 
                      ? [AppColors.surfaceLight, AppColors.surface]
                      : [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isImpossible ? [] : [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                   Text('Target IPS yang Dibutuhkan', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                   const SizedBox(height: 8),
                   if (remainingSks <= 0)
                     Text('SKS Sudah Terpenuhi', style: AppTextStyles.heading2.copyWith(color: Colors.white))
                   else if (isImpossible)
                     Text('Tidak Memungkinkan! \n(Butuh IPS > 4.00)', textAlign: TextAlign.center, style: AppTextStyles.heading2.copyWith(color: AppColors.error))
                   else
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Text(requiredIps.toStringAsFixed(2), style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 48)),
                         Padding(
                           padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                           child: Text('/ Semester', style: AppTextStyles.body.copyWith(color: Colors.white70)),
                         ),
                       ],
                     ),
                     const SizedBox(height: 16),
                     Text('Sisa SKS yang harus diambil: $remainingSks SKS', style: AppTextStyles.caption.copyWith(color: Colors.white70)),                     const SizedBox(height: 12),
                     if (remainingSks > 0)
                       Container(
                         padding: const EdgeInsets.all(12),
                         decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                         child: Column(
                           children: [
                             Text('Estimasi Lulus', style: AppTextStyles.caption.copyWith(color: Colors.white70, fontWeight: FontWeight.bold)),
                             const SizedBox(height: 4),
                             Text('Bila ambil 24 SKS/smt: ${(remainingSks / 24).ceil()} Semester lagi', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                             Text('Bila ambil 20 SKS/smt: ${(remainingSks / 20).ceil()} Semester lagi', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                           ],
                         ),
                       ),                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading1.copyWith(color: AppColors.primaryLight)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildSliderLabel(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: AppTextStyles.label.copyWith(color: AppColors.primaryLight)),
        ),
      ],
    );
  }
}
