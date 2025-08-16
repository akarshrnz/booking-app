import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/core/app_image.dart';
import 'package:innerspace_booking_app/core/app_text_styles.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/widgets/dot_loader.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';
import 'package:innerspace_booking_app/features/branch/presentation/bloc/branch_bloc.dart';
import 'package:innerspace_booking_app/core/common_widgets/drawer_section.dart';
import 'package:innerspace_booking_app/features/branch/presentation/pages/map_view.dart';
import 'package:innerspace_booking_app/features/branch/presentation/pages/widgets/loaction_selector.dart';
import 'package:innerspace_booking_app/features/branch/presentation/pages/widgets/search_filter_bar.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _tempFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize branches and notifications after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchBloc>().add(GetAllBranches());
      _initNotifications();
      _requestNotificationPermission();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _tempFocusNode.dispose();
    super.dispose();
  }

  /// Initializes notifications for current user
  void _initNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(StartListeningNotifications(user.uid));
    }
  }

  /// Request notification permission if denied
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

 

  /// Navigate to branch detail screen and focus a temporary focus node after returning
  void _navigateToDetailAndFocusSearch(String branchId) {
    Navigator.pushNamed(
      context,
      AppConstants.branchDetailRoute,
      arguments: branchId,
    ).then((_) {
      FocusScope.of(context).requestFocus(_tempFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildBranchList()),
        ],
      ),
    );
  }

  /// Builds the custom AppBar with location selector and notification icon
  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: background,
      elevation: 0,
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        child: Container(
          margin: EdgeInsets.only(left: 14.w, top: 5, bottom: 5),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.sort, color: gradientOne),
        ),
      ),
      title: BlocBuilder<BranchBloc, BranchState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (state is BranchLoaded && state.branches.isNotEmpty) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: MapScreen(branches: state.branches),
                        ),
                      );
                    }
                  },
                  child: const LocationSelector(),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppConstants.notificationsRoute);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: cardBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.notifications_none_rounded, color: gradientOne),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the search bar at the top
  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
      child: SearchFilterBar(focusnode: _searchFocusNode),
    );
  }

  /// Builds the branch list using BlocBuilder
  Widget _buildBranchList() {
    return BlocBuilder<BranchBloc, BranchState>(
      builder: (context, state) {
        if (state is BranchInitial || state is BranchLoading) {
          return Center(child: DotLoader(color: primaryColor, size: 30));
        } else if (state is BranchError) {
          return Center(child: Text(state.message));
        } else if (state is BranchLoaded) {
          if (state.branches.isEmpty) {
            return const Center(child: Text("No branches available"));
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: state.branches.length,
            itemBuilder: (context, index) =>
                _buildBranchCard(state.branches[index], index),
          );
        }
        return const SizedBox();
      },
    );
  }

  /// Builds a single branch card with image, details, rating, and offer
  Widget _buildBranchCard(Branch branch, int index) {
    final imageUrl =
        (branch.imageUrls != null && branch.imageUrls!.isNotEmpty)
            ? branch.imageUrls!.first
            : null;

    return GestureDetector(
      onTap: () => _navigateToDetailAndFocusSearch(branch.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl ?? '',
                    width: 88.w,
                    height: 110.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBranchTitleAndFav(branch, index),
                      SizedBox(height: 4.h),
                      if (branch.address != null && branch.address!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                branch.address!,
                                style: AppTextStyles.cardSubText,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (branch.city != null && branch.city!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            branch.description!,
                            style: AppTextStyles.cardSubText,
                          ),
                        ),
                      SizedBox(height: 6.h),
                      _buildRatingAndDistance(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _buildOfferSection(index),
          ],
        ),
      ),
    );
  }

  /// Builds the branch title and favorite icon
  Widget _buildBranchTitleAndFav(Branch branch, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            branch.name ?? '',
            style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(index % 2 == 0 ? Icons.favorite : Icons.favorite_outline, color: chipSelected),
      ],
    );
  }

  /// Builds rating and distance row for branch
  Widget _buildRatingAndDistance() {
    return Row(
      children: [
        Image.asset(AppImage.star, width: 14.w, height: 14.h),
        SizedBox(width: 4.w),
        Text('4.5', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(width: 12.w),
        Image.asset(AppImage.roundLocationIconColor, width: 14.w, height: 14.h),
        SizedBox(width: 4.w),
        Text('3.5 km', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }

  /// Builds the offer section for branch
  Widget _buildOfferSection(int index) {
    final offers = [
      'Unlock Productivity – Get Flat 10% Off Today!',
      'Work Better, Pay Less – Flat 10% Off',
      'Your Desk Awaits – Flat 50% Off',
      'Co-Work & Save – 10% Off Now',
      'Book Your Spot – Flat 10% Off',
    ];
    final offerText = offers[index % offers.length];

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Image.asset(AppImage.offer, width: 14.w, height: 14.h),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              offerText,
              style: AppTextStyles.offerText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
