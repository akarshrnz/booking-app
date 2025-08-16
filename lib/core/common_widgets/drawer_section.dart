import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:innerspace_booking_app/features/auth/presentation/pages/login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          // Red Gradient Header
          Container(
            height: 280,
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [
                gradientOne,
                  gradientTwo,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(top: 45, left: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black, size: 15),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, right: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_3_outlined, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           "Akarsh kk",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                             "akars@gmail.com",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                          "+91 " + ( "9999991987"),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // White Card over Header
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  _drawerItem(Icons.person_outline, "Profile"),
    _drawerItem(Icons.meeting_room_outlined, "My Bookings",onTap: () {
          Navigator.pushNamed(
                  context,
                  AppConstants.myBookingsRoute,
               
                );
    },),
    _drawerItem(Icons.local_offer_outlined, "Offers & Discounts"),
         Divider(thickness: 0.8, color: primaryColor),

    _drawerItem(Icons.feedback_outlined, "Feedback & Ratings"),
    _drawerItem(Icons.person_add_alt_outlined, "Invite a Friend"),
    _drawerItem(Icons.chat_bubble_outline, "Support Chat"),
     Divider(thickness: 0.8, color: primaryColor),
    _drawerItem(Icons.info_outline, "About Us"),
    _drawerItem(Icons.policy_outlined, "Terms & Policies"),
        _drawerItem(Icons.settings_outlined, "Settings"),


                    
                   
                  ],
                ),
              ),
            ),
          ),

          // Logout Button
          Positioned(
            bottom: 20,
            left: 20,
            child: InkWell(
              onTap: () async {
                SharedPreferences pref =
                    await SharedPreferences.getInstance();
                await pref.clear();
               

                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: LoginScreen(),
                  ),
                );
              },
              child: Row(
                children:  [
                  Icon(Icons.logout, color: primaryColor),
                  SizedBox(width: 8),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String text,{void Function()? onTap}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: primaryColor),
      title: Text(text),
      onTap:onTap,
    );
  }
}
