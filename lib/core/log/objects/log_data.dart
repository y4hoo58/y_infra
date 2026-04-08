import 'package:http/http.dart';

import 'log_level.dart';

/// Base class for structured log entries carrying a message and [LogLevel].
abstract class LogData {
  const LogData();

  int get timestamp => DateTime.now().microsecondsSinceEpoch;
  String get timeAsString => "[${DateTime.now()}]";
  String get message;
  LogLevel get level;
}

class EndpointResponseLogData extends LogData {
  final Uri url;
  final Response response;

  const EndpointResponseLogData(this.response, this.url);

  @override
  String get message {
    final statusCode = response.statusCode;
    return "Url->${url.toString()}||Status Code->$statusCode";
  }

  @override
  LogLevel get level => LogLevel.debug;
}

class NetworkResponseLogData extends LogData {
  final Response response;
  final int maxLength;

  const NetworkResponseLogData(this.response, {this.maxLength = 1000});

  @override
  String get message {
    var m = "Status Code->${response.statusCode}||Body->${response.body}";
    return m.substring(0, m.length > maxLength ? maxLength : m.length);
  }

  @override
  LogLevel get level => LogLevel.debug;
}

class DebugLogData extends LogData {
  final String _message;

  const DebugLogData(this._message);

  @override
  String get message => _message;

  @override
  LogLevel get level => LogLevel.debug;
}

class ApiRequestLogData extends LogData {
  final Type type;
  final String endpoint;

  const ApiRequestLogData(this.type, this.endpoint);

  @override
  String get message => "$type<->$endpoint";

  @override
  LogLevel get level => LogLevel.debug;
}

class EventLogData extends LogData {
  final String _message;

  const EventLogData(this._message);

  @override
  LogLevel get level => LogLevel.event;

  @override
  String get message => _message;
}

class VarInfoLogData extends LogData {
  final String? prefix;
  final String? suffix;
  final Map<String, dynamic> varMap;

  const VarInfoLogData(this.varMap, {this.prefix, this.suffix});

  @override
  String get message {
    String m = "";
    if (prefix != null) m += prefix!;
    varMap.forEach((key, value) {
      m += "$key->$value";
      if (varMap.keys.last != key) m += "||";
    });
    if (suffix != null) m += suffix!;
    return m;
  }

  @override
  LogLevel get level => LogLevel.value;
}

class MethodCallLogData extends LogData {
  final String className;
  final String methodName;
  final String? _extraMessage;

  const MethodCallLogData(this.className, this.methodName, {String? message})
      : _extraMessage = message;

  @override
  LogLevel get level => LogLevel.debug;

  @override
  String get message {
    if (_extraMessage == null) return "$className<-$methodName";
    return "$className<-$methodName->$_extraMessage";
  }
}

class ErrorLogData extends LogData {
  final String className;
  final String methodName;
  final Type errorType;
  final String? _extraMessage;

  const ErrorLogData(
    this.className,
    this.methodName,
    this.errorType, {
    String? message,
  }) : _extraMessage = message;

  @override
  String get message {
    if (_extraMessage == null) return "$className<-$methodName->$errorType";
    return "$className<-$methodName->$errorType:$_extraMessage";
  }

  @override
  LogLevel get level => LogLevel.error;
}

class NavigationLogData extends LogData {
  final String baseRoute;
  final String targetRoute;

  const NavigationLogData(this.baseRoute, this.targetRoute);

  @override
  String get message => "[NAVIGATION]$baseRoute-->$targetRoute";

  @override
  LogLevel get level => LogLevel.event;
}
