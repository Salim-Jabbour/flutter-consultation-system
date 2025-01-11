import 'dart:async';
import 'dart:convert';
import 'package:akemha/core/errors/base_error.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:akemha/features/chat/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:meta/meta.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:dio/dio.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StompClient? client;
  final Completer<void> webSocketConnectionCompleter = Completer<void>();

  ChatBloc(this._chatRepository) : super(ChatInitial()) {
    on<InitialMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      final successOrFailure = await _chatRepository.getInitialMessages(
          event.token, event.consultationId);
      successOrFailure.fold((error) {
        emit(InitialChatFailed(failure: error));
      }, (messageConsultationModel) {
        emit(InitialChatSuccess(
            messageConsultationModel: messageConsultationModel));
      });
    });

    on<WebSocketConnectEvent>((event, emit) {
      client = StompClient(
        config: StompConfig(
          url: event.url,
          onConnect: (frame) {
            add(WebSocketConnectedEvent(event.consultationId));
            if (!webSocketConnectionCompleter.isCompleted) {
              webSocketConnectionCompleter.complete();
            }
          },
          onWebSocketError: (error) => print(error.toString()),
          onStompError: (frame) => print('STOMP error: ${frame.body}'),
          onDisconnect: (frame) => print('Disconnected'),
        ),
      );
      client!.activate();
    });

    on<WebSocketConnectedEvent>((event, emit) {
      client!.subscribe(
        destination: '/topic/consultation/${event.consultationId}/messages',
        callback: (StompFrame frame) {
          final body = json.decode(frame.body!);
          DataItem newItem = DataItem.fromJson(body);
          Message newMessage = convertDataItemToMessage(newItem);
          add(NewMessageReceivedEvent(newMessage));
        },
      );
      emit(WebSocketConnected());
    });

    on<NewMessageReceivedEvent>((event, emit) {
      emit(NewMessageState(event.newMessage));
    });

    on<SendMessageEvent>((event, emit) {
      client!.send(
        destination: '/app/consultation/${event.consultationId}/chat',
        body: json.encode({
          'textMsg': event.message,
          'userId': ApiService.userId ??
              1, // TODO: Replace with actual user ID. maybe I should out userId in event.
        }),
      );
    });
  }

  Message convertDataItemToMessage(DataItem dataItem) {
    return Message(
      id: dataItem.id.toString(),
      message: dataItem.textMessage,
      createdAt: DateTime.now(),
      sendBy: dataItem.userLessResponse.id.toString(),
    );
  }
}
