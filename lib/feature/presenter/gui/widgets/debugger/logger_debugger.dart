import 'package:logger/logger.dart';

mixin LoggerEvent {
  final logger = Logger();

  void debug(dynamic message) {
    logger.d(message);
  }

  void error(dynamic error) {
    logger.e(error);
  }

  void fatal(dynamic fatal) {
    logger.f(fatal);
  }
}
