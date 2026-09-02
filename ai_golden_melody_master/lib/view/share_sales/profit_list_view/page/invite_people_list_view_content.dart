import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../bean/invite_people_list.dart';
import '../../share_sales_controller.dart';

class InvitePeopleListViewContent extends StatefulWidget {
  const InvitePeopleListViewContent({super.key});

  @override
  State<InvitePeopleListViewContent> createState() =>
      _InvitePeopleListViewContentState();
}

class _InvitePeopleListViewContentState
    extends State<InvitePeopleListViewContent>
    with AutomaticKeepAliveClientMixin {
  Widget _itemView({
    required UserItem item,
  }) {
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
                        // if( item.vipLevel!=0)
                        //   Text(
                        //     "充值“${item.vipLevelText}”奖励",
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 14.sp,
                        //     ),
                        //   ),
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
                item.vipLevel == 0
                    ? Text(
                        "未购买会员",
                        style: TextStyle(
                          color: const Color(0XFFFE5024),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
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
    super.build(context);
    return Container(
      height: 1.sh,
      decoration: BoxDecoration(
        color: const Color(0XFF1E1E1E),
        borderRadius: BorderRadius.circular(10.w),
      ),
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 15.w,
        bottom: 12.w,
      ),
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 15.w,
        bottom: 12.w,
      ),
      child: GetBuilder<ShareSalesController>(
        builder: (controller) {
          return EasyRefresh(
              onRefresh: () {
                controller.refreshInviteUserList();
              },
              onLoad: () {
                controller.loadInviteUserList();
              },
              child: controller.inviteUserList.isEmpty
                  ? ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: 100.w,
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
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.inviteUserList.length,
                      itemBuilder: (context, index) {
                        return _itemView(
                          item: controller.inviteUserList[index],
                        );
                      }));
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
