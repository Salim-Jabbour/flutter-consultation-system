import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:akemha/core/resource/const_manager.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:akemha/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:akemha/features/chat/presentation/pages/chat_screen.dart';
import 'package:akemha/features/chat/repository/chat_repository.dart';

class InitChat extends StatefulWidget {
  static List<Message> messagesList = [
    Message(message: "message", createdAt: DateTime.now(), sendBy: "2")
  ];
  final UserLessResponse doctorModel;
  final UserLessResponse beneficiaryModel;
  final int consultationId;
  final String consultationTitle;
  const InitChat({
    super.key,
    required this.doctorModel,
    required this.beneficiaryModel,
    required this.consultationId,
    required this.consultationTitle,
  });

  @override
  State<InitChat> createState() => _InitChatState();
}

class _InitChatState extends State<InitChat> {
  late final ChatBloc _chatBloc;
  late final Future<void> _initializeWebSocketFuture;
  late final UserLessResponse currentUser;
  late final UserLessResponse chatUser;

  @override
  void initState() {
    _initializeWebSocketFuture = initializeWebSocket();
    detectCurrentUser();
    super.initState();
  }

  Future<void> initializeWebSocket() async {
    _chatBloc = ChatBloc(GetIt.I.get<ChatRepository>());
    _chatBloc.add(WebSocketConnectEvent(
        ConstManager
            .webSocketUrl, // TODO: try to swap between those + try to make one of them in future func to make async
        widget.consultationId));
    await _chatBloc.webSocketConnectionCompleter.future;
    _chatBloc.add(InitialMessagesEvent(
        //token + cosultaionId..to get the previous messages
        context.read<AuthBloc>().token ?? ApiService.token ?? '',
        widget.consultationId));
    setState(() {});
  }

  void detectCurrentUser() {
    String? currentUserId =
        context.read<AuthBloc>().userId ?? ApiService.userId;
    if (currentUserId == widget.doctorModel.id.toString()) {
      currentUser = widget.doctorModel;
      chatUser = widget.beneficiaryModel;
    } else {
      currentUser = widget.beneficiaryModel;
      chatUser = widget.doctorModel;
    }
  }

  @override
  void dispose() {
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: Scaffold(
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading || state is WebSocketConnected) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InitialChatFailed) {
              return const Center(child: Text('Failed to load messages'));
            } else if (state is InitialChatSuccess) {
              InitChat.messagesList =
                  state.messageConsultationModel.data.map((dataItem) {
                dbg("0000000000000000000000000000000000000000000000");
                dbg(dataItem.userLessResponse.id.toString());

                return Message(
                  id: dataItem.id.toString(),
                  message: dataItem.textMessage,
                  createdAt: DateTime.now(),
                  sendBy: dataItem.userLessResponse.id.toString(),
                );
              }).toList();
              return ChatScreen(
                client: _chatBloc.client!,
                consultatonId: widget.consultationId,
                currentUserModel: currentUser,
                chatUserModel: chatUser,
                title: widget.consultationTitle,
              );
            } else if (state is NewMessageState) {
              InitChat.messagesList.add(state.newMessage); //Don't delete this
              return ChatScreen(
                client: _chatBloc.client!,
                consultatonId: widget.consultationId,
                currentUserModel: currentUser,
                chatUserModel: chatUser,
                title: widget.consultationTitle,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
