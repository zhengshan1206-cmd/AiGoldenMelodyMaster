import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_infinite_marquee/flutter_infinite_marquee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import '../../../model/purchase/vip_model.dart';
import '../../../model/purchase/vip_type_bean.dart';
import '../../../model/user/user_info_bean.dart';
import '../../../utils/data_service.dart';
import '../../lanuch_page/launch_controller.dart';
import '../diaglog/show_history_bottom_dialog.dart';

///vip 购买页面
class VipPurchasePage extends StatefulWidget {
  const VipPurchasePage({super.key});

  @override
  State<VipPurchasePage> createState() => _VipPurchasePageState();
}

class _VipPurchasePageState extends State<VipPurchasePage> {
  List<String> _items = [];

  ///是否要展示抄底弹窗
  bool showBottomPayDialog = false;

  String musicMoney = "";

  ///购买菜单
  Widget _purchaseItemView({
    required VipTypeBean vipTypeBean,
    required VipPurchaseController controller,
  }) {
    bool selected = false;
    if (controller.selectedVipTypeBean != null) {
      if (controller.selectedVipTypeBean!.id == vipTypeBean.id) {
        selected = true;
      }
    }
    return InkResponse(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: selected ? null : ByColorUtil.color000000.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
              gradient: selected ? _color1(vipTypeBean: vipTypeBean) : null,
            ),
            padding: EdgeInsets.only(top: 20.w),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: 19.w,
                    right: 19.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected
                          ? _color2(vipTypeBean: vipTypeBean).withOpacity(0.1)
                          : Colors.white.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(
                      14.w,
                    ),
                  ),
                  padding: EdgeInsets.only(top: 4.w, bottom: 4.w),
                  child: Text(
                    vipTypeBean.title,
                    style: TextStyle(
                        color: selected
                            ? _color2(vipTypeBean: vipTypeBean)
                            : Colors.white.withOpacity(0.8),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    ByWidgetsUtil.richText(
                      unit: '¥',
                      fontSizeUnit: 14.sp,
                      textColorUnit: selected
                          ? _color2(vipTypeBean: vipTypeBean)
                          : Colors.white.withOpacity(0.8),
                      fontSizeIntegral: 28.sp,
                      partIntegral: vipTypeBean.money,
                      textColorIntegral: selected
                          ? _color2(vipTypeBean: vipTypeBean)
                          : Colors.white.withOpacity(0.8),
                    ),


                    // ByWidgetsUtil.richText(
                    //   unit: vipTypeBean.vipListStyle == 1 ||
                    //           (vipTypeBean.vipListStyle == 3 &&
                    //               vipTypeBean.level == VIPLevel.monthy)
                    //       ? '¥'
                    //       : '≈',
                    //   fontSizeUnit: 14.sp,
                    //   textColorUnit: selected
                    //       ? _color2(vipTypeBean: vipTypeBean)
                    //       : Colors.white.withOpacity(0.8),
                    //   fontSizeIntegral:
                    //       vipTypeBean.vipListStyle == 1 ? 28.sp : 24.sp,
                    //   partIntegral: _getPrefixText(
                    //       vipTypeBean: vipTypeBean, controller: controller),
                    //   textColorIntegral: selected
                    //       ? _color2(vipTypeBean: vipTypeBean)
                    //       : Colors.white.withOpacity(0.8),
                    // ),

                    // if (vipTypeBean.vipListStyle != 1)
                    //   ByWidgetsUtil.richText(
                    //     unit: "",
                    //     fontSizeUnit: 12.sp,
                    //     textColorUnit: selected
                    //         ? ByColorUtil.WhiteColor
                    //         : const Color(0xFF67441E),
                    //     fontSizeIntegral: 10.sp,
                    //     partIntegral: "元/",
                    //     textColorIntegral: selected
                    //         ? _color2(vipTypeBean: vipTypeBean)
                    //         : Colors.white.withOpacity(0.8),
                    //   ),
                    //
                    // if (vipTypeBean.vipListStyle != 1)
                    //   ByWidgetsUtil.richText(
                    //     unit: "",
                    //     fontSizeUnit: 12.sp,
                    //     textColorUnit: selected
                    //         ? _color2(vipTypeBean: vipTypeBean)
                    //         : Colors.white.withOpacity(0.8),
                    //     fontSizeIntegral: 10.sp,
                    //     partIntegral: vipTypeBean.vipListStyle == 2 ? "首" : "首",
                    //     textColorIntegral: selected
                    //         ? _color2(vipTypeBean: vipTypeBean)
                    //         : Colors.white.withOpacity(0.8),
                    //   ),


                  ],
                ),
                ByWidgetsUtil.commonText(
                  text: "¥${vipTypeBean.crossedMoney}",
                  fontSize: 12.sp,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 1,
                  decorationColor: selected
                      ? _color2(vipTypeBean: vipTypeBean).withOpacity(0.6)
                      : Colors.white.withOpacity(0.5),
                  textColor: selected
                      ? _color2(vipTypeBean: vipTypeBean).withOpacity(0.6)
                      : Colors.white.withOpacity(0.5),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.w),
                    bottomRight: Radius.circular(12.w),
                  ),
                  child: ByWidgetsUtil.commonContainer(
                    bgColor: selected
                        ? _color3(vipTypeBean: vipTypeBean)
                        : Colors.white.withOpacity(0.05),
                    borerRadius: 0,
                    child: Container(
                      width: double.infinity,
                      height: 30.h,
                      alignment: Alignment.center,
                      child: ByWidgetsUtil.commonText(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        text: _getSuffixText(vipTypeBean: vipTypeBean),
                        textColor: selected
                            ? _color2(vipTypeBean: vipTypeBean)
                            : Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: -6.h,
            child: Offstage(
              offstage: vipTypeBean.isDefault != 1,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.w),
                      bottomRight: Radius.circular(12.w),
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0xFFFF6045),
                        Color(0xFFFF4221),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    top: 2.w,
                    bottom: 2.w,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.hotFireIcon,
                        width: 12.w,
                        height: 12.w,
                      ),
                      Text(
                        vipTypeBean.mark.isNotEmpty ? vipTypeBean.mark : "最划算",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
      onTap: () {
        controller.selectedVipType(vipTypeBean: vipTypeBean);
      },
    );
  }

  _getPrefixText({
    required VipTypeBean vipTypeBean,
    required VipPurchaseController controller,
  }) {
    /// 3 -month 2-day
    String moneyValue;
    if (vipTypeBean.vipListStyle == 1) {
      moneyValue = vipTypeBean.money;
    } else if (vipTypeBean.vipListStyle == 2) {
      moneyValue = vipTypeBean.dayMoney;
    }  else if (vipTypeBean.vipListStyle == 6) {
      moneyValue = vipTypeBean.musicMoney;
    }

    else {
      moneyValue = vipTypeBean.level == VIPLevel.monthy
          ? vipTypeBean.money
          : vipTypeBean.monthMoney;
    }

    // 如果是第一个套餐且正在动画中，使用动画中的价格
    if (controller.vipTypeBeans.isNotEmpty &&
        vipTypeBean.id == controller.vipTypeBeans.first.id &&
        controller.isAnimating) {
      return controller.getCurrentAnimatedMoney();
    }

    return moneyValue;
  }

  _getSuffixText({
    required VipTypeBean vipTypeBean,
  }) {
    Get.log("====当前套餐类型==== ${vipTypeBean.vipListStyle}");

    return "≈${vipTypeBean.musicMoney}元/首";

    // if (vipTypeBean.vipListStyle == 6) {
    //   return "≈${vipTypeBean.musicMoney}元/首";
    // }
    // return "¥${vipTypeBean.money}";
  }

  ///会员核心权益
  Widget _vipRightsArea({
    required VipPurchaseController controller,
  }) {
    List<Creation> selectedCreation = [];
    if (controller.selectedVipTypeModel.type == 0) {
      selectedCreation = controller.exclusive;
    } else if ((controller.selectedVipTypeModel.type == 1)) {
      selectedCreation = controller.advanced;
    } else if ((controller.selectedVipTypeModel.type == 2)) {
      selectedCreation = controller.creation;
    }

    Get.log("会员核心权益===> ${controller.selectedVipTypeModel.type}");

    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: ByColorUtil.color1E1E1E,
        borderRadius: BorderRadius.circular(10.w),
      ),
      // margin: EdgeInsets.only(left: 12.w,right: 12.w,),
      padding: EdgeInsets.only(
        top: 21.w,
        bottom: 12.w,
      ),
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 12.w,
              ),
              Text(
                "会员核心权益",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Text(
              //   "权益详情",
              //   style: TextStyle(
              //     color: Colors.white.withOpacity(0.8),
              //     fontSize: 12.sp,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              SizedBox(
                width: 12.w,
              ),
            ],
          ),
          SizedBox(
            height: 16.w,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
            ),
            child: FlexibleWrap(
              spacing: 8.0, // 子组件之间的间距
              runSpacing: 12.0.w,
              isOneRowExpanded: true, // 行间距
              children: [
                ...selectedCreation.map(
                  (e) => SizedBox(
                    width: 158.w,
                    height: 50.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: e.selected == 0
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              e.desc,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: e.selected == 0
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///购买按钮
  Widget _buyButton({
    required VipPurchaseController controller,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: ByColorUtil.color121212,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkResponse(
                onTap: (){
                  controller.agreementCheckedStatusChanged(
                      !controller.isAgreePrivacy);
                },
                child:  Row(
                  children: [
                    SizedBox(
                      width: 12.w,
                    ),
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
                      child: controller.isAgreePrivacy
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
                    Text(
                      "我已阅读并同意",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              InkResponse(
                onTap: () {
                  controller.openVip();
                },
                child: Text(
                  " 会员服务协议",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Container(
                width: 1.sw,
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 10.w,
                ),
                child: InkResponse(
                  onTap: () {
                    controller.buyEvent();
                  },
                  child: Container(
                    width: 1.sw,
                    height: 52.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: _buyBtnColor(
                            vipTypeBean: controller.selectedVipTypeBean)),
                    alignment: Alignment.center,
                    child: _buyBtnText(
                      vipTypeBean: controller.selectedVipTypeBean,
                      controller: controller,
                    ),
                  ),
                ),
              ),

              // if ((controller.selectedVipTypeBean != null) &&
              //     (controller.selectedVipTypeBean!.vipLevel <= 30 ||
              //         controller.selectedVipTypeBean!.vipLevel == 90 ||
              //         controller.selectedVipTypeBean!.vipLevel >= 365))
              //   Positioned(
              //     right: 12.w,
              //     top: 0.w,
              //     child: Container(
              //       height: 26.h,
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 8.w,
              //       ),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(26.w),
              //           bottomLeft: Radius.circular(26.w),
              //           topRight: Radius.circular(26.w),
              //           bottomRight: Radius.circular(0.w),
              //         ),
              //         gradient: LinearGradient(
              //           begin: Alignment.centerLeft,
              //           end: Alignment.centerRight,
              //           colors: controller.selectedVipTypeBean!.vipLevel <= 30
              //               ? [
              //                   const Color(0xFFFFA04C),
              //                   const Color(0xFFFF7B1D),
              //                 ]
              //               : controller.selectedVipTypeBean?.vipLevel == 90
              //                   ? [
              //                       const Color(0xFFFF674C),
              //                       const Color(0xFFFF3F1D),
              //                     ]
              //                   : [
              //                       const Color(0xFFFF5E81),
              //                       const Color(0xFFFF2050),
              //                     ],
              //         ),
              //       ),
              //       child: Center(
              //         child: Text(
              //           // "约${controller.selectedVipTypeBean!.vipLevel <= 30 ? controller.creationMusicNum : controller.selectedVipTypeBean!.vipLevel == 90 ? controller.advancedMusicNum : controller.exclusiveMusicNum}首歌",
              //           "约${controller.selectedVipTypeBean!.musicNum}首歌",
              //           style: TextStyle(
              //             fontSize: 12.sp,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   )


            ],
          ),
          SizedBox(
            height: 35.w,
          ),
        ],
      ),
    );
  }

  ///支付方式
  Widget _payMethod({
    required VipPurchaseController controller,
  }) {
    if (Platform.isAndroid) {
      ///这里微信 支付宝支付
      if (controller.payMethodBeans.isEmpty) {
        return const SizedBox();
      }
      return InkResponse(
        onTap: () {
          Get.log(
              "selectedIndex==>${controller.selectedPayMethodIndex} length ==>${controller.payMethodBeans.length}  ");
          if (controller.payMethodBeans.length >= 2) {
            if (controller.selectedPayMethodIndex == 0) {
              controller.changeSelectedPayMethodIndex(1);
            } else if (controller.selectedPayMethodIndex == 1) {
              controller.changeSelectedPayMethodIndex(0);
            }
          }
        },
        child: Container(
          width: 1.sw,
          decoration: BoxDecoration(
            color: Color(0XFF252525),
            borderRadius: BorderRadius.circular(8.w),
          ),
          margin: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 15.w,
          ),
          padding:
              EdgeInsets.only(left: 20.w, right: 12.w, top: 11.w, bottom: 11.w),
          child: Row(
            children: [
              Image.asset(
                controller
                    .payMethodBeans[controller.selectedPayMethodIndex].icon,
                width: 18.w,
                height: 18.w,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                controller
                    .payMethodBeans[controller.selectedPayMethodIndex].payName,
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
  }

  ///用户反馈
  Widget _userFeedBackView({
    required VipPurchaseController controller,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 15.w, left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: ByColorUtil.color1E1E1E,
        borderRadius: BorderRadius.circular(10.w),
      ),
      padding: EdgeInsets.only(
        top: 21.w,
        left: 12.w,
        right: 12.w,
        bottom: 12.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "用户反馈",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 15.w,
          ),
          SizedBox(
            height: 110.w,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: [
                // _userFeedBackItemView(),
                ...controller.feedback
                    .map((e) => _userFeedBackItemView(feedBack: e))
              ],
            ),
          )
        ],
      ),
    );
  }

  ///用户反馈子组件
  Widget _userFeedBackItemView({
    required FeedbackModel feedBack,
  }) {
    return Container(
      width: 198.w,
      height: 107.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.1,
        ),
        borderRadius: BorderRadius.circular(8.w),
      ),
      padding: EdgeInsets.all(
        10.w,
      ),
      margin: EdgeInsets.only(left: 0.w, right: 10.w),
      child: Column(
        children: [
          Text(
            feedBack.content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.w),
                child: CachedNetworkImage(
                  imageUrl: feedBack.avatar,
                  width: 16.w,
                  height: 16.w,
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                feedBack.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ///购买须知
  Widget _purchaseNoticeView({
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12.w,
        left: 12.w,
        right: 12.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "购买须知",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  ///导航区域
  Widget _buildNavView({
    required VipTypeModel vipTypeModel,
    required VipPurchaseController controller,
  }) {
    Get.log("用户信息===> ${controller.userInfoBean}");
    UserInfoBean? userInfoBean = Get.find<LaunchController>().user.value;
    return Stack(
      children: [
        SizedBox(
          height: 400.w,
        ),
        Positioned(
          child: Image.asset(
            vipTypeModel.image,
            height: 280.w,
            fit: BoxFit.fill,
            width: 1.sw,
          ),
        ),
        Positioned(
          left: 0.w,
          top: 98.w,
          right: 23.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 29.w,
                  ),
                  Image.asset(
                    vipTypeModel.vipHeaderImage,
                    width: 16.w,
                    height: 16.w,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  if (userInfoBean != null)
                    Text(
                      userInfoBean.nickName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (userInfoBean != null)
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Text(
                        "(${userInfoBean.userId})",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 4.w,
              ),
              Padding(
                padding: EdgeInsets.only(left: 29.w),
                child: Text(
                  "解锁会员开启音乐人创作+变现之旅",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp),
                ),
              ),
              SizedBox(
                height: 18.w,
              ),
              if (_items.isNotEmpty)
                SizedBox(
                  height: 30.w,
                  child: InfiniteMarquee(
                    itemBuilder: (BuildContext context, int index) {
                      String item = _items[index % _items.length];
                      return Container(
                        margin: EdgeInsets.only(left: 12.w),
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14.w),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                    frequency: const Duration(milliseconds: 20),
                  ),
                )
            ],
          ),
        ),
        Positioned(
          top: 218.w,
          child: SizedBox(
            height: 180.h,
            // color: Colors.red,
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 150.h,
                    child: GridView.builder(
                      padding: EdgeInsets.only(left: 12.w, right: 12.w),
                      // scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      itemCount: controller.vipTypeBeans.length,
                      physics: controller.vipTypeBeans.length > 3
                          ? null
                          : const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12.w,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 130.h / (130.h * 1.3),
                      ),
                      itemBuilder: (context, index) {
                        if(index==0){
                          musicMoney = controller.vipTypeBeans[index].musicMoney;
                        }

                        return _purchaseItemView(
                          vipTypeBean: controller.vipTypeBeans[index],
                          controller: controller,
                        );
                      },
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Text(
                    controller.showHintText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(
                        0.5,
                      ),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  LinearGradient _color1({
    required VipTypeBean vipTypeBean,
  }) {
    if (vipTypeBean.vipLevel == 90) {
      return const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFF99A6E), Color(0xFFFFE5CB)],
      );
    }

    if (vipTypeBean.vipLevel <= 30) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF006934), Color(0xFF00CB64)],
      );
    }
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xffEBB04B), Color(0xffFFDCA7)],
    );
  }

  Color _color2({
    required VipTypeBean vipTypeBean,
  }) {
    if (vipTypeBean.vipLevel == 90) {
      return ByColorUtil.color9F3E02;
    }
    if (vipTypeBean.vipLevel <= 30) {
      return Colors.white;
    }
    return ByColorUtil.color9F5602;
  }

  Color _color3({
    required VipTypeBean vipTypeBean,
  }) {
    if (vipTypeBean.vipLevel == 90) {
      return Colors.white.withOpacity(0.2);
    }
    if (vipTypeBean.vipLevel <= 30) {
      return Colors.white.withOpacity(0.2);
    }
    return Colors.white.withOpacity(0.5);
  }

  LinearGradient _buyBtnColor({
    required VipTypeBean? vipTypeBean,
  }) {
    if (vipTypeBean != null) {
      if (vipTypeBean.vipLevel == 90) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFF99A6E), Color(0xFFFFE5CB)],
        );
      }

      if (vipTypeBean.vipLevel <= 30) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF24FECF), Color(0xFFFFF13C)],
        );
      }
    }

    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFFEC57F),
        Color(0xFFFFE3B4),
      ],
    );
  }

  LinearGradient _buyBtnTextColor({
    required VipTypeBean? vipTypeBean,
  }) {
    if (vipTypeBean != null) {
      if (vipTypeBean.vipLevel == 30) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [ByColorUtil.color121212,ByColorUtil.color121212],
        );
      }

      if (vipTypeBean.vipLevel == 90) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF9F3E02), Color(0xFFC16515)],
        );
      }
    }

    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF9F5602),
        Color(0xFFC17015),
      ],
    );
  }

  Widget _buyBtnText({
    required VipTypeBean? vipTypeBean,
    required VipPurchaseController controller,
  }) {
    // if (vipTypeBean != null) {
    //   if (vipTypeBean.vipLevel <= 30) {
    //     return Text(
    //       controller.memberBtnTxt,
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 18.sp,
    //           // height: 1.0,
    //           color: ByColorUtil.color121212),
    //     );
    //   }
    // }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return _buyBtnTextColor(vipTypeBean: vipTypeBean).createShader(bounds);
      },
      child: Text(
        controller.memberBtnTxt,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            // height: 1.0,
            color: Colors.white),
      ),
    );
  }

  late StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = eventBus.on<RefreshMarqueeEvent>().listen((event) {
      _items.clear();
      _items.addAll(Get.find<VipPurchaseController>().marqueeList);
      if (mounted) {
        setState(() {});
      }
    });

    Get.find<VipPurchaseController>().iniIosPaySuccessSubscription();

    final arguments = Get.arguments;
    if(arguments!=null){
      if(arguments["show_bottom_pay_dialog"]!=null){
        showBottomPayDialog = arguments["show_bottom_pay_dialog"];
      }

      if(arguments["buy_vip"]!=null){
        bool buVip = arguments["buy_vip"];
        Get.log("===buyVip=== $buVip");
        if(buVip){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<VipPurchaseController>().buyEvent();
          });
        }
      }
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面进入时都调用setPageEntered，确保挽留弹窗逻辑正确执行
    Get.find<VipPurchaseController>().setPageEntered();

    ///协议初始化
    Get.find<VipPurchaseController>().agreementCheckedStatusChanged(false);
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    Get.find<VipPurchaseController>().cancelIosPaySuccessSubscription();
    Get.find<LaunchController>().reloadUserInfo();
    Get.find<VipPurchaseController>().postShowBottomPayDialogEvent(showBottomPayDialog: showBottomPayDialog);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<VipPurchaseController>(
      builder: (controller) {
        VipTypeModel vipTypeModel = controller.selectedVipTypeModel;
        DataService.onEvent(DataServiceEventName.paywallShow, {});

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            // controller.goBack();
          },
          child: Material(
            child: Container(
              color: ByColorUtil.color121212,
              child: SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ///基本布局
                    SizedBox(
                      width: 1.sw,
                      height: 1.sh,
                      child: ListView(
                        padding: EdgeInsets.only(
                          bottom: 180.w,
                        ),
                        children: [
                          ///导航页面
                          _buildNavView(
                            vipTypeModel: vipTypeModel,
                            controller: controller,
                          ),

                          ///会员权益说明区域
                          _vipRightsArea(
                            controller: controller,
                          ),

                          ///支付方式
                          _payMethod(
                            controller: controller,
                          ),

                          ///用户反馈
                          _userFeedBackView(controller: controller),

                          ///购买须知
                          _purchaseNoticeView(content: controller.notice),
                        ],
                      ),
                    ),

                    ///购买按钮
                    Positioned(
                      bottom: 0,
                      child: _buyButton(
                        controller: controller,
                      ),
                    ),

                    ///导航
                    Positioned(
                      top: 55.w,
                      left: 16.w,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.goBack(musicMoney: musicMoney);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 108.w,
                          ),
                          Text(
                            "解锁会员",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 75.w,
                          ),

                          ///恢复购买
                          if (Platform.isIOS)
                            InkResponse(
                              onTap: () {
                                controller.iosRepair();
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90.w),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Container(
                                      width: 68.w,
                                      height: 28.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(90.w),
                                      ),
                                      child: Text(
                                        "恢复购买",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
