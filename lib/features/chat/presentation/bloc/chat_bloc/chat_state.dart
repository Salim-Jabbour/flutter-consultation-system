part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class InitialChatSuccess extends ChatState {
  final MessageConsultationModel messageConsultationModel;

  InitialChatSuccess({required this.messageConsultationModel});
}

class InitialChatFailed extends ChatState {
  final Failure failure;

  InitialChatFailed({required this.failure});
}

class WebSocketConnected extends ChatState {}

class NewMessageState extends ChatState {
  final Message newMessage;

  NewMessageState(this.newMessage);
}
