import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'friend_invite_code_troller.dart';

///好友邀请码填写页面
class FriendInviteCodePage extends StatefulWidget {
  const FriendInviteCodePage({super.key});

  @override
  State<FriendInviteCodePage> createState() => _FriendInviteCodePageState();
}

class _FriendInviteCodePageState extends State<FriendInviteCodePage> {
  late StreamSubscription<bool> keyboardSubscription;
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  @override
  void initState() {
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      Get.find<FriendInviteCodeController>()
          .updateContainerHeight(keyboard: visible);
      Get.log('Keyboard visibility update. Is visible: $visible');
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  Widget _buildInfo({
    required FriendInviteCodeController controller,
  }) {
    if (controller.boundInviteCode.isNotEmpty) {
      return Container(
        width: 1.sw,
        height: 188.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.only(top: 0.w),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset("assets/home/share_sales/invite_code_bg1.png",width: 1.sw,height: 56.w,),
                Positioned(
                  top: 18.w,
                  left: 110.w,
                  child:   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/home/share_sales/black_star.png",
                              width: 11.w,
                              height: 11.w,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              "您已绑定邀请码",
                              style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0XFF121212)),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Image.asset(
                              "assets/home/share_sales/black_star.png",
                              width: 11.w,
                              height: 11.w,
                            ),
                          ],
                        ),
                        Positioned(
                            top: 21.w,
                            left: 53.w,
                            child: Image.asset(
                              "assets/home/share_sales/undeline_icon.png",
                              width: 52.w,
                              height: 4.w,
                              fit: BoxFit.fitWidth,
                            ))
                      ],
                    )
                  ],
                ),)
              ],
            ),
            SizedBox(
              height: 8.w,
            ),

            ///邀请码输入位置
            Opacity(
              opacity: 1,
              child: Container(
                  width: 1.sw,
                  height: 44.w,
                  decoration: BoxDecoration(
                      color: const Color(0XFF000000).withOpacity(0.02),
                      border: Border.all(
                        color: const Color(0XFF000000).withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(8.w)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 12.w, bottom: 7.w),
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.w, right: 12.w),
                        child: Image.asset(
                          "assets/home/share_sales/qr_code_2.png",
                          width: 18.w,
                          height: 18.w,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.w),
                        child: Text(
                          controller.boundInviteCode,
                          style: TextStyle(
                            color: const Color(0XFF000000).withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 8.w),
                        child: Image.asset(
                          "assets/home/share_sales/bind_success.png",
                          width: 14.w,
                          height: 14.w,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                    ],
                  )),
            ),
            const Spacer(),
            Text(
              "您也可以去首页邀请好友哦～",
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(
              height: 34.w,
            )
          ],
        ),
      );
    }
    return Container(
      width: 1.sw,
      height: 269.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.only(top: 0.w),
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset("assets/home/share_sales/invite_code_bg1.png",width: 1.sw,height: 56.w,),
              Positioned(
                top: 18.w,
                left: 110.w,
                child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/home/share_sales/black_star.png",
                            width: 11.w,
                            height: 11.w,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "你的邀请码",
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0XFF121212)),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Image.asset(
                            "assets/home/share_sales/black_star.png",
                            width: 11.w,
                            height: 11.w,
                          ),
                        ],
                      ),
                      Positioned(
                          top: 18.w,
                          left: 53.w,
                          child: Image.asset(
                            "assets/home/share_sales/undeline_icon.png",
                            width: 52.w,
                            height: 4.w,
                            fit: BoxFit.fitWidth,
                          ))
                    ],
                  )
                ],
              ),)
            ],
          ),
          SizedBox(
            height: 8.w,
          ),

          ///邀请码输入位置
          Opacity(
            opacity: 1,
            child: Container(
                width: 1.sw,
                height: 44.w,
                decoration: BoxDecoration(
                    color: const Color(0XFF000000).withOpacity(0.02),
                    border: Border.all(
                      color: const Color(0XFF000000).withOpacity(0.05),
                    ),
                    borderRadius: BorderRadius.circular(8.w)),
                margin: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.w, right: 10.w,left: 12.w),
                      child: Image.asset(
                        "assets/home/share_sales/qr_code_2.png",
                        width: 18.w,
                        height: 18.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.w),
                      child: SizedBox(
                        // height: 30.w,
                        width: 1.sw - 100.w,
                        child: TextField(
                          cursorColor: const Color(0XFF98FC4A),
                          focusNode: controller.focusNode,
                          // keyboardType: TextInputType.number,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: '请输入邀请码',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors.black12,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          onChanged: (value) {
                            Get.log('输入的邀请码: $value');
                          },
                          controller: controller.textEditingController,
                        ),
                      ),
                    )
                  ],
                )),
          ),

          ///确认按钮区域
          Opacity(
            opacity: controller.inviteCode.isNotEmpty ? 1 : 0.3,
            // opacity: 1,
            child: InkResponse(
              onTap: () {
                controller.confirmInviteCode();
              },
              child: Container(
                width: 1.sw,
                height: 44.w,
                margin: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 16.w,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF24FECF),
                      Color(0xFFFFF13C),
                    ],
                    stops: [0.38, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "确认",
                    style: TextStyle(
                      color: Color(0XFF162408),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            "注册3天内输入邀请码才有效哦～",
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(
            height: 51.w,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0XFFC592FF),
        child: InkResponse(
          onTap: () {
            Get.find<FriendInviteCodeController>().unFocusRealNameFocusNode();
          },
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: GetBuilder<FriendInviteCodeController>(
              builder: (controller) {
                return ListView(
                  /// 禁止滑动
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 1.sh,
                          child: Column(
                            children: [
                              controller.inviteBgUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: controller.inviteBgUrl,
                                      width: 1.sw,
                                      height: 594.w,
                                      // fit: BoxFit.fill,
                                      fit: BoxFit.fitHeight,
                                      placeholder: (context, url) {
                                        return Image.asset(
                                          "assets/home/share_sales/invite_code_bg.png",
                                          width: 1.sw,
                                          height: 590.w,
                                          // fit: BoxFit.fill,
                                          fit: BoxFit.fitHeight,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      "assets/home/share_sales/invite_code_bg.png",
                                      width: 1.sw,
                                      height: 590.w,
                                      fit: BoxFit.fitHeight,
                                    ),
                              Expanded(
                                  child: Container(
                                width: 1.sw,
                                decoration:
                                    BoxDecoration(color: Color(0XFFBBFA77)),
                              ))
                            ],
                          ),
                        ),

                        Positioned(
                          bottom: controller.height,
                          left: 12.w,
                          right: 12.w,
                          child: _buildInfo(controller: controller),
                        ),

                        ///导航返回
                        Positioned(
                          top: 44.w,
                          left: 12.w,
                          child: InkResponse(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: 56.w,
                              height: 30.w,
                              color: Colors.transparent,
                              padding: EdgeInsets.only(
                                  left: 7.w, right: 7.w, top: 7.w),
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                "assets/home/share_sales/go_back.png",
                                width: 16.w,
                                height: 16.w,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
