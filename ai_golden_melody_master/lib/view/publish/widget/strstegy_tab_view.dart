import 'package:ai_golden_melody_master/view/publish/beans/zone_menus_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StrategyTabView extends StatelessWidget {
  /// 标签列表
  final List<ZoneMenusBean> tabs;

  /// 当前选中的标签索引（响应式变量）
  final RxInt selectedTab;

  /// 水平滚动控制器
  final ScrollController scrollController;

  /// 标签项宽度映射表，用于计算滚动位置
  /// key: 标签索引, value: 标签宽度
  final Map<int, double> itemWidths;

  /// 标签切换回调函数
  /// 参数：选中的标签索引
  final Function(int) onTabChanged;

  /// 标签项之间的间距（默认24.0）
  final double itemSpacing;

  /// 选中指示器的宽度（默认32.0）
  final double indicatorWidth;

  /// 选中指示器的高度（默认2.0）
  final double indicatorHeight;

  /// 选中状态的文字颜色（默认绿色）
  final Color selectedColor;

  /// 未选中状态的文字颜色（默认白色）
  final Color unselectedColor;

  /// 选中指示器的颜色（默认绿色）
  final Color indicatorColor;

  /// 文字字体大小（默认14.0）
  final double fontSize;

  /// 构造函数
  ///
  /// [tabs] - 标签列表，不能为空
  /// [selectedTab] - 当前选中的标签索引，必须是RxInt类型
  /// [scrollController] - 水平滚动控制器
  /// [itemWidths] - 标签宽度映射表，用于自动滚动功能
  /// [onTabChanged] - 标签切换回调函数
  /// [itemSpacing] - 标签间距，可选，默认24.0
  /// [indicatorWidth] - 指示器宽度，可选，默认32.0
  /// [indicatorHeight] - 指示器高度，可选，默认2.0
  /// [selectedColor] - 选中颜色，可选，默认绿色
  /// [unselectedColor] - 未选中颜色，可选，默认白色
  /// [indicatorColor] - 指示器颜色，可选，默认绿色
  /// [fontSize] - 字体大小，可选，默认14.0
  const StrategyTabView({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.scrollController,
    required this.itemWidths,
    required this.onTabChanged,
    this.itemSpacing = 24.0,
    this.indicatorWidth = 32.0,
    this.indicatorHeight = 2.0,
    this.selectedColor = const Color(0xFF00CB64),
    this.unselectedColor = const Color(0xFFFFFFFF),
    this.indicatorColor = const Color(0xFF00CB64),
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    // 如果标签列表为空，返回空容器
    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      // 使用传入的滚动控制器
      controller: scrollController,
      // 水平滚动方向
      scrollDirection: Axis.horizontal,
      // 标签数量
      itemCount: tabs.length,
      itemBuilder: (context, index) {
        return Obx(() {
          final isSelected = selectedTab.value == index;
          return LayoutBuilder(
            builder: (context, constraints) {
              // 在布局完成后获取标签项的宽度
              // 用于计算自动滚动的位置
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  // 将标签宽度存储到映射表中
                  itemWidths[index] = renderBox.size.width;
                }
              });

              return GestureDetector(
                onTap: () {
                  if (selectedTab.value == index) return;
                  onTabChanged(index);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: itemSpacing.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.w),
                      Text(
                        tabs[index].title,
                        style: TextStyle(
                          color: isSelected
                              ? selectedColor
                              : unselectedColor.withOpacity(0.5),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: fontSize.sp,
                        ),
                      ),
                      SizedBox(height: 6.w),
                      Container(
                        height: indicatorHeight.w,
                        width: indicatorWidth.w,
                        decoration: BoxDecoration(
                          color:
                              isSelected ? indicatorColor : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(indicatorHeight.w),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}
