import 'dart:developer';

void dbg(Object? o) {
  log(
    o?.toString()??'null',
  );
}

void dbgt(String? tag, Object? o) {
  log(
    "${tag?.toString()}: ${o?.toString() ?? 'null'}",
  );
}

// enum LogLevel { info, warning, error, debug, wtf, success, fail, todo }

// /// A Calculator.
// class ColorLog {
//   // final String _reset = '\x1B[0m';
//   final String _red = '\x1B[31m';
//   final String _green = '\x1B[32m';
//   final String _yellow = '\x1B[33m';
//   // final String _bold = '\x1B[1m';
//   final String _cyan = '\x1b[36m';
//   // final String _purple = '\x1B[35m';
//   final String _pink = "\x1b[38;5;205m";
//
//   /// To get information about something
//   ///
//   /// The log color will be cyan
//   void info(String message) {
//     printTheMessage(
//         color: _cyan,
//         emoji: "⛅",
//         message: message,
//         logType: LogLevel.info.name);
//   }
//
//   /// To log sometype of warning
//   ///
//   /// The log color will be yellow
//   void warning(String message) {
//     printTheMessage(
//         color: _yellow,
//         emoji: "🐢",
//         message: message,
//         logType: LogLevel.warning.name);
//   }
//
//   /// To log error in red color always rethrow or throw after using `error` log to get the stacktrace in the console
//   ///
//   /// The log color will be Red
//   void error(String message) {
//     printTheMessage(
//         color: _red,
//         emoji: "⛔",
//         message: message,
//         logType: LogLevel.error.name);
//   }
//
//   /// For temporary debuging the app, remove this after debig
//   ///
//   /// The log color will be yellow
//   void debug(String message) {
//     printTheMessage(
//         color: _yellow,
//         emoji: "🚧",
//         message: message,
//         logType: LogLevel.debug.name);
//   }
//
//   // ///WTF is to track
//   // ///
//   // /// The log color will be yellow
//   // void wtf(String message) {
//   //   printTheMessage(
//   //       color: _red, emoji: "⛔", message: message, logType: LogLevel.wtf.name);
//   // }
//
//   ///To log boolean check operation
//   ///
//   ///IF true the color will be green else color will be red
//   checkSuccess(bool isSuccess, String message) {
//     if (isSuccess) {
//       printTheMessage(
//           color: _green, emoji: "✅", message: message, logType: "TRUE");
//     } else {
//       printTheMessage(
//           color: _red, emoji: "❌", message: message, logType: "FALSE");
//     }
//   }
//
//   ///To log todo check operation
//   ///
//   ///This will always remind your todo in log
//   todo(String message) {
//     printTheMessage(
//         color: _pink,
//         emoji: "📝",
//         message: message,
//         logType: LogLevel.todo.name);
//   }
//
//   ///This is a custom log
//   ///
//   ///Need to add all the custom properties
//   void custom(
//       {required String message,
//         required String emoji,
//         required String ansiColor,
//         required String logType}) {
//     printTheMessage(
//         color: ansiColor, emoji: emoji, message: message, logType: logType);
//   }
// }
//
// /// Print in color and emoji
// printTheMessage(
//     {String emoji = "✅",
//       String message = "",
//       String color = '\x1B[0m',
//       String logType = "info"}) {
//   if (kDebugMode) {
//     String bold = '\x1B[1m';
//     String normal = '\x1B[0m';
//     String reset = '\x1B[0m';
//
//     print('$color$bold ---------------------------------------------');
//
//     print(
//         '$emoji $color$bold[${logType.toUpperCase()}]:$normal$color $message$reset');
//     // print(
//     //     '$color$bold --------------------------------------------------------------');
//   }
// }
//
// ColorLog clog = ColorLog();