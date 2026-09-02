import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../bean/income_list_model.dart';
import '../bean/invite_people_list.dart';
import '../share_sales_controller.dart';

class ProfitTabItemView extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onClick;
  const ProfitTabItemView({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        onClick();
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0XFFA0A0A7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  fontSize: 15.sp,
                ),
              ),
              // if (isSelected)
              //   Positioned(
              //       right: -9.w,
              //       bottom: 9.w,
              //       child: Image.asset(
              //         "assets/home/share_sales/icon_1.png",
              //         width: 21.w,
              //         height: 21.w,
              //       ))
            ],
          ),
          SizedBox(
            height: 6.w,
          ),
          if (isSelected)
            Container(
              width: 32.w,
              height: 2.w,
              color: Colors.white,
            )
        ],
      ),
    );
  }
}

///赚钱页面的收益明细列表 前10条数据
class SalesPageProfitListViewContent extends StatelessWidget {
  const SalesPageProfitListViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        margin: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
        ),
        height: 0.5.sh,
        decoration: BoxDecoration(
            color: const Color(0XFF1E1E1E),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.w),
              bottomLeft: Radius.circular(10.w),
            )),
        // padding: EdgeInsets.all(12.w),
        child: GetBuilder<ShareSalesController>(builder: (controller) {
          List<RewardItem> incomeList = [];
          if (controller.incomeList.isNotEmpty) {
            incomeList.addAll(controller.incomeList);
          }
          if (incomeList.length > 10) {
            incomeList.sublist(0, 10);
          }
          if (incomeList.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: 10.w,
                ),
                Center(
                  child: Image.asset(
                    "assets/home/share_sales/small_no_data.png",
                    width: 90.w,
                    height: 90.w,
                  ),
                ),
                Center(
                  child: Text(
                    "暂无数据",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.3)),
                  ),
                )
              ],
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              ...incomeList.map((e) => ProfitItemView(
                    item: e,
                  ))
            ],
          );
        }));
  }
}

class ProfitItemView extends StatelessWidget {
  final RewardItem item;
  const ProfitItemView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 1.sw,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "“${item.phone}”",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        if(item.vipLevelText.isNotEmpty)
                          Text("充值“${item.vipLevelText}”奖励",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    Text(
                      item.createdAt,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                item.dataType == 1
                    ? Text(
                        "+${item.rewardNumber}",
                        style: TextStyle(
                          color: const Color(0XFF00CB64),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
                        "-${item.rewardNumber}",
                        style: TextStyle(
                          color: const Color(0XFFFE5024),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
              ],
            ),
            SizedBox(
              height: 12.w,
            ),
            Container(
              width: 1.sw,
              height: 1.w,
              color: Color(0XFF26272E),
            ),
            SizedBox(
              height: 12.w,
            ),
          ],
        ));
  }
}

///邀请人页面的收益明细列表 前10条数据
class SalesInvitePeopleListViewContent extends StatelessWidget {
  const SalesInvitePeopleListViewContent({super.key});

  Widget _itemView({required UserItem item,}) {

    Get.log("===vipLevelText=== ${item.vipLevelText}");
    return SizedBox(
        width: 1.sw - 24.w,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "“${item.phone}”",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        // if( item.vipLevel!=0)
                        // Text(
                        //   "充值“${item.vipLevelText}”奖励",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 14.sp,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    Text(
                      item.createdAt,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
               item.vipLevel==0? Text(
                  "未购买会员",
                  style: TextStyle(
                    color: const Color(0XFFFE5024),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ):Text(
                 item.vipLevelText,
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 14.sp,
                   fontWeight: FontWeight.w600,
                 ),
               )
              ],
            ),
            SizedBox(
              height: 12.w,
            ),
            Container(
              width: 1.sw,
              height: 1.w,
              color: Color(0XFF26272E),
            ),
            SizedBox(
              height: 12.w,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw - 24.w,
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
      ),
      height: 0.5.sh,
      decoration: BoxDecoration(
        color: const Color(0XFF1E1E1E),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.w),
          bottomLeft: Radius.circular(10.w),
        ),
      ),
      // padding: EdgeInsets.all(12.w),
      child: GetBuilder<ShareSalesController>(builder: (controller) {
        List<UserItem> inviteUserList = [];
        if (controller.inviteUserList.isNotEmpty) {
          inviteUserList.addAll(controller.inviteUserList);
        }
        if (inviteUserList.length > 10) {
          inviteUserList.sublist(0, 10);
        }
        if (inviteUserList.isEmpty) {
          return Column(
            children: [
              SizedBox(
                height: 10.w,
              ),
              Center(
                child: Image.asset(
                  "assets/home/share_sales/small_no_data.png",
                  width: 90.w,
                  height: 90.w,
                ),
              ),
              Center(
                child: Text(
                  "暂无数据",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.3)),
                ),
              )
            ],
          );
        }

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            ...inviteUserList.map((e) => _itemView(
                  item: e,
                ))
          ],
        );
      }),
    );
  }
}
