import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/repositories/refresh_token_repository.dart';
import '../../routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();
  final _refreshRepo = RefreshTokenRepository();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Short splash delay for UX
    await Future.delayed(const Duration(milliseconds: 400));

    final access = await _storage.read(key: 'access_token');
    if (access != null && access.isNotEmpty) {
   
      if (!mounted) return;
      _goToHome();
      return;
    }


    try {
      final ok = await _refreshRepo.refreshToken();
      if (ok) {
        if (!mounted) return;
        _goToHome();
        return;
      }
    } catch (e, st) {

      print('Splash: refreshToken error: $e\n$st');
    }

    if (!mounted) return;
    _goToLogin();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacementNamed(RouteName.home);
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed(RouteName.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.code, size: 72, color: Color(0xFF2E7DFF)),
            SizedBox(height: 16),
            Text('DevLearn', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
