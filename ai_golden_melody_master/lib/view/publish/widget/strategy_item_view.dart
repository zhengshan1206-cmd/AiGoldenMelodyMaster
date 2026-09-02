import 'package:ai_golden_melody_master/view/publish/beans/strategy_list_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/svga_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StrategyItemView extends StatelessWidget {
  final StrategyListBean item;
  final VoidCallback? onTap;

  const StrategyItemView({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.w),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 12.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 112.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.w),
                          SizedBox(
                            height: 48.w,
                            child: Text(
                              item.describe,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "assets/purchase/home/strategy_icon_1.png",
                                width: 12.w,
                                height: 12.w,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  item.authorName,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "播放量: ",
                                style: TextStyle(
                                  color: const Color(0xFF969696),
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                formatNumber(
                                    int.parse(item.showNumber.toString())),
                                style: TextStyle(
                                  color: const Color(0xFF00CB64),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0.w,
              left: 12.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: Image.network(
                  item.iconUrl,
                  width: 100.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return loadingView();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return loadingView();
                  },
                ),
              ),
            ),
            if (item.isFree == 2)
              Positioned(
                top: 0.w,
                left: 12.w,
                child: Image.asset(
                  "assets/purchase/vip_label_${item.vipLevel <= 30 ? 1 : item.vipLevel == 90 ? 2 : 3}.png",
                  height: 16.w,
                  fit: BoxFit.fitHeight,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget loadingView() {
    return Container(
      width: 100.w,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: const Color(0XFF1E1E1E),
      ),
      child: Center(
        child: SizedBox(
          width: 56.w,
          height: 56.h,
          child: const SvgaPlayer(
            url: 'assets/home/img_loading.svga',
            isRepeat: true,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// 数字转换方法：超过10000用W展示，保留2位小数
  String formatNumber(int number) {
    if (number >= 10000) {
      double wNumber = number / 10000.0;
      return '${wNumber.toStringAsFixed(2)}w';
    }
    return number.toString();
  }
}
