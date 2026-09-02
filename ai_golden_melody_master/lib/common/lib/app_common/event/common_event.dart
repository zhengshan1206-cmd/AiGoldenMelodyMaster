import 'event_bus.dart';

///公共eventBus 事件通知
final EventBus eventBus = EventBus();

///暂停video事件
class PauseVideoEvent {
  const PauseVideoEvent();
}

///切换到指定Tab事件
class SwitchTabEvent {
  final int tabIndex;
  const SwitchTabEvent({required this.tabIndex});
}
