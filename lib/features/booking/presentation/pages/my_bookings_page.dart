import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/widgets/dot_loader.dart';
import 'package:innerspace_booking_app/features/booking/presentation/pages/widgets/booking_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace_booking_app/core/utils/responsive.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBookingsPage
    extends
        StatefulWidget {
  const MyBookingsPage({
    super.key,
  });

  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState
    extends
        State<
          MyBookingsPage
        > {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        context
            .read<
              BookingBloc
            >()
            .add(
              GetUserBookingsEvent(),
            );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,

        title: Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        elevation: 5, // Soft shadow height
        shadowColor: Colors.black.withOpacity(
          0.1,
        ), // iconTheme: const IconThemeData(color: Colors.black),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [darkBackground, gradientOne],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        // ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          //   gradient: LinearGradient(
          //     colors: [darkBackground, gradientOne.withOpacity(0.7)],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
        ),
        child:
            BlocBuilder<
              BookingBloc,
              BookingState
            >(
              builder:
                  (
                    context,
                    state,
                  ) {
                    if (state
                        is BookingLoading) {
                      return  Center(
                        child: DotLoader(
                          color: gradientOne,
                         
                             
                        ),
                      );
                    } else if (state
                        is BookingsLoaded) {
                      if (state.bookings.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 60,
                                color: primaryColor.withOpacity(
                                  0.5,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'No Bookings Yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    0.8,
                                  ),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Book your first workspace to get started',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    0.6,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to booking screen
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Explore Workspaces',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return RefreshIndicator(
                        color: primaryColor,
                        onRefresh: () async {
                          context
                              .read<
                                BookingBloc
                              >()
                              .add(
                                GetUserBookingsEvent(),
                              );
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          itemCount: state.bookings.length,
                          separatorBuilder:
                              (
                                context,
                                index,
                              ) => const SizedBox(
                                height: 12,
                              ),
                          itemBuilder:
                              (
                                context,
                                index,
                              ) {
                                final booking = state.bookings[index];
                                return BookingCard(
                                  booking: booking,
                                );
                              },
                        ),
                      );
                    } else if (state
                        is BookingError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red[400],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Something went wrong',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    0.7,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<
                                      BookingBloc
                                    >()
                                    .add(
                                      GetUserBookingsEvent(),
                                    );
                              },
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
            ),
      ),
    );
  }
}
