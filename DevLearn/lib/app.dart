import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:devlearn/main.dart';
import 'package:devlearn/theme/app_theme.dart';
import 'package:devlearn/routes/app_route.dart';
import 'package:flutter/material.dart';


class DevLearnApp extends StatefulWidget {
  const DevLearnApp({super.key});

  @override
  State<DevLearnApp> createState() => _DevLearnAppState();
}

class _DevLearnAppState extends State<DevLearnApp> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = authRepository.checkAuth();
  }


  void _updateAuthenticationState() {
    setState(() {
      _userFuture = authRepository.checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, 
      debugShowCheckedModeBanner: true,
      title: 'DevLearn',
    
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
   
      home: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen(onLogout: _updateAuthenticationState);
          } else {
            return LoginScreen(onLoginSuccess: _updateAuthenticationState);
          }
        },
      ),
    
      onGenerateRoute: (settings) => AppRoute.onGenerateRoute(
        settings,
        onLoginSuccess: _updateAuthenticationState,
        onLogout: _updateAuthenticationState,
      ),
    );
  }
}
