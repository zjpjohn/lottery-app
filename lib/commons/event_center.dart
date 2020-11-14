import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class AuthEvent {}

class UnAuthEvent {}

class LoginOutEvent {}

//专家修改事件
class ExpertEditEvent {}

//断网事件
class NotFoundEvent {}

//服务器错误事件
class ServerErrorEvent {}
