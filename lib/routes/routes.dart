import 'package:flutter/material.dart';
import 'package:tontine/screens/all_users.dart';
import 'package:tontine/screens/auth/login_screen.dart';
import 'package:tontine/screens/auth/register_screen.dart';
import 'package:tontine/screens/auth/reset_password_screen.dart';
import 'package:tontine/screens/contribution_form.dart';
import 'package:tontine/screens/contributions.dart';
import 'package:tontine/screens/home_screen.dart';
import 'package:tontine/screens/tontine_session.dart';
import 'package:tontine/screens/tontine_session_details.dart';
import 'package:tontine/screens/preloader.dart';
import 'package:tontine/screens/user_dashboard.dart';


class AppRoutes {
  static const String splash = "/";
  static const String userDashboard = "/user-dashboard";
  static const String login = "/login";
  static const String users = "/users";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";
  static const String home = "/home";
  static const String sessionContributions = "/session-contributions";
  static const String contribute = "/contribute";
  static const String sessions = "/sessions";
  static const String sessionDetails = "/session-details";

  // Handle dynamic routes here
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case sessionDetails:
        final sessionId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => SessionDetailsScreen(sessionId: sessionId),
        );
      default:
        return null; // Handle undefined routes
    }
  }

  // Define only static routes here
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    users: (context) => const UsersScreen(),
    userDashboard: (context) => UserDashboard(),
    // sessionDetails: (context) => (context, args) => generateRoute(args), 
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    home: (context) => const HomeScreen(),
    sessionContributions: (context) => const ContributionsScreen(),
    contribute: (context) => const ContributionForm(),
    sessions: (context) => const SessionsScreen(),
  };
}

