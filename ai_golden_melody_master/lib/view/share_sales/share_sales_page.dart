import 'dart:ui';

import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:ai_golden_melody_master/view/share_sales/page/page.dart';
import 'package:ai_golden_melody_master/view/share_sales/share_sales_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/lib/app_common/by_nav_router_utils.dart';
import '../../navigator/app_pages.dart';
import 'bean/invite_info.dart';

class ShareSalesPage extends StatefulWidget {
  const ShareSalesPage({super.key});

  @override
  State<ShareSalesPage> createState() => _ShareSalesPageState();
}

class _ShareSalesPageState extends State<ShareSalesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;
  Widget _itemView({
    String title1 = "",
    String title2 = "可提现(元)",
    int type = 0,
  }) {
    return Column(
      children: [
        Container(
          height: type == 0 ? 30.w : 29.w,
          // color: Colors.green,
          alignment: Alignment.bottomCenter,

          child: Text(
            title1,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          title2,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0XFFA0A0A7),
          ),
        )
      ],
    );
  }

  List<Widget> tabBarPages = [
    SalesPageProfitListViewContent(),
    SalesInvitePeopleListViewContent(),
  ];

  @override
  void initState() {
    _tabController = TabController(
        length: 2,
        vsync: this,
        animationDuration: const Duration(
          milliseconds: 500,
        ));
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0XFF0F0F12),
      child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: GetBuilder<ShareSalesController>(
            builder: (controller) {
              String? inviteCode;
              InviteInfoApiResponse? infoApiResponse =
                  controller.infoApiResponse;
              int invitePeople = 0;
              String cashNotes = "";
              if (infoApiResponse != null) {
                if (infoApiResponse.data != null) {
                  inviteCode = infoApiResponse.data!.inviteCode;
                  invitePeople = infoApiResponse.data!.inviteNumber ?? 0;
                  cashNotes = infoApiResponse.data!.cashNotes ?? "";
                }
              }
              return Stack(
                children: [
                  SizedBox(
                    width: 1.sw,
                    height: 1.sh,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ///分享赚钱上半部分
                        Stack(
                          children: [
                            Image.asset(
                              "assets/home/share_sales/sales_bg.png",
                              width: 1.sw,
                              height: 455.w,
                            ),
                            Positioned(
                                top: 169.w,
                                left: 38.w,
                                child: InkResponse(
                                  onTap: () {
                                    controller.copyCode(code: inviteCode ?? "");
                                  },
                                  child: Container(
                                    width: 300.0,
                                    height: 40.0,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromRGBO(
                                              95, 253, 253, 0), // 0%处的透明色
                                          Color(0xFF2AFFFF), // 50%处的主色
                                          Color.fromRGBO(
                                              95, 253, 253, 0), // 100%处的透明色
                                        ],
                                        stops: [0.0, 0.5, 1.0], // 颜色位置百分比
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          inviteCode ?? "",
                                          style: TextStyle(
                                              color: const Color(0XFF000000),
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          width: 74.0.w,
                                          height: 22.0.h,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(
                                                    0xFF732323), // #732323 0%处
                                                Color(
                                                    0xFF121212), // #121212 17%处
                                                Color(
                                                    0xFF121212), // #121212 81%处
                                                Color(
                                                    0xFF006783), // #006783 100%处
                                              ],
                                              stops: [0.0, 0.17, 0.81, 1.0],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0.w),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "复制邀请码",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            Positioned(
                              bottom: 27.w,
                              left: 28.w,
                              child: InkResponse(
                                onTap: () {
                                  controller.inviteFriendDialog();
                                },
                                // child: BtnBreathingAnimationWidget(
                                //   child: Image.asset(
                                //     "assets/home/share_sales/invite_btn.png",
                                //     width: 1.sw-46.w ,
                                //     height: 60.h,
                                //     fit: BoxFit.fitWidth,
                                //   ),
                                // )
                                child: Image.asset(
                                  "assets/home/share_sales/invite_btn.png",
                                  width: 1.sw - 46.w,
                                  height: 60.h,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),

                            ///提示语部分
                            Positioned(
                                top: 125.w,
                                left: 65.w,
                                child: Column(
                                  children: [
                                    Text(
                                      "每邀请一位创作者购买会员",
                                      style: TextStyle(
                                        color: const Color(0XFF121212)
                                            .withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "您可以获得TA支付金额的",
                                          style: TextStyle(
                                            color: const Color(0XFF121212)
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          "${controller.rewardNumber}%作为奖励",
                                          style: TextStyle(
                                            color: const Color(0XFFFF3F3F),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),

                        ///我的奖励部分
                        Column(
                          children: [
                            SizedBox(
                              height: 15.w,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                      "assets/home/share_sales/list_view_bg.png",
                                      width: 1.sw - 24.w,
                                      height: 44.w,
                                    ),
                                    Positioned(
                                      top: 13.w,
                                      left: 8.w,
                                      child:  Container(
                                      width: 12.w,
                                      height: 12.w,
                                      decoration:  BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color(0xFF6DFF38), // #6DFF38
                                            Color(
                                                0x00CCFF7D), // rgba(204,255,125,0) 完全透明
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.w)),
                                      ),
                                    ),)
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 1.sw,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 24.w,
                                        ),
                                        Text(
                                          "我的奖励",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        InkResponse(
                                          onTap: () {
                                            Get.toNamed(Routes.rewardPage,
                                                arguments: {
                                                  "canWithdrawCash": controller
                                                      .canWithdrawCash,
                                                  "cumulativeIncome": controller
                                                      .cumulativeIncome,
                                                  "pending": controller.pending,
                                                  "withdrawBalance": controller
                                                      .withdrawBalance,
                                                  "cashNotes": cashNotes,
                                                });
                                          },
                                          child: Container(
                                            width: 44.w,
                                            height: 44.w,
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child: Container(
                                              width: 30.w,
                                              height: 20.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  90.w,
                                                ),
                                              ),
                                              child: Image.asset(
                                                "assets/home/share_sales/icon_2.png",
                                                width: 14.w,
                                                height: 14.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 24.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 16.w,
                                left: 12.w,
                                right: 12.w,
                              ),
                              padding: EdgeInsets.only(bottom: 16.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10.w),
                                    bottomLeft: Radius.circular(10.w),
                                  ),
                                  color: const Color(0XFF1E1E1E)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Expanded(
                                    child: _itemView(
                                      title2: "可提现(元)",
                                      title1: controller.canWithdrawCash,
                                      // title1: "4750.00",
                                    ),
                                  ),
                                  Container(
                                    width: 1.0.w,
                                    height: 52.0.w,
                                    margin: EdgeInsets.only(
                                        left: 27.w, right: 19.w),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          width: 1.0, // 边框宽度
                                          color: Colors.transparent, // 透明色作为基础
                                        ),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(255, 255, 255, 0),
                                          Color.fromRGBO(255, 255, 255, 1),
                                          Color.fromRGBO(255, 255, 255, 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _itemView(
                                      title2: "累计收益(元)",
                                      title1: controller.cumulativeIncome,
                                      // title1: "5000.00",
                                    ),
                                  ),
                                  Container(
                                    width: 1.0.w,
                                    height: 52.0.w,
                                    margin: EdgeInsets.only(
                                        left: 21.w, right: 28.w),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          width: 1.0, // 边框宽度
                                          color: Colors.transparent, // 透明色作为基础
                                        ),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(255, 255, 255, 0),
                                          Color.fromRGBO(255, 255, 255, 1),
                                          Color.fromRGBO(255, 255, 255, 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _itemView(
                                        title2: "已邀请(人)",
                                        title1: invitePeople.toString(),
                                        // title1: "12",

                                        type: 1),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        ///收益部分
                        Container(
                          height: 0.6.sh,
                          width: 1.sw,
                          margin: EdgeInsets.only(
                            left: 12.w,
                            right: 12.w,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0XFF1E1E1E),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        "assets/home/share_sales/list_view_bg.png",
                                        width: 1.sw - 24.w,
                                        height: 44.w,
                                      ),
                                      if(currentTabIndex == 0)
                                      Positioned(
                                        top: 7.w,
                                        left: 8.w,
                                        child:  Container(
                                          width: 12.w,
                                          height: 12.w,
                                          decoration:  BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color(0xFF6DFF38), // #6DFF38
                                                Color(
                                                    0x00CCFF7D), // rgba(204,255,125,0) 完全透明
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.w)),
                                          ),
                                        ),),
                                      if(currentTabIndex == 1)
                                      Positioned(
                                        top: 7.w,
                                        left: 85.w,
                                        child:  Container(
                                          width: 12.w,
                                          height: 12.w,
                                          decoration:  BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color(0xFF6DFF38), // #6DFF38
                                                Color(
                                                    0x00CCFF7D), // rgba(204,255,125,0) 完全透明
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.w)),
                                          ),
                                        ),)
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 1.sw,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          ProfitTabItemView(
                                            text: "收益明细",
                                            isSelected: currentTabIndex == 0
                                                ? true
                                                : false,
                                            onClick: () {
                                              if (currentTabIndex == 0) {
                                                return;
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  currentTabIndex = 0;
                                                });
                                              }
                                              _tabController
                                                  .animateTo(currentTabIndex);
                                            },
                                          ),
                                          SizedBox(
                                            width: 16.w,
                                          ),
                                          ProfitTabItemView(
                                            text: "邀请人明细",
                                            isSelected: currentTabIndex == 1
                                                ? true
                                                : false,
                                            onClick: () {
                                              if (currentTabIndex == 1) {
                                                return;
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  currentTabIndex = 1;
                                                });
                                              }
                                              _tabController
                                                  .animateTo(currentTabIndex);
                                            },
                                          ),
                                          const Spacer(),
                                          InkResponse(
                                            onTap: () {
                                              Get.toNamed(Routes.profitPage);
                                            },
                                            child: Container(
                                              width: 44.w,
                                              height: 44.w,
                                              alignment: Alignment.center,
                                              color: Colors.transparent,
                                              child: Container(
                                                width: 30.w,
                                                height: 20.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.1)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    90.w,
                                                  ),
                                                ),
                                                child: Image.asset(
                                                  "assets/home/share_sales/icon_2.png",
                                                  width: 14.w,
                                                  height: 14.w,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 24.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              ///无限列表区域
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: tabBarPages,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  ///活动说明
                  Positioned(
                      left: 12.w,
                      right: 12.w,
                      top: 44.w,
                      child: SizedBox(
                        width: 1.sw,
                        child: Row(
                          children: [
                            // InkResponse(
                            //   onTap: () {
                            //     Get.back();
                            //   },
                            //   child: Container(
                            //     width: 30.w,
                            //     height: 30.w,
                            //     decoration: BoxDecoration(
                            //         color: const Color(0XFF1E1F24).withOpacity(0.2),
                            //         borderRadius: BorderRadius.circular(7.w)),
                            //     alignment: Alignment.center,
                            //     child: Image.asset(
                            //       "assets/home/share_sales/go_back.png",
                            //       width: 16.w,
                            //       height: 16.w,
                            //     ),
                            //   ),
                            // ),
                            const Spacer(),
                            ClipRRect(
                              child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: InkResponse(
                                    onTap: () {
                                      controller.showActivityNoticeDialog();

                                    },
                                    child: Container(
                                      width: 68.w,
                                      height: 28.w,
                                      decoration: BoxDecoration(
                                          color: const Color(0XFF000000)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(90.w)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "活动说明",
                                        style: TextStyle(
                                            color: ByColorUtil.color121212,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ))
                ],
              );
            },
          )),
    );
  }
}
