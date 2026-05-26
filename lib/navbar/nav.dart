import 'dart:async';
import 'package:flutter/material.dart';
import 'package:booktoplay_app/auth/mobile_login.dart';
import 'package:booktoplay_app/navbar/shell.dart';
import 'package:booktoplay_app/screen/bookings/booking.dart';
import 'package:booktoplay_app/screen/dashboard/dashboard.dart';
import 'package:booktoplay_app/screen/landing/landing.dart';
import 'package:booktoplay_app/screen/profile/acountdetails.dart';
import 'package:booktoplay_app/screen/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;

    final isLoginPage = state.matchedLocation == '/login';
    final isLandingPage = state.matchedLocation == '/';

    if (isLoggedIn && (isLoginPage || isLandingPage)) {
      return '/home';
    }

    if (!isLoggedIn &&
        state.matchedLocation != '/' &&
        state.matchedLocation != '/login') {
      return '/login';
    }

    return null;
  },

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => Dashboard(),
        ),
        GoRoute(
          path: '/Bookings',
          builder: (_, _) => const Booking(),
        ),
        GoRoute(
          path: '/Profile',
          builder: (_, _) => const ProfileScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/',
      builder: (_, _) => const Landing(),
    ),

    GoRoute(
      path: '/login',
      builder: (_, _) => const MobileLoging(),
    ),

    GoRoute(
      path: '/accountdetails',
      builder: (context, state) {
        final currentUser = FirebaseAuth.instance.currentUser;
        return AccountDetailsScreen(
          email: currentUser?.email ?? 'No email available',
          uid: currentUser?.uid ?? 'No UID found',
        );
      },
    ),
  ],
);