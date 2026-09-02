import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/haptic_utils.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
          decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              HapticUtils.lightImpact();
              onTap(index);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            useLegacyColorScheme: false,
            selectedItemColor: primaryColor,
            unselectedItemColor: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
            selectedLabelStyle: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            unselectedLabelStyle: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            activeIcon: Icon(Icons.home_rounded, size: 24),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, size: 24),
            activeIcon: Icon(Icons.menu_book_rounded, size: 24),
            label: 'Studi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 24),
            activeIcon: Icon(Icons.calendar_month_rounded, size: 24),
            label: 'Akademik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            activeIcon: Icon(Icons.person_rounded, size: 24),
            label: 'Profil',
          ),
        ],
      ),
        ),
      ),
    ),
    );
  }
}
