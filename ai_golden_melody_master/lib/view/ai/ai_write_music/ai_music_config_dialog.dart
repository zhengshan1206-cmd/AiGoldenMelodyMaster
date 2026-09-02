import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../model/ai_music/ai_music_config_model.dart';

class AiMusicConfigDialog extends StatefulWidget {
  final OptionModelEx option;
  final Color borderColor;
  final Color backgroundColor;
  final String selectedContent;
  final String selectedContent2;
  const AiMusicConfigDialog({
    super.key,
    required this.option,
    required this.borderColor,
    required this.backgroundColor,
    required this.selectedContent,
    required this.selectedContent2,
  });

  @override
  State<AiMusicConfigDialog> createState() => _AiMusicConfigDialogState();
}

class _AiMusicConfigDialogState extends State<AiMusicConfigDialog> {
  String selectedContent = "";
  String selectedContent2 = "";

  @override
  void initState() {
    selectedContent = widget.selectedContent;
    selectedContent2 = widget.selectedContent2;
    super.initState();
  }

  Widget _itemView({
    required Item item,
  }) {
    bool selected = false;
    if (item.zh == selectedContent) {
      selected = true;
    }
    return InkResponse(
      onTap: () {
        if (item.zh != selectedContent) {
          if (mounted) {
            setState(() {
              selectedContent = item.zh ?? "";
              selectedContent2 = item.en ?? "";
            });
          }
        }

        Get.log("选中==> ${item.zh} ");
      },
      child: SizedBox(
        child: Container(
          padding: EdgeInsets.only(
            top: 8.w,
            bottom: 8.w,
            left: 10.w,
            right: 10.w,
          ),
          // margin: EdgeInsets.only(right: 12.w,),
          decoration: BoxDecoration(
              color: selected
                  ? widget.backgroundColor
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(
                14.w,
              ),
              border: Border.all(
                color: selected ? widget.borderColor : Colors.transparent,
              )),
          child: Text(
            "${item.zh}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  ///选择区域
  Widget _selectArea({required List<Item> itemsList}) {
    if (widget.option.option!.en == "audio_duration") {
      return Column(
        children: [
          SizedBox(
            width: 1.sw,
            child: SfSlider(
              min: widget.option.option!.min,
              max: int.parse(selectedContent2),
              value: int.parse(selectedContent),
              showTicks: false,
              showLabels: false,
              enableTooltip: false,
              minorTicksPerInterval: 1,
              activeColor: ByColorUtil.colorC98465,
              inactiveColor: Colors.white.withOpacity(0.1),
              onChanged: (value) async {
                double changeValue = value;
                if(mounted){
                  setState(() {
                    selectedContent = changeValue.toInt().toString();
                  });
                }

                Get.log("===改变的进度条value==== ${changeValue.toInt()}");
              },
            ),
          ),
          Text("${selectedContent}",style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16.sp,
          ),)
        ],
      );
    }

    return Wrap(
      spacing: 12.w, // 水平间距
      runSpacing: 12.w, // 垂直间距
      alignment: WrapAlignment.start, // 对齐方式
      children: [
        ...itemsList.map(
          (e) => _itemView(
            item: e,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Item> itemsList = [];
    if (widget.option.option != null) {
      if (widget.option.option!.items != null) {
        itemsList.addAll(widget.option.option!.items!);
      }
    }
    Get.log("配置项目===>${widget.option.option?.toJson()}");
    return Stack(
      children: [
        SizedBox(
          height: 0.6.sh,
          child: Container(
            width: 1.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: const Color(0XFF2e2e2e),
            ),
            padding: EdgeInsets.only(
              top: 20.w,
              // right: 12.w,
              // left: 12.w
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.option.option?.zh ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.w,
                ),
                _selectArea(itemsList: itemsList),
                const Spacer(),
                InkResponse(
                  onTap: () {
                    Get.back(result: {
                      "selectContent": selectedContent,
                      "selectContent2": selectedContent2,
                      "option": widget.option,
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                    ),
                    padding: EdgeInsets.only(
                      top: 17.w,
                      bottom: 17.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFF99A6E),
                          Color(0xFFFFE5CB),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF9F3E02), Color(0xFFC16515)],
                        ).createShader(bounds);
                      },
                      child: const Text(
                        '确认选择',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.0, // 对应CSS的line-height: 18px
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 46.w,
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 12.w,
            right: 12.w,
            child: InkResponse(
              child: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onTap: () {
                Get.back();
              },
            ))
      ],
    );
  }
}
