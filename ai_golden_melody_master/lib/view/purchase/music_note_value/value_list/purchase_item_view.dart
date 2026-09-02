import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import '../../../../model/purchase/integral_record_bean.dart';
import '../../../../utils/by_color_utils.dart';

class PurchaseItemView extends StatelessWidget {
  final IntegralRecordBean integralRecordBean;

  const PurchaseItemView({
    super.key,
    required this.integralRecordBean,
  });

  Widget _purchaseItemView({
    required IntegralRecordBean model,
  }) {
    Color color1 = Colors.white.withOpacity(0.8);
    if (model.integral > 0) {
      color1 = ByColorUtil.color00CB64;
    }

    if (model.integral < 0) {
      color1 = ByColorUtil.colorFFF13C;
    }

    return Container(
      decoration: BoxDecoration(
        color: ByColorUtil.color1E1E1E,
        borderRadius: BorderRadius.circular(12.w),
      ),
      margin: EdgeInsets.only(
        bottom: 10.w,
        left: 12.w,
        right: 12.w,
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.des,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "${model.integral > 0 ? "+" : ""}${model.integral}",
                style: TextStyle(
                  color: color1,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.w,
          ),
          Row(
            children: [
              Text(
                ByHyTimeUtils.dateTimeToTime(model.createdAt),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
              const Spacer(),
              Text(
                "剩余${model.userIntegral}音符值",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _purchaseItemView(
      model: integralRecordBean,
    );
  }
}
