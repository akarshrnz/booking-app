
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/core/notification_service.dart';
import 'package:innerspace_booking_app/core/routes/app_router.dart';
import 'package:innerspace_booking_app/core/theme/app_theme.dart';
import 'package:innerspace_booking_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:innerspace_booking_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:innerspace_booking_app/features/branch/presentation/bloc/branch_bloc.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'injection_container.dart' as di;


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';


final NotificationService notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
     await Supabase.initialize(
    url: 'https://afbuolkizvcrvzzgqkcm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmYnVvbGtpenZjcnZ6emdxa2NtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2NzA4MjIsImV4cCI6MjA3MDI0NjgyMn0.325PHz7pbx_S-BSwDFF0w3ytImJgIon25kIdgZM9qsI',
  );
  await di.init();
    await notificationService.initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<BranchBloc>()),
        BlocProvider(create: (_) => di.sl<BookingBloc>()),
        BlocProvider(create: (_) => di.sl<NotificationBloc>()),
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          ScreenUtil.init(context);
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppConstants.splashRoute,
          );
        },
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
  //  await Supabase.initialize(
  //   url: 'https://afbuolkizvcrvzzgqkcm.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmYnVvbGtpenZjcnZ6emdxa2NtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2NzA4MjIsImV4cCI6MjA3MDI0NjgyMn0.325PHz7pbx_S-BSwDFF0w3ytImJgIon25kIdgZM9qsI',
  // );
//   await di.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {

  
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (_) => di.sl<AuthBloc>(),
//         ),
//         BlocProvider<ChatDetailBloc>(
//           create: (_) => di.sl<ChatDetailBloc>(),
//         ),
//         BlocProvider<ChatListBloc>(
//           create: (_) => di.sl<ChatListBloc>(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'ChatApp',
//         theme: ThemeData(
//           scaffoldBackgroundColor: const Color(0xFFF2F5FA),
//           primaryColor: const Color(0xFF5B3EFB),
//           colorScheme: ColorScheme.fromSwatch().copyWith(
//             primary: const Color(0xFF5B3EFB),
//             secondary: const Color(0xFF9C27B0),
//           ),
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Color(0xFF5B3EFB),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//             iconTheme: IconThemeData(color: Colors.white),
//           ),
//           inputDecorationTheme: InputDecorationTheme(
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF5B3EFB), width: 2),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF5B3EFB),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
//             ),
//           ),


//         ),
//         home: SplashScreen(), 
//        // initialRoute: '/splash',
//         routes: {
//           '/splash': (_) => const SplashScreen(),
//           '/login': (_) => const LoginScreen(),
//           '/register': (_) => const RegisterScreen(),
//           '/chat': (_) =>  ChatListScreen(),
//         },
//       ),
//     );
//   }
// }
