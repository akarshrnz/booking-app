// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:innerspace_booking_app/core/app_constants.dart';
// import 'package:innerspace_booking_app/core/app_image.dart';
// import 'package:innerspace_booking_app/core/app_text_styles.dart';
// import 'package:innerspace_booking_app/core/color_constant.dart';
// import 'package:innerspace_booking_app/features/branch/presentation/bloc/branch_bloc.dart';
// import 'package:innerspace_booking_app/features/branch/presentation/pages/widgets/loaction_selector.dart';
// import 'package:innerspace_booking_app/features/branch/presentation/pages/widgets/search_filter_bar.dart';
// import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_bloc.dart';
// import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_event.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? _selectedCity;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BranchBloc>().add(GetAllBranches());
//       initNotification();
//       requestNotificationPermission();
//     });
//   }

//   void initNotification() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       context.read<NotificationBloc>().add(StartListeningNotifications(user.uid));
//     }
//   }

//   Future<void> requestNotificationPermission() async {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//   }

  // void _filterByCity(String? city) {
  //   setState(() {
  //     _selectedCity = city;
  //   });
  //   // You might want to add logic here to filter branches by city
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           _buildSearchField(),
//           _buildCityFilter(),
//           SizedBox(height: 8.h),
//           Expanded(child: _buildBranchList()),
//         ],
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: background,
//       elevation: 0,
//       titleSpacing: 0,
//       title: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Row(
//           children: [
//             const LocationSelector(),
//             const Spacer(),
//             Container(
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.r),
//                 color: cardBackground,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Icon(Icons.notifications_none_rounded, color: chipSelected),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       child: const SearchFilterBar(),
//     );
//   }

//   Widget _buildCityFilter() {
//     final cities = ['Chennai', 'Bangalore', 'Mumbai', 'Kochi'];
    
//     return SizedBox(
//       height: 50.h,
//       child: ListView.separated(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         scrollDirection: Axis.horizontal,
//         itemCount: cities.length,
//         separatorBuilder: (_, __) => SizedBox(width: 8.w),
//         itemBuilder: (context, index) {
//           final city = cities[index];
//           return FilterChip(
//             label: Text(city),
//             selected: _selectedCity == city,
//             onSelected: (selected) => _filterByCity(selected ? city : null),
//             selectedColor: chipSelected.withOpacity(0.2),
//             backgroundColor: Colors.white,
//             labelStyle: TextStyle(
//               color: _selectedCity == city ? chipSelected : Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.r),
//               side: BorderSide(
//                 color: _selectedCity == city ? chipSelected : Colors.grey.shade300,
//               ),
//             ),
//             showCheckmark: false,
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBranchList() {
//     return BlocBuilder<BranchBloc, BranchState>(
//       builder: (context, state) {
//         if (state is BranchInitial || state is BranchLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is BranchError) {
//           return Center(child: Text(state.message));
//         } else if (state is BranchLoaded) {
//           // Filter branches by selected city if any
//           final branches = _selectedCity != null
//               ? state.branches.where((branch) => branch.city == _selectedCity).toList()
//               : state.branches;

//           if (branches.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 48.w, color: Colors.grey),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "No branches available",
//                     style: AppTextStyles.cardTitle.copyWith(color: Colors.grey),
//                   ),
//                   if (_selectedCity != null) ...[
//                     SizedBox(height: 8.h),
//                     Text(
//                       "Try a different city filter",
//                       style: AppTextStyles.cardSubText,
//                     ),
//                   ],
//                 ],
//               ),
//             );
//           }
//           return ListView.builder(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             itemCount: branches.length,
//             itemBuilder: (context, index) => _buildBranchCard(branches[index]),
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   Widget _buildBranchCard(dynamic branch) {
//     final imageUrl = (branch.imageUrls != null && branch.imageUrls!.isNotEmpty)
//         ? branch.imageUrls!.first
//         : null;

//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(context, AppConstants.branchDetailRoute, arguments: branch.id);
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16.h),
//         decoration: BoxDecoration(
//           color: cardBackground,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16.r),
//                     topRight: Radius.circular(16.r),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl ?? '',
//                     width: double.infinity,
//                     height: 180.h,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Container(
//                       color: Colors.grey[200],
//                       height: 180.h,
//                       child: const Center(child: Icon(Icons.image, color: Colors.grey)),
//                     ),
//                     errorWidget: (context, url, error) => Container(
//                       color: Colors.grey[200],
//                       height: 180.h,
//                       child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 12.w,
//                   right: 12.w,
//                   child: Container(
//                     padding: EdgeInsets.all(6.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.favorite, color: chipSelected, size: 20),
//                   ),
//                 ),
//                 if ((branch.amenities ?? []).contains("Offer"))
//                   Positioned(
//                     bottom: 12.w,
//                     left: 12.w,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade600,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.local_offer, color: Colors.white, size: 14.w),
//                           SizedBox(width: 4.w),
//                           Text(
//                             '10% OFF',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     branch.name ?? '',
//                     style: AppTextStyles.cardTitle.copyWith(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18.sp,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on_outlined, size: 16.w, color: Colors.grey),
//                       SizedBox(width: 4.w),
//                       Expanded(
//                         child: Text(
//                           branch.location ?? '',
//                           style: AppTextStyles.cardSubText,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.star, size: 14.w, color: ratingStar),
//                             SizedBox(width: 4.w),
//                             Text(
//                               '4.5',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.green.shade800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.directions, size: 14.w, color: Colors.blue.shade600),
//                             SizedBox(width: 4.w),
//                             Text(
//                               '3.5 km',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         branch.city ?? '',
//                         style: AppTextStyles.cardSubText.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:innerspace_booking_app/core/app_constants.dart';
// import 'package:innerspace_booking_app/core/app_image.dart';
// import 'package:innerspace_booking_app/core/app_text_styles.dart';
// import 'package:innerspace_booking_app/core/color_constant.dart';
// import 'package:innerspace_booking_app/features/branch/presentation/bloc/branch_bloc.dart';
// import 'package:innerspace_booking_app/features/branch/presentation/pages/widgets/loaction_selector.dart';
// import 'package:innerspace_booking_app/features/branch/presentation/pages/widgets/search_filter_bar.dart';
// import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_bloc.dart';
// import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_event.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? _selectedCity;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BranchBloc>().add(GetAllBranches());
//       initNotification();
//       requestNotificationPermission();
//     });
//   }

//   void initNotification() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       context.read<NotificationBloc>().add(StartListeningNotifications(user.uid));
//     }
//   }

//   Future<void> requestNotificationPermission() async {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//   }

//   void _filterByCity(String? city) {
//     setState(() {
//       _selectedCity = city;
//     });
//     // You might want to add logic here to filter branches by city
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           _buildSearchField(),
//           _buildCityFilter(),
//           SizedBox(height: 8.h),
//           Expanded(child: _buildBranchList()),
//         ],
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: background,
//       elevation: 0,
//       titleSpacing: 0,
//       title: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Row(
//           children: [
//             const LocationSelector(),
//             const Spacer(),
//             Container(
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.r),
//                 color: cardBackground,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Icon(Icons.notifications_none_rounded, color: chipSelected),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       child: const SearchFilterBar(),
//     );
//   }

