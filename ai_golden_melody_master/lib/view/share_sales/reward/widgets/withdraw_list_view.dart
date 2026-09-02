import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../bean/withdraw_details_model.dart';
import '../reward_controller.dart';

class WithdrawSuccessListView extends StatefulWidget {
  const WithdrawSuccessListView({super.key});

  @override
  State<WithdrawSuccessListView> createState() =>
      _WithdrawSuccessListViewState();
}

class _WithdrawSuccessListViewState extends State<WithdrawSuccessListView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
        height: 336.w,
        child: GetBuilder<RewardController>(
          builder: (controller) {
            return EasyRefresh(
              onRefresh: () {
                controller.refreshCompletedWithdraw();
              },
              onLoad: () {
                controller.loadMoreCompletedWithdraw();
              },
              child: controller.completedList.isEmpty
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
                      itemCount: controller.completedList.length,
                      itemBuilder: (context, index) {
                        return WithdrawItemView(
                          item: controller.completedList[index],
                        );
                      }),
            );
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class WithdrawNoSuccessListView extends StatefulWidget {
  const WithdrawNoSuccessListView({super.key});

  @override
  State<WithdrawNoSuccessListView> createState() =>
      _WithdrawNoSuccessListViewState();
}

class _WithdrawNoSuccessListViewState extends State<WithdrawNoSuccessListView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
        height: 336.w,
        child: GetBuilder<RewardController>(
          builder: (controller) {
            return EasyRefresh(
              onRefresh: () {
                controller.refreshUnCompletedWithdraw();
              },
              onLoad: () {
                controller.loadMoreUnCompletedWithdraw();
              },
              child: controller.uncompletedList.isEmpty
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
                      itemCount: controller.uncompletedList.length,
                      itemBuilder: (context, index) {
                        return WithdrawItemView(
                          item: controller.uncompletedList[index],
                        );
                      }),
            );
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class WithdrawItemView extends StatelessWidget {
  final WithdrawDetailsItem item;
  const WithdrawItemView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 1.sw,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.w),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "提现金额: ${item.amount}元",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    "${item.createdAt}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.type == 1 ? "支付宝" : "微信",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
