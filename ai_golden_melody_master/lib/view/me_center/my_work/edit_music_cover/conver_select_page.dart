import 'dart:async';
import 'dart:ui';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import '../../../../model/ai_music/ai_music_cover.dart';
import '../../../../model/ai_music/ai_music_cover_model.dart';
import 'edit_music_cover_controller.dart';

///封面选择页面
class CoverSelectPage extends StatefulWidget {
  final AiMusicCoverTaskModel? musicCoverTaskModel;
  final DataDetailModel? dataDetailModel;
  const CoverSelectPage({
    super.key,
    this.musicCoverTaskModel,
    this.dataDetailModel,
  });

  @override
  State<CoverSelectPage> createState() => _CoverSelectPageState();
}

class _CoverSelectPageState extends State<CoverSelectPage> {
  EditMusicCoverController controller = Get.find<EditMusicCoverController>();

  /// 定时器实例
  Timer? _timer;

  /// 标记是否正在执行查询
  bool _isQuerying = false;

  ///功能区
  Widget _functionAreaView() {
    return Row(
      children: [
        Opacity(
            opacity: (couldUse || isFailure) ? 1 : 0.3,
            child: InkResponse(
              onTap: () {
                if (couldUse || isFailure) {
                  controller.deleteCover(id: aiMusicCoverModel!.id);
                }
              },
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: 12.w,
                ),
                child: Image.asset(
                  Assets.deleteIcon3,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            )),
        Opacity(
            opacity: couldUse ? 1 : 0.3,
            child: InkResponse(
              onTap: () {
                if (couldUse) {
                  controller.downloadCover(
                      coverUrl: aiMusicCoverModel!.coverUrl);
                }
              },
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: 12.w,
                ),
                child: Image.asset(
                  Assets.icon18,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            )),
        Opacity(
            opacity: couldUse ? 1 : 0.3,
            child: InkResponse(
              onTap: () {
                if (couldUse) {
                  controller.useCover(
                      id: aiMusicCoverModel!.id,
                      coverUrl: aiMusicCoverModel!.coverUrl);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ByColorUtil.color00CB64,
                  borderRadius: BorderRadius.circular(12.w),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: 13.w,
                  bottom: 13.w,
                  left: 86.w,
                  right: 86.w,
                ),
                margin: EdgeInsets.only(
                  left: 10.w,
                ),
                child: Text(
                  "确认使用",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  /// 开始定时查询 (5秒间隔)
  void startQuerying() {
    /// 先取消已有的定时器，避免重复
    stopQuerying();

    /// 立即执行一次查询，再开始定时
    _performQuery();

    // 启动周期性定时器
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _performQuery();
    });
  }

  /// 停止定时查询
  void stopQuerying() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// 执行实际的查询任务
  Future<void> _performQuery() async {
    // 防止并发请求
    if (_isQuerying) return;

    _isQuerying = true;
    try {
      HttpUtils.get(
        APIs.aiTaskQuery,
        {
          "data_id": musicCoverTaskModel!.dataId,
          "task_id": musicCoverTaskModel!.taskId,
        },
        success: (data) {
          ///0.审核中, 1.通过 2.未过
          aiMusicCoverModel = AiMusicCoverModel.fromJson(json: data["data"]);

          if (aiMusicCoverModel!.audit == 1) {
            stopQuerying();
            couldUse = true;
          } else if (aiMusicCoverModel!.audit == 2) {
            isFailure = true;
            stopQuerying();
          }

          if (mounted) {
            setState(() {});
          }

          Get.log("查询任务成功请求下来的数据===> $data");
        },
        fail: (code, msg) {
          stopQuerying();
          Get.log("查询任务失败请求下来的数据===> $msg $code");
        },
      );
    } catch (e) {
      // 捕获所有可能的错误 (网络错误、解析错误等)
    } finally {
      _isQuerying = false;
    }
  }

  /// 释放资源
  void disposeTimer() {
    stopQuerying();
  }

  ///定时任务查询结果
  AiMusicCoverModel? aiMusicCoverModel;

  bool couldUse = false;

  ///任务查询model
  AiMusicCoverTaskModel? musicCoverTaskModel;

  bool needQuery = false;

  bool isFailure = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposeTimer();
  }

  initData() {
    ///来自于历史记录详细数据
    if (widget.dataDetailModel != null) {
      aiMusicCoverModel = AiMusicCoverModel(
        coverUrl: widget.dataDetailModel!.coverUrl,
        id: widget.dataDetailModel!.id,
        audit: widget.dataDetailModel!.audit,
        status: widget.dataDetailModel!.status,
      );
      musicCoverTaskModel = AiMusicCoverTaskModel(
          dataId: widget.dataDetailModel!.id,
          taskId: widget.dataDetailModel!.taskId);

      if (aiMusicCoverModel!.audit == 0) {
        needQuery = true;
      } else if (aiMusicCoverModel!.audit == 1) {
        couldUse = true;
      } else if (aiMusicCoverModel!.audit == 2) {
        isFailure = true;
      }
    }

    ///来自于任务数据
    if (widget.musicCoverTaskModel != null) {
      musicCoverTaskModel = widget.musicCoverTaskModel;
      needQuery = true;
    }

    if (needQuery) {
      startQuerying();
    }

    setState(() {});
  }

  Widget _dataView() {
    if (aiMusicCoverModel != null) {
      if (aiMusicCoverModel!.status == 0) {
        return _loadingView();
      } else if (aiMusicCoverModel!.status == 1) {
        return CachedNetworkImage(
          imageUrl: (aiMusicCoverModel!.coverUrl),
          width: 1.sw,
          height: 375.w,
        );
      } else if (aiMusicCoverModel!.status == 2) {
        return _failureView();
      }
    }

    if (musicCoverTaskModel != null) {
      return _loadingView();
    }

    return const SizedBox();
  }

  ///进度中的提示区域
  Widget _loadingView() {
    return Stack(
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              width: 1.sw,
              height: 375.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Image.asset(
                Assets.aiMusicBackground,
                width: 1.sw,
                height: 375.w,
              ),
            ),
          ),
        ),
        Positioned(
          top: 121.w,
          left: 148.w,
          child: Column(
            children: [
              Image.asset(
                Assets.icon17,
                width: 80.w,
                height: 80.w,
              ),
              Text(
                "生成中...",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  ///生成失败的区域
  Widget _failureView() {
    return Container(
      width: 1.sw,
      height: 375.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.icon19,
            width: 52.w,
            height: 52.w,
          ),
          SizedBox(
            height: 16.w,
          ),
          Text(
            "封面生成失败，音符值已退回",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          InkResponse(
            onTap: () {
              /// 重新生成事件
              restartCreate(id: aiMusicCoverModel!.id);
            },
            child: Container(
              width: 88.w,
              height: 28.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(8.w),
              ),
              alignment: Alignment.center,
              child: Text(
                "重新生成",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  restartCreate({
    required int id,
  }) async {
    Get.log("===重新生成=== ${aiMusicCoverModel?.id}");
    HttpUtils.post(APIs.restartAiCover, {
      "id": id,
    }, success: (data) {
      ///todo 重新请求成功
      if(mounted){
        setState(() {
          aiMusicCoverModel!.audit = 0;
          isFailure = false;
        });
      }
      startQuerying();
    }, fail: (msg, code) {
      EasyLoading.showToast(code, maskType: EasyLoadingMaskType.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          color: ByColorUtil.color121212,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 56.w,
              ),
              InkResponse(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 75.w,
              ),
              _dataView(),
              const Spacer(),
              _functionAreaView(),
              SizedBox(
                height: 35.w,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
