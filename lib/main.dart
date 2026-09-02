import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' hide DeviceOrientation;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_wrapper/device_wrapper.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/api_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service (only on native platforms)
  if (!kIsWeb) {
    try {
      await NotificationService().init();
      debugPrint('[MAIN] NotificationService initialized');
    } catch (e) {
      debugPrint('[MAIN] NotificationService init error: $e');
    }
  }

  // Initialize SharedPreferences untuk caching
  await SharedPreferences.getInstance();
  debugPrint('[MAIN] SharedPreferences initialized');
  
  // Set status bar to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ProxyProvider<ApiService, AuthRepository>(
          update: (_, api, previous) => AuthRepository(api),
        ),
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
          update: (_, repository, previous) => previous ?? AuthProvider(repository),
        ),
      ],
      child: const SiskaApp(),
    ),
  );
}

class SiskaApp extends StatelessWidget {
  const SiskaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DeviceWrapper(
      initialMode: DeviceMode.iphone,
      showModeToggle: true,
      initialTheme: WrapperTheme.dark,
      initialOrientation: DeviceOrientation.portrait,
      child: MaterialApp(
        title: 'SISKA Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashPage(),
      ),
    );
  }
}
