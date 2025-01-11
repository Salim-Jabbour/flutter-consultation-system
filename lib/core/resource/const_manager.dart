import 'package:akemha/core/resource/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../features/supervision/model/supervision_model.dart';

class ConstManager {
  static String baseUrl = 'https://spring-boot-akemha.onrender.com/';
  static String webSocketUrl = 'ws://spring-boot-akemha.onrender.com/ws';

  // static String baseUrl = 'http://10.0.2.2:8090/';
  // static String webSocketUrl = 'ws://10.0.2.2:8090/ws';

  // salimo
  // static String baseUrl = 'http://192.168.211.227:8090/';
  // static String baseUrlImage = 'https://mall.yaakoot.com.au';

  // static String baseUrl = 'http://10.0.2.2:8090/';

  // salim's IPS
  // static String baseUrl = 'http://192.168.1.105:8090/';
  // static String webSocketUrl = 'ws://192.168.1.105:8090/ws';
  // static String baseUrl = 'http://192.168.1.107:8090/';
  // static String webSocketUrl = 'ws://192.168.1.107:8090/ws';
  // static String baseUrl = 'http://192.168.43.101:8090/';
  // static String baseUrl = 'http://192.168.80.227:8090/';
  // home
  // static String baseUrl = 'http://192.168.1.106:8090/';
  // static String webSocketUrl = 'ws://192.168.1.106:8090/ws';
  // Sami's home
  // static String baseUrl = 'http://192.168.1.108:8090/';
  // static String webSocketUrl = 'ws://192.168.1.108:8090/ws';
  // mobile
  // static String baseUrl = 'http://192.168.43.248:8090/';
  // static String webSocketUrl = 'http://192.168.43.248:8090/ws';
  //
  // static String baseUrl = 'http://192.168.209.227:8090/';
  // static String webSocketUrl = 'http://192.168.209.227:8090/ws';
  //
  // static String baseUrl = 'http://192.168.80.227:8090/';
  // static String webSocketUrl = 'ws://192.168.80.227:8090/ws';

  static final List<Widget> pageOptions = [
    // const HomePage(),
    // const MyCartPage(),
    // const FavoritePage(),
    // const ProfilePage()
  ];
  static const List<String> specializations = [
    StringManager.general,
    StringManager.neurological,
    StringManager.digestive,
    StringManager.chest
  ];
  static PaintingEffect kEffect = const PulseEffect();

  static final UserLessResponseModel userModel = UserLessResponseModel(
    id: 0,
    name: "Akemha",
    email: 'Akemha@email.com',
    profileImg:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMDUP9O9BQAw8-2WxkfCUZ_2iBoAc4xvmQDMFab_hi-Q&s",
  );

  static const String tempImage =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMDUP9O9BQAw8-2WxkfCUZ_2iBoAc4xvmQDMFab_hi-Q&s";
}

enum PageState {
  loading,
  loaded,
  finished,
}
