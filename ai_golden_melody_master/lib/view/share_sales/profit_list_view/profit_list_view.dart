
import 'package:ai_golden_melody_master/view/share_sales/profit_list_view/page/invite_people_list_view_content.dart';
import 'package:ai_golden_melody_master/view/share_sales/profit_list_view/page/profit_list_view_content.dart';
import 'package:ai_golden_melody_master/view/share_sales/profit_list_view/profit_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../page/page.dart';

///利益明细的滚动列表
class ProfitListView extends StatefulWidget {
  const ProfitListView({super.key});

  @override
  State<ProfitListView> createState() => _ProfitListViewState();
}

class _ProfitListViewState extends State<ProfitListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;

  List<Widget> tabBarPages = [
    ProfitListViewContent(),
    InvitePeopleListViewContent(),
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
      child: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(color: Color(0XFF000000)),
        child: GetBuilder<ProfitListController>(
          builder: (controller) {
            return Column(
              children: [
                SizedBox(
                  height: 56.w,
                ),

                Stack(
                  children: [
                    
                    Row(
                      children: [
                        SizedBox(width: 96.w,),
                        if(currentTabIndex==0)
                        Container(
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
                        ),
                        SizedBox(width:currentTabIndex==0? 70.w:82.w,),
                        if(currentTabIndex==1)
                          Container(
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
                        ),
                      ],
                    ),
                    
                    Positioned(child:   Row(
                      children: [
                        SizedBox(
                          width: 12.w,
                        ),
                        InkResponse(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Image.asset(
                                "assets/home/share_sales/go_back.png",
                                width: 16.w,
                                height: 16.w,
                              ),
                            )),
                        SizedBox(
                          width: 57.w,
                        ),
                        ProfitTabItemView(
                          text: "收益明细",
                          isSelected: currentTabIndex == 0 ? true : false,
                          onClick: () {
                            if (currentTabIndex == 0) {
                              return;
                            }
                            if (mounted) {
                              setState(() {
                                currentTabIndex = 0;
                              });
                            }
                            _tabController.animateTo(currentTabIndex);
                          },
                        ),
                        SizedBox(
                          width: 22.w,
                        ),
                        ProfitTabItemView(
                          text: "邀请人明细",
                          isSelected: currentTabIndex == 1 ? true : false,
                          onClick: () {
                            if (currentTabIndex == 1) {
                              return;
                            }
                            if (mounted) {
                              setState(() {
                                currentTabIndex = 1;
                              });
                            }
                            _tabController.animateTo(currentTabIndex);
                          },
                        ),
                      ],
                    ),)
                  ],
                ),

                ///无限列表区域

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: tabBarPages,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
