import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innerspace_booking_app/core/local_notification_service.dart';
import 'package:innerspace_booking_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:innerspace_booking_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:innerspace_booking_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:innerspace_booking_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:innerspace_booking_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:innerspace_booking_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:innerspace_booking_app/features/booking/domain/usecases/book_space.dart';
import 'package:innerspace_booking_app/features/booking/domain/usecases/check_booking_availability.dart';
import 'package:innerspace_booking_app/features/booking/domain/usecases/get_user_bookings.dart';
import 'package:innerspace_booking_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:innerspace_booking_app/features/branch/data/datasources/branch_remote_data_source.dart';
import 'package:innerspace_booking_app/features/branch/data/repositories/branch_repository_impl.dart';
import 'package:innerspace_booking_app/features/branch/domain/repositories/branch_repository.dart';
import 'package:innerspace_booking_app/features/branch/domain/usecases/get_branches.dart';
import 'package:innerspace_booking_app/features/branch/domain/usecases/search_branches.dart';
import 'package:innerspace_booking_app/features/branch/presentation/bloc/branch_bloc.dart';
import 'package:innerspace_booking_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:innerspace_booking_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:innerspace_booking_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:innerspace_booking_app/features/notification/domain/usecases/get_notifications.dart';
import 'package:innerspace_booking_app/features/notification/domain/usecases/send_notification.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<
  void
>
init() async {
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Firebase core dependencies
  sl.registerLazySingleton(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );
  sl.registerLazySingleton(
    () => FirebaseDatabase.instance,
  );
    sl.registerLazySingleton(() => FirebaseStorage.instance);

// auth
  sl.registerLazySingleton(
    () => AuthRemoteDataSource(
      sl(),
      sl(),
    ),
  );

  // Repository

  sl.registerLazySingleton<
    AuthRepository
  >(
    () => AuthRepositoryImpl(
    remoteDataSource:   sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(
    () => AuthUseCases(
      sl(),
    ),
  );

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      sl(),
    ),
  );

  //
   // Features - Branch
  // Bloc
  sl.registerFactory(
    () => BranchBloc(
      getBranches: sl(),
      searchBranches: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetBranches(sl()));
  sl.registerLazySingleton(() => SearchBranches(sl()));

  // Repository
  sl.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BranchRemoteDataSource>(
    () => BranchRemoteDataSourceImpl(
      firestore: sl(),
      storage: sl(),
    ),
  );

  // Features - Booking
  // Bloc
  sl.registerFactory(
    () => BookingBloc(
      bookSpace: sl(),
      checkBookingAvailability: sl(),
      getUserBookings: sl(), auth:  sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => BookSpace(sl()));
  sl.registerLazySingleton(() => CheckBookingAvailability(sl()));
  sl.registerLazySingleton(() => GetUserBookings(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      firestore: sl(),
      auth: sl(),
    ),
  );

  // Features - Notification
  // Bloc
  sl.registerLazySingleton<LocalNotificationService>(() => LocalNotificationService());

  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => SendNotification(sl()));

  sl.registerFactory(() => NotificationBloc(
        getNotifications: sl(),
        sendNotification: sl(),
        localNotificationService: sl(),
      ));


 
}