//   Widget _buildCityFilter() {
//     final cities = ['Chennai', 'Bangalore', 'Mumbai', 'Kochi'];
    
//     return SizedBox(
//       height: 50.h,
//       child: ListView.separated(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         scrollDirection: Axis.horizontal,
//         itemCount: cities.length,
//         separatorBuilder: (_, __) => SizedBox(width: 8.w),
//         itemBuilder: (context, index) {
//           final city = cities[index];
//           return FilterChip(
//             label: Text(city),
//             selected: _selectedCity == city,
//             onSelected: (selected) => _filterByCity(selected ? city : null),
//             selectedColor: chipSelected.withOpacity(0.2),
//             backgroundColor: Colors.white,
//             labelStyle: TextStyle(
//               color: _selectedCity == city ? chipSelected : Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.r),
//               side: BorderSide(
//                 color: _selectedCity == city ? chipSelected : Colors.grey.shade300,
//               ),
//             ),
//             showCheckmark: false,
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBranchList() {
//     return BlocBuilder<BranchBloc, BranchState>(
//       builder: (context, state) {
//         if (state is BranchInitial || state is BranchLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is BranchError) {
//           return Center(child: Text(state.message));
//         } else if (state is BranchLoaded) {
//           // Filter branches by selected city if any
//           final branches = _selectedCity != null
//               ? state.branches.where((branch) => branch.city == _selectedCity).toList()
//               : state.branches;

//           if (branches.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 48.w, color: Colors.grey),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "No branches available",
//                     style: AppTextStyles.cardTitle.copyWith(color: Colors.grey),
//                   ),
//                   if (_selectedCity != null) ...[
//                     SizedBox(height: 8.h),
//                     Text(
//                       "Try a different city filter",
//                       style: AppTextStyles.cardSubText,
//                     ),
//                   ],
//                 ],
//               ),
//             );
//           }
//           return ListView.builder(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             itemCount: branches.length,
//             itemBuilder: (context, index) => _buildBranchCard(branches[index]),
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   Widget _buildBranchCard(dynamic branch) {
//     final imageUrl = (branch.imageUrls != null && branch.imageUrls!.isNotEmpty)
//         ? branch.imageUrls!.first
//         : null;

//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(context, AppConstants.branchDetailRoute, arguments: branch.id);
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16.h),
//         decoration: BoxDecoration(
//           color: cardBackground,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16.r),
//                     topRight: Radius.circular(16.r),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl ?? '',
//                     width: double.infinity,
//                     height: 180.h,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Container(
//                       color: Colors.grey[200],
//                       height: 180.h,
//                       child: const Center(child: Icon(Icons.image, color: Colors.grey)),
//                     ),
//                     errorWidget: (context, url, error) => Container(
//                       color: Colors.grey[200],
//                       height: 180.h,
//                       child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 12.w,
//                   right: 12.w,
//                   child: Container(
//                     padding: EdgeInsets.all(6.w),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.favorite, color: chipSelected, size: 20),
//                   ),
//                 ),
//                 if ((branch.amenities ?? []).contains("Offer"))
//                   Positioned(
//                     bottom: 12.w,
//                     left: 12.w,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade600,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.local_offer, color: Colors.white, size: 14.w),
//                           SizedBox(width: 4.w),
//                           Text(
//                             '10% OFF',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     branch.name ?? '',
//                     style: AppTextStyles.cardTitle.copyWith(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18.sp,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on_outlined, size: 16.w, color: Colors.grey),
//                       SizedBox(width: 4.w),
//                       Expanded(
//                         child: Text(
//                           branch.location ?? '',
//                           style: AppTextStyles.cardSubText,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.star, size: 14.w, color: ratingStar),
//                             SizedBox(width: 4.w),
//                             Text(
//                               '4.5',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.green.shade800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.directions, size: 14.w, color: Colors.blue.shade600),
//                             SizedBox(width: 4.w),
//                             Text(
//                               '3.5 km',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         branch.city ?? '',
//                         style: AppTextStyles.cardSubText.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }