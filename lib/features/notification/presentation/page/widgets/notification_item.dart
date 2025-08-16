// import 'package:flutter/material.dart';
// import 'package:innerspace_booking_app/core/utils/responsive.dart';
// import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';
// import 'package:intl/intl.dart';


// class NotificationItem extends StatelessWidget {
//   final NotificationEntity notification;

//   const NotificationItem({super.key, required this.notification});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)),
//         leading: CircleAvatar(
//           backgroundColor: notification.isRead
//               ? Colors.grey[300]
//               : Theme.of(context).primaryColor,
//           child: Icon(
//             Icons.notifications,
//             color: notification.isRead ? Colors.grey : Colors.white,
//           ),
//         ),
//         title: Text(
//           notification.title,
//           style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                 fontWeight:
//                     notification.isRead ? FontWeight.normal : FontWeight.bold,
//               ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(notification.body),
//             SizedBox(height: ScreenUtil.setHeight(4)),
//             Text(
//               DateFormat.yMMMMd().add_jm().format(notification.timestamp),
//               //style: Theme.of(context).textTheme.caption,
//             ),
//           ],
//         ),
//         onTap: () {
//           // Mark as read and navigate if needed
//         },
//       ),
//     );
//   }
// }