import 'package:logger/logger.dart';

class LoggerInstance {
  static final LoggerInstance _loggerInstance = LoggerInstance._internal();

  Logger? logger;

  factory LoggerInstance() => _loggerInstance;

  LoggerInstance._internal() {
    var prettyPrinter = PrettyPrinter(
      colors: true,
      printTime: false,
      printEmojis: false,
    );
    var prefixPrinter = PrefixPrinter(
      SimplePrinter(
        printTime: false,
        colors: false,
      ),
      verbose: "NETWORK",
    );
    logger = Logger(
      printer: prefixPrinter,
      // printer: prettyPrinter,
    );
  }
}

logD(Object message) {
  LoggerInstance().logger?.d(message);
}

logV(Object message) {
  LoggerInstance().logger?.v(message);
}

logW(Object message, {Object? e, StackTrace? stackTrace}) {
  LoggerInstance().logger?.w(message, e, stackTrace);
}

logE(Object message, {Object? e, StackTrace? stackTrace}) {
  LoggerInstance().logger?.e(message, e, stackTrace);
}

logI(Object message) {
  LoggerInstance().logger?.i(message);
}

logWTF(Object message, {Object? e, StackTrace? stackTrace}) {
  LoggerInstance().logger?.wtf(message, e, stackTrace);
}
