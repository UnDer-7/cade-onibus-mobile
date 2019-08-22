import 'package:f_logs/model/flog/flog.dart';
import 'package:f_logs/model/flog/flog_config.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:f_logs/utils/formatter/formate_type.dart';
import 'package:meta/meta.dart';

class LoggerService {
  final String _className;
  LoggerService(this._className) {
    final config = LogsConfig()
      ..formatType = FormatType.FORMAT_SQUARE
      ..isDebuggable = true;

    FLog.applyConfigurations(config);
  }

  void info({
      @required final String methodName,
      @required final String text,
  }) {
    FLog.info(
        className: _className,
        methodName: methodName,
        text: text);
  }

  void error({
      @required final String methodName,
      @required final String text,
      @required final Exception exception
  }) {
    FLog.error(
        className: _className,
        methodName: methodName,
        exception: exception,
        text: text);
  }

  Future<void> exportLogs() async {
    return await FLog.exportLogs();
  }

  Future<void> clearLogs() async {
    return await FLog.clearLogs();
  }
}
