import 'package:flutter/material.dart';
import '../../core/utils/haptic_utils.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home/home_tab.dart';
import 'studi/studi_tab.dart';
import 'akademik/akademik_tab.dart';
import 'profile/profile_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  final List<Widget> _pages = const [
    _KeepAliveWrapper(child: HomeTab()),
    _KeepAliveWrapper(child: StudiTab()),
    _KeepAliveWrapper(child: AkademikTab()),
    _KeepAliveWrapper(child: ProfileTab()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          if (_currentIndex != index) {
            HapticUtils.lightImpact();
            setState(() => _currentIndex = index);
          }
        },
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
