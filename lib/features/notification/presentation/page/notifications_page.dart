import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

/// Page to display user notifications
class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final _scrollController = ScrollController();

  /// Text styles for notifications
  TextStyle get _notificationTitle => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.3,
      );

  TextStyle get _notificationBody => TextStyle(
        fontSize: 14.sp,
        color: secondaryTextColor,
        height: 1.4,
      );

  TextStyle get _notificationTime => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor.withOpacity(0.7),
      );

  @override
  void initState() {
    super.initState();
    // Start listening to notifications after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _initNotifications());
  }

  /// Initialize notifications for the current user
  void _initNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(StartListeningNotifications(user.uid));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return _buildLoadingState();
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) return _buildEmptyState();
            return _buildNotificationList(state.notifications);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// AppBar for the notification screen
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: -0.5,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.w),
        onPressed: () => Navigator.pop(context),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }

  /// Loading indicator while fetching notifications
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: 2.5,
      ).animate().scale(duration: 300.ms),
    );
  }

  /// ListView for notifications
  Widget _buildNotificationList(List notifications) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async => _initNotifications(),
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) => _buildNotificationCard(notifications[index], index),
      ),
    );
  }

  /// Individual notification card
  Widget _buildNotificationCard(dynamic notification, int index) {
    bool isUnread = true; // TODO: Replace with actual unread logic

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms, delay: (index * 50).ms),
        SlideEffect(
          begin: const Offset(0, 0.2),
          duration: 300.ms,
          delay: (index * 50).ms,
          curve: Curves.easeOutQuart,
        ),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isUnread ? Colors.white : Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isUnread ? 0.05 : 0.02),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              // Handle notification tap
            },
            splashColor: primaryColor.withOpacity(0.1),
            highlightColor: primaryColor.withOpacity(0.05),
            child: Stack(
              children: [
                if (isUnread)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4.w,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNotificationIcon(),
                      SizedBox(width: 16.w),
                      Expanded(child: _buildNotificationContent(notification, isUnread)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Notification icon with gradient background
  Widget _buildNotificationIcon() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.2), primaryColor.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.notifications_active_rounded, color: primaryColor, size: 24.w),
    );
  }

  /// Notification content with title, body, and timestamp
  Widget _buildNotificationContent(dynamic notification, bool isUnread) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(notification.title, style: _notificationTitle)),
            if (isUnread)
              Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(left: 8.w, top: 4.w),
                decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          notification.body,
          style: _notificationBody,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.access_time_rounded, size: 14.w, color: secondaryTextColor.withOpacity(0.5)),
            SizedBox(width: 6.w),
            Text(
              DateFormat('MMM d, h:mm a').format(notification.timestamp.toLocal()),
              style: _notificationTime,
            ),
          ],
        ),
      ],
    );
  }

  /// Empty state widget when no notifications exist
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_rounded, size: 80.w, color: secondaryTextColor.withOpacity(0.3))
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 300.ms),
            SizedBox(height: 24.h),
            Text(
              'No Notifications',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: textColor),
            ).animate().fadeIn(delay: 200.ms).slide(begin: const Offset(0, 0.1)),
            SizedBox(height: 8.h),
            Text(
              'When new notifications arrive,\nthey will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: secondaryTextColor, height: 1.5),
            ).animate().fadeIn(delay: 400.ms).slide(begin: const Offset(0, 0.1)),
          ],
        ),
      ),
    );
  }
}
