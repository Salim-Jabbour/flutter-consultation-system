part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class InitialMessagesEvent extends ChatEvent {
  final String token;
  final int consultationId;

  InitialMessagesEvent(this.token, this.consultationId);
}

class WebSocketConnectEvent extends ChatEvent {
  final String url;
  final int consultationId;

  WebSocketConnectEvent(this.url, this.consultationId);
}

class WebSocketConnectedEvent extends ChatEvent {
  final int consultationId;

  WebSocketConnectedEvent(this.consultationId);
}

class NewMessageReceivedEvent extends ChatEvent {
  final Message newMessage;

  NewMessageReceivedEvent(this.newMessage);
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final int consultationId;

  SendMessageEvent(this.message, this.consultationId);
}
