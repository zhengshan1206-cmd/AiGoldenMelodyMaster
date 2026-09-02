import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class ImageUriConverter {
  /// 将图片Uint8List转换为本地URI
  static Future<String?> convertToLocalUri(
      Uint8List imageData, {
        String format = 'png',
        bool isTemporary = true,
      }) async {
    try {
      if (imageData.isEmpty) {
        throw ArgumentError("图片数据不能为空");
      }
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(format.toLowerCase())) {
        throw ArgumentError("不支持的图片格式: $format");
      }

      final String fileName = _generateUniqueFileName(format);
      final Directory directory = isTemporary
          ? await getTemporaryDirectory()
          : await getApplicationDocumentsDirectory();

      final File imageFile = File('${directory.path}/$fileName');
      await imageFile.writeAsBytes(imageData);

      // 生成URI（包含file://前缀，用于展示等场景）
      return imageFile.uri.toString();
    } catch (e) {
      print('图片转换为本地URI失败: $e');
      return null;
    }
  }

  /// 生成唯一文件名
  static String _generateUniqueFileName(String format) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000).toString().padLeft(3, '0');
    return 'img_${timestamp}_$random.${format.toLowerCase()}';
  }

  /// 修复：根据URI删除本地图片文件（正确处理file://前缀）
  static Future<bool> deleteImageByUri(String uri) async {
    try {
      // 关键修复：将URI转换为纯文件路径（去掉file://前缀）
      final String filePath = Uri.parse(uri).toFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print('删除图片文件失败: $e');
    }
    return false;
  }

  /// 新增：检查文件是否存在（用于调试）
  static Future<bool> checkFileExists(String uri) async {
    try {
      final String filePath = Uri.parse(uri).toFilePath();
      return await File(filePath).exists();
    } catch (e) {
      print('检查文件存在性失败: $e');
      return false;
    }
  }
}
