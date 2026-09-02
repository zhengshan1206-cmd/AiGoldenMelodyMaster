import '../model/ai_music/ai_music_detail_model.dart';

///一些公共事件
class CreateSampleEvent {
  final int mode;
  final MusicData musicData;
  const CreateSampleEvent({
    required this.mode,
    required this.musicData,
  });
}

///音乐播放器播放事件
// class PlayMusicDataEvent {
//   ///1 提示弹窗正在播放
//   final int type;
//   final bool isPlay;
//   PlayMusicDataEvent({
//      this.type = 1,
//     this.isPlay = true,
//   });
// }

class StopMusicButtonEvent {
  const StopMusicButtonEvent();
}

///登录成功事件
class LoginEvent {
  ///type-1 登录成功 type-0 退出登录
  final int type;
  const LoginEvent({
    this.type = 1,
  });
}

///网络异常处理
class NetworkErrorEvent {
  const NetworkErrorEvent();
}

class MasterRefreshAiHintText {
  const MasterRefreshAiHintText();
}

class RefreshMusicNoteEvent {
  const RefreshMusicNoteEvent();
}

///关闭键盘事件
class CloseKeyboardEvent {
  const CloseKeyboardEvent();
}

///音乐播放器 刷新数据事件 一般使用场景:用户首次引导进入
class RefreshMusicDataEvent {
  ///从哪个页面来的 0-作品管理
  final int type;
  ///音乐id
  final int musicId;
  ///是否第一次进入
  final bool isFirst;
  const RefreshMusicDataEvent({
    this.type = 0,
    this.musicId = 0,
    this.isFirst = false,
  });
}

///音乐播放器 播放事件 一般使用场景:用户首次引导进入
class PlayMusicDataEvent{
  const PlayMusicDataEvent();
}

///加载音乐数据事件
class LoadMusicDataEvent{

}


