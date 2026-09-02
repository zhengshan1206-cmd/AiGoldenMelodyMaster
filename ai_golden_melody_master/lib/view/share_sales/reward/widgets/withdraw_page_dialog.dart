import 'package:ai_golden_melody_master/view/share_sales/reward/widgets/withdraw_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

///提现明细页面
class WithdrawPageDialog extends StatefulWidget {
  const WithdrawPageDialog({super.key});

  @override
  State<WithdrawPageDialog> createState() => _WithdrawPageDialogState();
}

class _WithdrawPageDialogState extends State<WithdrawPageDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;

  List<Widget> tabBarPages = [
    WithdrawSuccessListView(),
    WithdrawNoSuccessListView(),
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
    return Container(
      width: 1.sw,
      height: 479.w,
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 16.w,
      ),
      decoration: BoxDecoration(
          color: Color(0XFF2E2E2E),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.w),
            topLeft: Radius.circular(12.w),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "提现明细",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Spacer(),
              InkResponse(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/home/share_sales/close_icon.png",
                    width: 16.w,
                    height: 16.w,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          Row(
            children: [
              InkResponse(
                onTap: (){
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
                child:  Column(
                  children: [
                    Text(
                      "提现已到账",
                      style: TextStyle(
                        color:currentTabIndex == 0? Colors.white:Colors.white.withOpacity(0.5),
                        fontSize: 14.sp,
                        fontWeight:currentTabIndex == 0? FontWeight.w500:FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Container(
                      width: 70.w,
                      height: 2.w,
                      color: currentTabIndex == 0?const Color(0XFF00CB64): Colors.white.withOpacity(0.1),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "提现",
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Container(
                    width: 35.w,
                    height: 2.w,
                    color:  Colors.white.withOpacity(0.1),
                  )
                ],
              ),
            InkResponse(
              onTap: (){
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
              child:   Column(
                children: [
                  Text(
                    "提现待到账",
                    style: TextStyle(
                      color:currentTabIndex == 1? Colors.white:Colors.white.withOpacity(0.5),
                      fontSize: 14.sp,
                      fontWeight:currentTabIndex == 1? FontWeight.w500:FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Container(
                    width: 70.w,
                    height: 2.w,
                    color: currentTabIndex == 1?const Color(0XFF00CB64):  Colors.white.withOpacity(0.1),

                  )
                ],
              ),
            ),
              Column(
                children: [
                  Text(
                    "提现待到账",
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Container(
                    width: 172.w,
                    height: 2.w,
                    color: Colors.white.withOpacity(0.1),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 12.w,),
          ///提现的listview 数据页面
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: tabBarPages,
            ),
          )
        ],
      ),
    );
  }
}
