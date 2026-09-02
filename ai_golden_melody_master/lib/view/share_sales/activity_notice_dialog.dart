import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'bean/invite_info.dart';

class ActivityNoticeDialog extends StatelessWidget {
  final InviteActivityModel descriptionUrl;
  const ActivityNoticeDialog({super.key,required this.descriptionUrl,});

  Widget _contentItem({required ContentItem item,}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title,style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),),
        SizedBox(height: 8.w,),
        Text(item.content,style: TextStyle(
          color: const Color(0XFFA0A0A7),
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),),
        SizedBox(height: 8.w,),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child:Stack(
          children: [
            Container(
              width: 1.sw,
              height: 1.sh,
              margin: EdgeInsets.only(
                  top: 100.w
              ),
              padding: EdgeInsets.only(
                  top: 16.w,
                  left: 12.w,
                  right: 12.w
              ),
              decoration: BoxDecoration(
                  color: const Color(0XFF1E1F24),
                  //   color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.w),
                    topLeft:  Radius.circular(12.w),
                  )
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 1.sw,
                    child: Row(
                      children: [
                        Text(descriptionUrl.title,style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),),
                        const Spacer(),
                        InkResponse(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              "assets/home/share_sales/close_icon.png",
                              width: 24.w,
                              height: 24.w,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w,),
                  Expanded(child: ListView(
                    padding: EdgeInsets.only(
                      bottom: 0.w,
                    ),
                    children: [
                      Text(descriptionUrl.start,style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: Color(
                              0XFFA0A0A7
                          )
                      ),),
                      SizedBox(height: 8.w,),
                      ...descriptionUrl.content.map((e)=>_contentItem(item: e),),
                      Text(descriptionUrl.end,style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: Color(
                              0XFFA0A0A7
                          )
                      ),),
                      SizedBox(height: 20.w,),
                    ],
                  )),
                  SizedBox(height: 90.w,),
                ],
              ),
            ),

            Positioned(
                bottom: 34.w,
                left: 12.w,
                right: 12.w,
                child:InkResponse(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.38, 1.0], // 38%和100%的位置
                        colors: [
                          Color(0xFF98FC4A), // #98FC4A
                          Color(0xFFD7F97D), // #D7F97D
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15.w),
                    ),
                    child:  Center(
                      child: Text(
                        "我知道了",
                        style: TextStyle(
                          color: Color(0XFF162408),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )

            ),
          ],
        )
    );
  }
}
