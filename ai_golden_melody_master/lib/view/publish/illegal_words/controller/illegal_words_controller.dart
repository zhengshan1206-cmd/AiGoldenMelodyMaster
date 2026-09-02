import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/illegal_words_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import '../bean/illegal_words_bean.dart';
import 'package:flutter/services.dart';

class IllegalWordsController extends GetxController {
  Rx<String> content = ''.obs;

  /// 是否为输入模式，默认为false（显示模式）
  RxBool isEditMode = false.obs;

  /// 是否正在检测中，防止重复点击
  RxBool isDetecting = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// 切换编辑模式
  void toggleEditMode({Function? onEditModeChanged}) {
    isEditMode.value = !isEditMode.value;
    onEditModeChanged?.call();
  }

  /// 清空内容
  void clearContent() {
    content.value = '';
    bandedWords.value = [];
    selectedBandedWord.value = '';
  }

  /// 粘贴内容
  Future<void> pasteContent(Function(String) updateTextField) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        final currentText = content.value;
        final newText = currentText + clipboardData!.text!;

        // 检查字数限制
        if (newText.length <= 2000) {
          content.value = newText;
          updateTextField(newText);
        } else {
          EasyLoading.showToast('内容长度不能超过2000字');
        }
      } else {
        EasyLoading.showToast('剪贴板为空');
      }
    } catch (e) {
      EasyLoading.showToast('粘贴失败');
    }
  }

  /// 获取字数统计
  String getWordCount() {
    return "${content.value.length}";
  }

  /// 检查字数限制
  bool checkWordLimit(String text) {
    return text.length <= 2000;
  }

  /// 处理超出字数限制的文本
  String handleWordLimit(String text) {
    if (text.length > 2000) {
      EasyLoading.showToast('内容长度不能超过2000字');
      return text.substring(0, 2000);
    }
    return text;
  }

  ///违禁词列表
  RxList<String> bandedWords = <String>[].obs;
  updateBandedWords(List<String> words) {
    bandedWords.value = words;
  }

  ///选择的违禁词
  Rx<String> selectedBandedWord = "".obs;
  updateSelectedBandedWord(String word) {
    selectedBandedWord.value = word;
  }

  replaceWithInitialLetterOfPinyin({Function? onContentUpdated}) {
    if (bandedWords.isEmpty) return;

    for (var e in bandedWords) {
      content.value =
          content.value.replaceAll(e, PinyinHelper.getShortPinyin(e));
    }
    // 通知UI更新TextField
    onContentUpdated?.call();
  }

  /// 将选中的违禁词替换为[word]
  replaceWord(String word, Function call, {Function? onContentUpdated}) {
    if (selectedBandedWord.value.isEmpty) return;

    content.value = content.value.replaceAll(selectedBandedWord.value, word);
    // 通知UI更新TextField
    onContentUpdated?.call();
    // 执行回调
    call();
  }

  /// 更新违禁词列表（移除已替换的词）
  void updateBandedWordsAfterReplace(String replacedWord) {
    bandedWords.remove(replacedWord);
    if (bandedWords.isNotEmpty) {
      selectedBandedWord.value = bandedWords.first;
    } else {
      selectedBandedWord.value = '';
    }
  }

  ///违禁词检测 type-1 正常模式  type-0歌词检测模式
  Future<void> detectIllegalWords(
    String inPutContent, {
    void Function()? onSuccess,
    void Function()? onFail,
    void Function(String)? onSuccessValue,
    bool isFromDialog = false, // 添加参数标识是否来自弹窗内部
    int type = 1,
  }) async {
    // 防止重复检测
    if (isDetecting.value) {
      return;
    }

    isDetecting.value = true;
    content.value = inPutContent;

    try {
      await textRisk(
        content: inPutContent,
        onSuccess: (data) {
          print("违禁词信息__________:$data");
          final status = data["status"] ?? 0;
          if (status == -1 || status == 200) {
            final TextRiskBean riskBean = TextRiskBean.fromJson(data["data"]);
            final riskWords = riskBean.labelName;
            updateBandedWords(riskWords);
            print('违禁词列表_____--->>>$bandedWords');

            ///有违禁词
            if (bandedWords.isNotEmpty) {
              updateSelectedBandedWord(bandedWords.first);
              onFail?.call();
              // 如果是从弹窗内部调用的，不弹出新弹窗
              if (!isFromDialog) {
                showIllegalWordsDialog(
                  onSuccess: onSuccessValue,
                  type: type,
                );
              }
            } else {
              onSuccess?.call();

              /// 如果没有违禁词，也要调用onSuccessValue回调，传递当前内容
              if (onSuccessValue != null) {
                onSuccessValue(content.value);
              }
            }
          }
        },
      );
    } catch (e) {
      print('违禁词检测异常: $e');
      EasyLoading.showToast('检测失败，请重试');
    } finally {
      isDetecting.value = false;
    }
  }

  void showIllegalWordsDialog({
    void Function(String)? onSuccess,
    void Function()? onFail,
    int type = 1,
  }) {
    showDialog(
        context: Get.context!,
        useSafeArea: false,
        barrierDismissible: true,
        builder: (ctx) {
          return  IllegalWordsDialog(type: type,);
        }).then((value) {
      print('___AAA___$value');
      if (value != null) {
        if (value["content"] != null) {
          if (onSuccess != null) {
            onSuccess(value["content"]);
          }
        }
      }
    });
  }

  ///检测
  Future<void> textRisk({
    String? type,
    String? needMark,
    required String content,
    void Function(dynamic)? onSuccess,
  }) async {
    await HttpUtils.post(
      APIs.textRisk,
      {
        "type": type ?? "3",
        "needMark": needMark ?? "2",
        "labelType": "499001",
        "content": content,
      },
      forceData: true,
      success: (data) {
        onSuccess?.call(data);
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }
}
