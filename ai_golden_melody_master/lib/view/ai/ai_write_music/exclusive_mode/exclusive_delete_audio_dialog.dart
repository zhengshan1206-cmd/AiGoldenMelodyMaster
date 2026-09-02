import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/by_color_utils.dart';

///音频删除确认弹窗
class ExclusiveDeleteAudioDialog extends StatelessWidget {
  final String audioName;
  const ExclusiveDeleteAudioDialog({
    super.key,
    required this.audioName,
  });
  @override
  Widget build(BuildContext context) {
    String name = audioName;
    if (name.length > 8) {
      name = "${name.substring(0, 6)}...";
    }

    return Center(
      child: Container(
          width: 352.w,
          height: 180.w,
          decoration: BoxDecoration(
            color: ByColorUtil.color2e2e2e,
            image: const DecorationImage(
                image: AssetImage(
                  Assets.exclusiveBg,
                ),
                fit: BoxFit.fitHeight),
            borderRadius: BorderRadius.circular(12.w),
          ),
          padding: EdgeInsets.only(bottom: 24.w, top: 2.w,left: 12.w,right: 12.w,),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  InkResponse(
                    onTap: () {
                      Get.back(result: {"confirm": false});
                    },
                    child: Container(
                        width: 30.w,
                        height: 30.w,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Image.asset(
                          Assets.iconClose,
                          width: 16.w,
                          height: 16.w,
                        )),
                  ),
                  SizedBox(
                    width: 5.w,
                  )
                ],
              ),


              Text(
                "删除确认",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),


              SizedBox(
                height: 10.w,
              ),

              Text("确认要删除$name吗，删除后不支持找回？",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  )),

              const Spacer(),

              Row(
                children: [
                  InkResponse(
                      onTap: () {
                        Get.back(result: {"confirm": false});
                      },
                      child:Container(
                        width: 144.w,
                        height: 48.w,
                        margin: EdgeInsets.only(left: 12.w, right: 15.w),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.w)),
                        alignment: Alignment.center,
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),),
                  InkResponse(
                      onTap: () {
                        Get.back(result: {"confirm": true});
                      },
                      child:  Container(
                        width: 144.w,
                        height: 48.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                            color: ByColorUtil.colorFEC57F,
                            borderRadius: BorderRadius.circular(12.w)),
                        alignment: Alignment.center,
                        child: Text(
                          '确认删除',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),)
                ],
              )
            ],
          )),
    );
  }
}
