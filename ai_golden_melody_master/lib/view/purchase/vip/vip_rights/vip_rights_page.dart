import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strstegy_tab_view.dart';
import 'package:ai_golden_melody_master/view/publish/widget/tutorial_single_page_view.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_rights/vip_rights_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../model/purchase/vip_model.dart';
import '../../../../utils/by_color_utils.dart';

///会员权益页面
class VipRightsPage extends StatefulWidget {
  const VipRightsPage({super.key});

  @override
  State<VipRightsPage> createState() => _VipRightsPageState();
}

class _VipRightsPageState extends State<VipRightsPage> {
  final VipRightsController _controller = Get.find<VipRightsController>();

  // 添加ScrollController来保持滚动位置
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 监听tab切换，保持滚动位置
    ever(_controller.selectedTutorialTab, (int index) {
      // 延迟一帧后恢复滚动位置，确保页面重建完成
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // 保持当前滚动位置
          final currentOffset = _scrollController.offset;
          if (currentOffset > 0) {
            _scrollController.jumpTo(currentOffset);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///导航页面
  _buildNavView({
    required VipRightsController controller,
  }) {
    VipTypeModel vipTypeModel = controller.selectedVipTypeModel;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 280.w, // 调整为背景图片的高度，避免重叠
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
              InkResponse(
                onTap: () {
                  controller.copyId();
                },
                child: Row(
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
                    if (controller.userInfoBean != null)
                      Text(
                        controller.userInfoBean!.nickName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (controller.userInfoBean != null)
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
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
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Image.asset(
                          Assets.vipCopyIcon,
                          width: 14.w,
                          height: 14.w,
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),

        ///信息区域
        Positioned(
          left: 12.w,
          top: 134.w,
          right: 12.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                vipTypeModel.userMessageBgIconPath,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Image.asset(
                    vipTypeModel.userMessageIconPath,
                    width: 16.w,
                    height: 16.w,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    vipTypeModel.userMessageText,
                    style: TextStyle(
                      color: vipTypeModel.userMessageColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  if (controller.userInfoBean!.vipEndTime != null)
                    Text(
                      "有效期:${ByHyTimeUtils.timeFromDateTime2(controller.userInfoBean!.vipEndTime!)}",
                      style: TextStyle(
                          color: vipTypeModel.userMessageColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp),
                    ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: vipTypeModel.userMessageColor.withOpacity(0.1),
                        border: Border.all(
                          color: vipTypeModel.userMessageColor.withOpacity(0.1),
                        ),
                        borderRadius: BorderRadius.circular(14.w)),
                    padding: EdgeInsets.only(
                      top: 4.w,
                      bottom: 4.w,
                      left: 6.w,
                      right: 6.w,
                    ),
                    child: Text(
                      "当前状态",
                      style: TextStyle(
                        color: vipTypeModel.userMessageColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          left: 0.w,
          right: 0.w,
          top: 218.w,
          child: _vipRightsArea(controller: controller),
        ),

        ///导航栏
        Positioned(
          top: 55.w,
          left: 16.w,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.goBack();
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
              SizedBox(
                width: 108.w,
              ),
              Text(
                "会员权益",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 117.w,
              ),
              InkResponse(
                onTap: () {
                  controller.goChatOnlinePage();
                },
                child: Image.asset(
                  Assets.vipOnlineChatIcon,
                  width: 25.w,
                  height: 25.w,
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///会员核心权益
  Widget _vipRightsArea({
    required VipRightsController controller,
  }) {
    List<VipRightIconModel> vipRightIconModel = controller.vipRightIconModel;
    List<Creation> creation = controller.creation;

    return Padding(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
      ),
      child: Container(
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
                Text(
                  "权益详情",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                  if (creation.isEmpty)
                    ...vipRightIconModel.map((e) => SizedBox(
                          width: 158.w,
                          height: 50.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                e.iconPath,
                                width: 44.w,
                                height: 44.w,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    e.title1,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    e.title1,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  if (creation.isNotEmpty)
                    ...creation.map((e) => SizedBox(
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
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///计算_vipRightsArea的高度
  double _calculateVipRightsAreaHeight(VipRightsController controller) {
    List<VipRightIconModel> vipRightIconModel = controller.vipRightIconModel;
    List<Creation> creation = controller.creation;

    // 基础高度：顶部padding + 标题行高度 + 间距 + 底部padding
    double baseHeight = 21.w + 20.w + 16.w + 12.w; // 标题行高度估算为20.w

    // 计算内容区域高度
    double contentHeight = 0;
    if (creation.isEmpty) {
      // 使用默认权益数据，每行2个，每行高度50.w + 间距12.w
      int itemCount = vipRightIconModel.length;
      int rows = (itemCount / 2).ceil(); // 向上取整
      contentHeight = rows * (50.w + 12.w) - 12.w; // 减去最后一行的间距
    } else {
      // 使用服务器数据，每行2个，每行高度50.w + 间距12.w
      int itemCount = creation.length;
      int rows = (itemCount / 2).ceil(); // 向上取整
      contentHeight = rows * (50.w + 12.w) - 12.w; // 减去最后一行的间距
    }

    return baseHeight + contentHeight;
  }

  ///升级按钮
  Widget _buildUpgradeButton({
    required VipRightsController controller,
  }) {
    if (controller.canUpgrade == 2) {
      return SizedBox(
        height: 15.h,
      );
    }
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 15.w,
        bottom: 15.w,
      ),
      child: GestureDetector(
        onTap: () {
          controller.upgradeMember();
        },
        child: Container(
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0XFFF99A6E),
                Color(0XFFFFE5CB),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "升级会员权益",
            style: TextStyle(
              color: const Color(0XFF9F3E02),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///教程tab视图
  Widget _buildTabView({
    required VipRightsController controller,
  }) {
    return Obx(() {
      final tabs = controller.tutorialTabs.value;

      if (tabs.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          bottom: 6.h,
        ),
        height: 48.w,
        child: StrategyTabView(
          // 教程标签列表
          tabs: tabs,
          // 当前选中的标签索引
          selectedTab: controller.selectedTutorialTab,
          // 水平滚动控制器
          scrollController: controller.tutorialTabScrollController,
          // 标签宽度映射表，用于自动滚动计算
          itemWidths: controller.tutorialItemWidths,
          // 标签切换回调，更新选中状态并触发页面切换
          onTabChanged: (index) {
            if (index >= 0 && index < tabs.length) {
              controller.updateSelectedTutorialTab(index);
            }
          },
        ),
      );
    });
  }

  ///精选创作教程
  Widget tutorialView({
    required VipRightsController controller,
  }) {
    return Obx(() {
      final tabs = controller.tutorialTabs.value;
      final selectedTab = controller.selectedTutorialTab.value;

      if (tabs.isEmpty) {
        return const SizedBox.shrink();
      }

      // 确保selectedTab在有效范围内
      final validTabIndex =
          selectedTab >= 0 && selectedTab < tabs.length ? selectedTab : 0;

      // 使用AnimatedSwitcher来平滑切换，避免页面重建
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: TutorialSinglePageView(
          key: ValueKey(validTabIndex), // 使用key来标识不同的tab
          tabIndex: validTabIndex,
          controller: controller,
        ),
      );
    });
  }

  Widget _buildTitleView() {
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 12.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "精选创作教程",
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0XFFFFFFFF),
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<VipRightsController>().loadMore(2);
            },
            child: Container(
              height: 24.h,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.w),
                color: const Color(0XFF3A3A3C),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "全部",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                    ),
                  ),
                  Image.asset(
                    "assets/purchase/home/home_right_icon.png",
                    width: 14.w,
                    height: 14.h,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 吸顶的Tab视图
  Widget stickyTabView() {
    // 这个方法现在只作为占位符，实际内容在_StickyTabDelegate中构建
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VipRightsController>(builder: (controller) {
      return Material(
        child: Container(
          color: ByColorUtil.color121212,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // 顶部内容
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ///导航页面
                    _buildNavView(
                      controller: controller,
                    ),

                    ///会员核心权益
                    // _vipRightsArea(controller: controller),
                    ///占位高度
                    SizedBox(
                      height: _calculateVipRightsAreaHeight(controller) - 62.h,
                    ),

                    ///升级按钮
                    _buildUpgradeButton(
                      controller: controller,
                    ),

                    ///教程页面标题和tab
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFF1E1E1E),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.w),
                            topRight: Radius.circular(12.w),
                          ),
                        ),
                        child: Column(
                          children: [
                            ///标题
                            _buildTitleView(),

                            ///教程tab
                            _buildTabView(
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 教程内容
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0XFF1E1E1E),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.w),
                        bottomRight: Radius.circular(12.w),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.w),
                        bottomRight: Radius.circular(12.w),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 20.h, // 添加底部间距
                        ),
                        child: tutorialView(
                          controller: controller,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
