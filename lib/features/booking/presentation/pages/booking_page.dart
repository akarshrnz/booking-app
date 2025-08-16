import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innerspace_booking_app/core/app_text_styles.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:innerspace_booking_app/core/common_widgets/gradient_button.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/widgets/dot_loader.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_event.dart';

/// Page to handle booking of a workspace
class BookingPage extends StatefulWidget {
  final String branchId;
  final String branchName;

  const BookingPage({
    super.key,
    required this.branchId,
    required this.branchName,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Booking state variables
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  double _pricePerHour = 20.0;
  bool _isAvailable = true;

  /// Opens the date picker and updates the selected date
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: gradientOne,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: gradientOne),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _checkAvailability();
    }
  }

  /// Opens the time picker for start time
  Future<void> _selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
      builder: _timePickerThemeBuilder,
    );

    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
        _selectedEndTime = TimeOfDay(hour: picked.hour + 1, minute: picked.minute);
      });
      _checkAvailability();
    }
  }

  /// Opens the time picker for end time
  Future<void> _selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
      builder: _timePickerThemeBuilder,
    );

    if (picked != null && picked != _selectedEndTime) {
      setState(() => _selectedEndTime = picked);
      _checkAvailability();
    }
  }

  /// Custom builder for time pickers to apply theme
  Widget _timePickerThemeBuilder(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: gradientOne,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: gradientOne),
        ),
      ),
      child: child!,
    );
  }

  /// Checks availability for the selected date and time
  void _checkAvailability() {
    context.read<BookingBloc>().add(
          CheckAvailabilityEvent(
            branchId: widget.branchId,
            date: _selectedDate,
            startTime: _selectedStartTime,
            endTime: _selectedEndTime,
          ),
        );
  }

  /// Confirms the booking and triggers BLoC event
  void _bookSpace() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final hours =
        (_selectedEndTime.hour - _selectedStartTime.hour) +
            (_selectedEndTime.minute - _selectedStartTime.minute) / 60;
    final totalPrice = hours * _pricePerHour;

    final booking = Booking(
      id: '',
      branchId: widget.branchId,
      branchName: widget.branchName,
      userId: userId,
      date: _selectedDate,
      startTime: _selectedStartTime,
      endTime: _selectedEndTime,
      totalPrice: totalPrice,
      status: 'upcoming',
    );

    context.read<BookingBloc>().add(BookSpaceEvent(booking));
  }

  @override
  Widget build(BuildContext context) {
    final hours = _selectedEndTime.hour - _selectedStartTime.hour;
    final totalPrice = (hours * _pricePerHour).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text('Book Now', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: _bookingListener,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildSectionHeader('Select Date'),
                SizedBox(height: 8.h),
                _buildDateSelector(),
                SizedBox(height: 24.h),
                _buildSectionHeader('Select Time Slot'),
                SizedBox(height: 8.h),
                _buildTimeSelectors(),
                if (!_isAvailable) _buildAvailabilityWarning(),
                SizedBox(height: 24.h),
                _buildSectionHeader('Booking Summary'),
                SizedBox(height: 12.h),
                _buildBookingSummaryCard(totalPrice, hours),
                SizedBox(height: 24.h),
                _buildBookButton(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Listener for booking state changes
  void _bookingListener(BuildContext context, BookingState state) {
    final user = FirebaseAuth.instance.currentUser;

    if (state is BookingSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking successful!'), backgroundColor: successColor),
      );

      if (user != null) {
        final notification = NotificationEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Booking Confirmed',
          body: 'Your booking for ${widget.branchName} is confirmed.',
          timestamp: DateTime.now(),
        );
        context.read<NotificationBloc>().add(AddNotification(notification, user.uid));
      }

      Navigator.pop(context);
    } else if (state is AvailabilityChecked) {
      setState(() => _isAvailable = state.isAvailable);
    } else if (state is BookingError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: errorColor),
      );
    }
  }

  /// Builds a section header with consistent styling
  Widget _buildSectionHeader(String text) => Text(text, style: AppTextStyles.sectionTitle);

  /// Builds the date selector widget
  Widget _buildDateSelector() => InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('EEE, MMM d, y').format(_selectedDate)),
              Icon(Icons.calendar_today, color: gradientOne),
            ],
          ),
        ),
      );

  /// Builds the time selection row
  Widget _buildTimeSelectors() => Row(
        children: [
          Expanded(child: _buildTimeSelector('Start Time', _selectedStartTime.format(context), () => _selectStartTime(context))),
          SizedBox(width: 16.w),
          Expanded(child: _buildTimeSelector('End Time', _selectedEndTime.format(context), () => _selectEndTime(context))),
        ],
      );

  /// Single time picker widget
  Widget _buildTimeSelector(String label, String time, VoidCallback onTap) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.secondaryText),
          SizedBox(height: 4.h),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(time), Icon(Icons.access_time, color: gradientOne)],
              ),
            ),
          ),
        ],
      );

  /// Warning shown if selected time slot is unavailable
  Widget _buildAvailabilityWarning() => Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: errorColor, size: 18.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'This time slot is not available. Please choose another time.',
                style: AppTextStyles.secondaryText.copyWith(color: errorColor),
              ),
            ),
          ],
        ),
      );

  /// Booking summary card widget
  Widget _buildBookingSummaryCard(String totalPrice, int hours) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            _buildSummaryRow('Branch:', widget.branchName),
            _buildDivider(),
            _buildSummaryRow('Date:', DateFormat.yMMMMd().format(_selectedDate)),
            _buildDivider(),
            _buildSummaryRow('Time:', '${_selectedStartTime.format(context)} - ${_selectedEndTime.format(context)}'),
            _buildDivider(),
            _buildSummaryRow('Duration:', '$hours hours'),
            _buildDivider(),
            _buildSummaryRow('Price:', '₹$totalPrice', isBold: true),
          ],
        ),
      );

  /// Single row in summary card
  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.secondaryText),
            Text(value, style: isBold ? AppTextStyles.cardTitle : AppTextStyles.cardSubText),
          ],
        ),
      );

  /// Divider widget for summary rows
  Widget _buildDivider() => Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.2));

  /// Builds the booking button with loading state
  Widget _buildBookButton() => BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final isLoading = state is BookingLoading;
          return SizedBox(
            width: double.infinity,
            child: isLoading
                ?  DotLoader(color: primaryColor, size: 20)
                : GradientButton(
                    height: 48.h,
                    width: 150.w,
                    gradient:  LinearGradient(begin: Alignment.centerLeft, colors: [gradientOne, gradientTwo]),
                    radius: 16.r,
                    onTap: _isAvailable ? _bookSpace : null,
                    title: "Confirm Booking",
                  ),
          );
        },
      );
}
