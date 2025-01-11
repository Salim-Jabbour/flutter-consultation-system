import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:chatview/chatview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:akemha/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:akemha/features/chat/presentation/pages/init_chat.dart';
import 'package:akemha/features/chat/presentation/theme/app_theme.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final StompClient client;
  final int consultatonId;
  final UserLessResponse currentUserModel;
  final UserLessResponse chatUserModel;
  final String title;
  const ChatScreen({
    Key? key,
    required this.client,
    required this.consultatonId,
    required this.currentUserModel,
    required this.chatUserModel,
    required this.title,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppTheme theme = LightTheme();
  late ChatUser currentUser;
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
        id: context.read<AuthBloc>().userId ??
            ApiService.userId ??
            widget.currentUserModel.id.toString(), //'1', // logged in user_id
        name: widget.currentUserModel.name ?? 'User', // logged in user_name
        profilePhoto:
            widget.currentUserModel.profileImg ?? ConstManager.tempImage);
    // late ChatController _chatController;

    _chatController = ChatController(
      initialMessageList: InitChat.messagesList,
      scrollController: ScrollController(),
      chatUsers: [
        ChatUser(
            id: widget.chatUserModel.id
                .toString(), //widget.userDumbModel.id.toString(), //'2',
            name: widget.chatUserModel.name,
            profilePhoto: widget.chatUserModel.profileImg
            //"https://neweralive.na/storage/images/2023/may/lloyd-sikeba.jpg"
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // print("**************** IN SET STATEEEEEEEEEEE **************");
    });
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    return Scaffold(
      body: ChatView(
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: false,
          enableSwipeToReply: false,
          enableTextField: true,
          enableDoubleTapToLike: false,
          enablePagination: true,
          enableReactionPopup: false,
          enableReplySnackBar: false,
          enableSwipeToSeeTime: false,
        ),
        currentUser: currentUser,
        chatController: _chatController,
        onSendTap: (message, replyMessage, messageType) {
          _onSendTap(chatBloc, message, replyMessage, messageType);
          setState(() {});
        },
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),

        appBar: AppBar(
          backgroundColor: theme.appBarColor,
          title: Text(
              widget.title.length >= 20
                  ? "${widget.title.substring(0, 20)}.."
                  : widget.title,
              style: const TextStyle(
                color: ColorManager.c1,
                fontWeight: FontWeight.bold,
              )),
          elevation: 2,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
              // if (ApiService.userRole == "DOCTOR") {
              //   context.go("/doctorhome");
              //   widget.client.deactivate();
              // } else {
              //   context.go('/home');
              //   widget.client.deactivate();
              // }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: ColorManager.c2,
            ),
          ),
        ),

        //  ChatViewAppBar(
        //   onBackPress: () {
        //     context.go('/home');
        //     widget.client.deactivate();
        //   },
        //   elevation: theme.elevation,
        // backGroundColor: theme.appBarColor,
        //   // profilePicture: Data.profileImage, //TODO
        //   profilePicture: ConstManager.tempImage,
        //   backArrowColor: ColorManager.c2,
        //   chatTitle: "Chat view",
        //   //consultation name //TODO:
        //   chatTitleTextStyle: TextStyle(
        //     color: theme.appBarTitleTextStyle,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 18,
        //     letterSpacing: 0.25,
        //   ),
        // ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          // messageTimeIconColor: theme.messageTimeIconColor,
          // messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          allowRecordingVoice: false,
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          defaultSendButtonColor: ColorManager.c2,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            // contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: StringManager.message.tr(),
            onMessageTyping: (status) {
              /// Do with status
              debugPrint(status.toString());
            },
            hintStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w300),
            // compositionThresholdTime: const Duration(seconds: 1),
            textStyle: TextStyle(color: theme.textFieldTextColor),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: const ChatBubble(
            color: ColorManager.c2,
            receiptsWidgetConfig:
                ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
          ),
          inComingChatBubbleConfig: ChatBubble(
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              debugPrint('Message Read');
            },
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        // messageConfig: MessageConfiguration(
        //   imageMessageConfig: ImageMessageConfiguration(
        //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        //     shareIconConfig: ShareIconConfiguration(
        //       defaultIconBackgroundColor: Colors.amber,
        //       defaultIconColor: Colors.amber,
        //     ),
        //   ),
        // ),

        profileCircleConfig: const ProfileCircleConfiguration(
            profileImageUrl:
                "https://neweralive.na/storage/images/2023/may/lloyd-sikeba.jpg"
            // profileImageUrl: Data.profileImage, //TODO
            ),
      ),
    );
  }

  void _onSendTap(ChatBloc chatBloc, String message, ReplyMessage replyMessage,
      MessageType messageType) {
    dbg(InitChat.messagesList);
    dbg(widget.consultatonId);
    if (message.length > 500) {
      gShowErrorSnackBar(
        context: context,
        message: StringManager.longMessageError.tr(),
      );
      return;
    } else {
      chatBloc.add(SendMessageEvent(message, widget.consultatonId));
    }
    // _chatController.addMessage(Message(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   message: message,
    //   createdAt: DateTime.now(),
    //   sendBy: currentUser.id,
    // ));
    setState(() {});
  }
}
