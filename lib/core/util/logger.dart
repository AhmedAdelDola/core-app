import 'package:logger/logger.dart';

class PrintLog {
  static bool isDebug = true;

  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      levelEmojis: {
        Level.debug: '🐛',
        Level.error: '❌',
        Level.info: '📌',
        Level.off: '🔇',
        Level.warning: '⚠️',
        Level.fatal: '🤬',
        Level.all: '📢',
        Level.trace: '🔍',
      },
    ),
  );

  static void d(message) => logger.d(message);
  static void i(message) => logger.i(message);
  static void e(message) => logger.e(message);
  static void t(message) => logger.t(message);
  static void w(message) => logger.w(message);
  static void f(message) => logger.f(message);
}
