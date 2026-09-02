import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/guide_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GuidePage extends StatelessWidget {
  GuidePage({super.key});

  final _controller = Get.find<GuideController>();

  ///单个引导页面布局
  Widget _buildSinglePage(int index) {
    return Container(
      color: const Color(0XFF111111),
      child: Stack(
        children: [
          Image.asset(
            'assets/main/guide/guide_bg_$index.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
          _buildTitle(index),
        ],
      ),
    );
  }

  ///引导页标题
  Widget _buildTitle(int index) {
    return Positioned(
      left: 0,
      right: 0,
      top: 592.w,
      child: Column(
        children: [
          ByWidgetsUtil.commonText(
            text: _controller.pageTitles[index],
            textColor: const Color(0XFFFFFFFF),
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 10,
          ),
          ByWidgetsUtil.commonText(
            text: _controller.pageContents[index],
            textColor: const Color(0XFFFFFFFF).withOpacity(0.8),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  ///引导页右上角按钮
  Widget _buildRightButton() {
    return Positioned(
      right: 16.w,
      top: 52.h,
      child: GestureDetector(
        onTap: () {
          // 使用Future.delayed确保在构建完成后执行
          _controller.skipGuide();
        },
        child: Container(
          width: 60.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(60.w),
          ),
          alignment: Alignment.center,
          child: ByWidgetsUtil.commonText(
            text: '跳过',
            textColor: const Color(0XFFFFFFFF),
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  ///进度条
  Widget _buildProgress() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 48.h,
      child: Container(
        width: double.infinity,
        height: 2.h,
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _controller.pageTitles.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              width: 40.w,
              height: 2.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: _controller.currentIndex.value == index
                    ? const Color(0XFFFFFFFF)
                    : const Color(0XFFFFFFFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          },
        ),
      ),
    );
  }

  ///引导页底部按钮
  Widget _buildBottomButton() {
    return Positioned(
      bottom: 48.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            _controller.skipGuide();
          },
          child:BtnBreathingAnimationWidget(child: Container(
            width: 208.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90.w),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0XFF24FECF),
                  Color(0XFFFFF13C),
                ],
              ),
            ),
            alignment: Alignment.center,
            child: ByWidgetsUtil.commonText(
              text: '即刻开启音乐之旅',
              textColor: const Color(0XFF121212),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF111111),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller.pageController,
            itemCount: _controller.pageTitles.length,
            onPageChanged: (index) {
              // 确保索引在有效范围内
              if (index >= 0 && index < _controller.pageTitles.length) {
                _controller.updateCurrentIndex(index);
              }
            },
            itemBuilder: (context, index) {
              return _buildSinglePage(index);
            },
          ),
          Obx(() {
            final currentIndex = _controller.currentIndex.value;
            final isLastPage =
                currentIndex == _controller.pageTitles.length - 1;
            return isLastPage ? _buildBottomButton() : _buildProgress();
          }),
          Obx(() {
            final currentIndex = _controller.currentIndex.value;
            final isLastPage =
                currentIndex == _controller.pageTitles.length - 1;
            return isLastPage ? const SizedBox.shrink() : _buildRightButton();
          }),
        ],
      ),
    );
  }
}
