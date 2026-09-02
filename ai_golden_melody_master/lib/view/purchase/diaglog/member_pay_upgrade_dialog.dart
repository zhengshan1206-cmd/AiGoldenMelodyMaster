import 'dart:io';

import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/upgrade_vip_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/scale_transition_widget.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_rights/member_pay_upgrade_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemberPayUpgradeDialog extends StatelessWidget {
  MemberPayUpgradeDialog({super.key});

  final controller = Get.find<MemberPayUpgradeController>();

  ///标题栏
  Widget _buildTitleBar() {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/vip/vip_header_icon4.png",
                    width: 16.w,
                    height: 16.w,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  if (controller.userInfoBean != null)
                    Text(
                      controller.userInfoBean!.nickName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (controller.userInfoBean != null)
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        "(${controller.userInfoBean!.userId})",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (controller.userInfoBean != null)
                    GestureDetector(
                      onTap: () {
                        controller.copyId();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: Image.asset(
                          Assets.vipCopyIcon,
                          width: 14.w,
                          height: 14.w,
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(
                width: 16.w,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  "assets/ai/ai_closed.png",
                  width: 16.w,
                  height: 16.w,
                ),
              )
            ],
          ),
          SizedBox(
            height: 17.w,
          ),
          Container(
            height: 44.w,
            padding: EdgeInsets.only(
              left: 16.w,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/vip/vip_message_icon4.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/vip/vip_id4.png",
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  controller.selectedVipTypeModel.userMessageText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 17.w,
          ),
        ],
      ),
    );
  }

  ///主体内容
  Widget _buildMainContent() {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVipRights(),
            _buildUpgradeList(),
            _payMethod(),
            _buildPurchaseNotice(),
          ],
        ),
      ),
    );
  }

  ///会员权益
  Widget _buildVipRights() {
    return GetBuilder<MemberPayUpgradeController>(
        builder: (controller) => SizedBox(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 26.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.w)),
                      border: Border.all(
                        width: 2.w,
                        color: Colors.white.withOpacity(0.05),
                      ),
                      // 添加微妙的背景渐变
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF2E2E2E).withOpacity(1),
                          const Color(0xFF383838).withOpacity(0.1),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(12.w), // 为内阴影留出空间
                      padding: EdgeInsets.only(top: 36.h, bottom: 0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.w)),
                        color: const Color(0xFF212121),
                        // 内层阴影效果
                        boxShadow: const [
                          // 顶部内阴影
                          BoxShadow(
                            color: Color(0xFF212121),
                            blurRadius: 6,
                            offset: Offset(0, -2),
                          ),
                          // 底部内阴影
                          BoxShadow(
                            color: Color(0xFF212121),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                          // 左侧内阴影
                          BoxShadow(
                            color: Color(0xFF212121),
                            blurRadius: 6,
                            offset: Offset(-2, 0),
                          ),
                          // 右侧内阴影
                          BoxShadow(
                            color: Color(0xFF212121),
                            blurRadius: 6,
                            offset: Offset(2, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 权益列表 - 两列布局
                          Wrap(
                            spacing: 4.w, // 子组件之间的间距
                            runSpacing: 12.0.w, // 行间距
                            alignment: WrapAlignment.spaceBetween, // 两端对齐
                            children: [
                              ...controller.getCurrentVipRights().map(
                                    (e) => SizedBox(
                                      width: 158.w, // 固定宽度，确保两列布局
                                      height: 50.w,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: e.icon,
                                                width: 44.w,
                                                height: 44.w,
                                              ),
                                              if (e.selected == 0)
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Image.asset(
                                                    Assets.closedIcon,
                                                    width: 16.w,
                                                    height: 16.w,
                                                  ),
                                                )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.name,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: e.selected == 0
                                                        ? Colors.white
                                                            .withOpacity(0.5)
                                                        : Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 4.w,
                                                ),
                                                Text(
                                                  e.desc,
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/vip/vip_upgrade_1.png",
                    height: 74.h,
                    fit: BoxFit.fitHeight,
                  ),
                ],
              ),
            ));
  }

  ///升级列表
  Widget _buildUpgradeList() {
    return GetBuilder<MemberPayUpgradeController>(
      builder: (controller) => SizedBox(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 15.w,
                bottom: 8.w,
              ),
              child: Text(
                "可升级类型",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            controller.vipRiseHappys.isNotEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: 132.h,
                    child: ListView.builder(
                      itemCount: controller.vipRiseHappys.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return _buildListItem(
                            controller.vipRiseHappys[index], index);
                      },
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 132.h,
                    child: Center(
                      child: Text(
                        "暂无可升级类型",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  ///列表项
  Widget _buildListItem(UpgradeVipBean vipRiseHappy, int index) {
    ///是否选中套餐
    bool isSelected = index == controller.selectedVipRiseHappyIndex;

    ///文字颜色
    Color textColor = vipRiseHappy.vipLevel <= 90
        ? const Color(0xFF9F3E02)
        : const Color(0xFF9F5602);

    ///选中背景图
    String bgImage = isSelected && vipRiseHappy.vipLevel <= 90
        ? "assets/vip/vip_upgrade_bg_2.png"
        : "assets/vip/vip_upgrade_bg_3.png";
    return GestureDetector(
      onTap: () {
        controller.switchVipRiseHappy(index);
      },
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 6.h),
              Container(
                width: 169.w,
                height: 126.h,
                margin: EdgeInsets.only(
                  right: 12.w,
                ),
                padding: EdgeInsets.only(
                  top: 20.w,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      isSelected ? bgImage : "assets/vip/vip_upgrade_bg_1.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 169.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.w)),
                            border: Border.all(
                              width: 1.w,
                              color: isSelected
                                  ? textColor.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Text(
                            vipRiseHappy.title,
                            style: TextStyle(
                              color: isSelected ? textColor : Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "￥",
                              style: TextStyle(
                                color: isSelected ? textColor : Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              vipRiseHappy.originalPackageMoney,
                              style: TextStyle(
                                color: isSelected ? textColor : Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "原价￥${vipRiseHappy.crossedMoney}",
                          style: TextStyle(
                            color: isSelected
                                ? textColor.withOpacity(0.6)
                                : Colors.white.withOpacity(0.5),
                            fontSize: 11.sp,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: 24.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12.w),
                            bottomLeft: Radius.circular(12.w),
                          ),
                          color: isSelected
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white.withOpacity(0.05),
                        ),
                        child: Text(
                          "≈${vipRiseHappy.dayMoney}元/首",
                          style: TextStyle(
                            color: isSelected ? textColor : Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (vipRiseHappy.isDefault == 1)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                height: 16.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.w),
                    bottomRight: Radius.circular(12.w),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6045),
                      Color(0xFFFF4221),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/vip/hot_fire_icon.png",
                      width: 10.w,
                      height: 10.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      vipRiseHappy.mark.isNotEmpty ? vipRiseHappy.mark : "最划算",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  ///支付方式
  Widget _payMethod() {
    return GetBuilder<MemberPayUpgradeController>(
      builder: (controller) {
        if (Platform.isAndroid) {
          ///这里微信 支付宝支付
          if (controller.payMethodBeans.isEmpty) {
            return const SizedBox();
          }
          return InkResponse(
            onTap: () {
              controller.switchPayMethod();
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.w),
              ),
              margin: EdgeInsets.only(top: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Image.asset(
                    controller.getCurrentPayMethodIcon(),
                    width: 18.w,
                    height: 18.w,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    controller.getCurrentPayMethodName(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    Assets.changePayIcon,
                    width: 18.w,
                    height: 18.w,
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  ///购买须知
  Widget _buildPurchaseNotice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        Text(
          "购买须知",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 8.h),
        Text(
          controller.purchaseNotice,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  ///底部按钮
  Widget _buildBottomButton() {
    if (controller.vipRiseHappys.isEmpty) {
      ///加载中
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF00CB64),
          strokeWidth: 2.w,
        ),
      );
    }
    final UpgradeVipBean vipRiseHappy =
        controller.vipRiseHappys[controller.selectedVipRiseHappyIndex];

    return Container(
      color: const Color(0xFF2E2E2E),
      padding: EdgeInsets.only(
        top: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkResponse(
            onTap: () {
              controller
                  .agreementCheckedStatusChanged(!controller.isReadAgreement);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      border: Border.all(
                          color: Colors.white.withOpacity(
                            0.5,
                          ),
                          width: 1.w)),
                  alignment: Alignment.center,
                  child: controller.isReadAgreement
                      ? Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.w)),
                        )
                      : null,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        "我已阅读并同意",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          Get.find<LaunchController>().openVip();
                        },
                        child: Text(
                          " 会员服务协议",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.w),
          GestureDetector(
            onTap: () {
              controller.upgradeVipTap();
            },
            child: ScaleTransitionWidget(
              child: Container(
                width: double.infinity,
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/vip/vip_upgrade_2.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "补差价",
                          style: TextStyle(
                            color: const Color(0xFF121212),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "￥${vipRiseHappy.money}",
                          style: TextStyle(
                            color: const Color(0xFF121212),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      vipRiseHappy.buttonTitle,
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 640.h,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 20.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0XFF2E2E2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.w),
          topRight: Radius.circular(12.w),
        ),
      ),
      child: GetBuilder<MemberPayUpgradeController>(
        builder: (controller) => Column(
          mainAxisSize: MainAxisSize.min, // 让Column根据内容自适应高度
          children: [
            _buildTitleBar(),
            _buildMainContent(),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }
}
