import 'dart:developer';

import 'package:ass_app/constants/ColorConstants.dart';
import 'package:ass_app/screens/ChatScreen.dart';
import 'package:ass_app/screens/Shoppingscreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.AppMainBgTheme,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Altibbe Assignment',
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Choose your destination',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 8.h),
              
              // Navigation Boxes
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildNavigationBox(
              //         context: context,
              //         title: 'Chat',
              //         subtitle: 'Start Conversation',
              //         icon: Icons.chat_bubble_outline,
              //         gradient: AppColors.chatGradient,
              //         onTap: () {
              //           // Navigate to chat screen
              //           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
              //           print('Navigate to Chat Screen');
              //         },
              //       ),
              //     ),
              //     SizedBox(width: 4.w),
              //     Expanded(
              //       child: _buildNavigationBox(
              //         context: context,
              //         title: 'Shop',
              //         subtitle: 'Browse Products',
              //         icon: Icons.shopping_bag_outlined,
              //         gradient: AppColors.shopGradient,
              //         onTap: () {
              //           // Navigate to shopping screen
              //           // Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingScreen()));
              //           print('Navigate to Shopping Screen');
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              
              // SizedBox(height: 4.h),
              
              // // Alternative: Vertical layout option (commented out)
              // /*
              _buildNavigationBox(
                context: context,
                title: 'Chat',
                subtitle: 'Start a conversation with AI',
                icon: Icons.chat_bubble_outline,
                gradient: AppColors.chatGradient,
                isHorizontal: true,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                  log('Navigate to Chat Screen');
                },
              ),
              SizedBox(height: 3.h),
              _buildNavigationBox(
                context: context,
                title: 'Shop',
                subtitle: 'Browse and buy products',
                icon: Icons.shopping_bag_outlined,
                gradient: AppColors.shopGradient,
                isHorizontal: true,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingScreen()));
                  log('Navigate to Shop Screen');
                },
              ),
              // */
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBox({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool isHorizontal = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isHorizontal ? 12.h : 28.h,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: isHorizontal
                  ? Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            icon,
                            size: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.8),
                          size: 16.sp,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            icon,
                            size: 32.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
