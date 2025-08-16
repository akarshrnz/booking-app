import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/login_page.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/signup_page.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:innerspace_booking_app/features/booking/presentation/pages/booking_page.dart';
import 'package:innerspace_booking_app/features/booking/presentation/pages/my_bookings_page.dart';
import 'package:innerspace_booking_app/features/branch/presentation/pages/branch_detail_page.dart';
import 'package:innerspace_booking_app/features/notification/presentation/page/notifications_page.dart';


import '../../features/branch/presentation/pages/home_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppConstants.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppConstants.mapRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
        //return MaterialPageRoute(builder: (_) => const MapPage());
      case AppConstants.branchDetailRoute:
        final branchId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BranchDetailPage(branchId: branchId),
        );
      case AppConstants.bookingRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingPage(
            branchId: args['branchId'],
            branchName: args['branchName'],
          ),
        );
      case AppConstants.myBookingsRoute:
        return MaterialPageRoute(builder: (_) => const MyBookingsPage());
      case AppConstants.notificationsRoute:
        return MaterialPageRoute(builder: (_) =>  NotificationListPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}