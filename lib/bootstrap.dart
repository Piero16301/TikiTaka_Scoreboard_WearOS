import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      log('onChange(${bloc.runtimeType}, $change)');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    }
    getIt<CrashService>().recordError(
      error,
      stackTrace,
      reason: 'Bloc: ${bloc.runtimeType}',
    );
    super.onError(bloc, error, stackTrace);
  }
}

bool _isNetworkError(dynamic error) {
  const networkErrors = [
    'socketexception',
    'handshakeexception',
    'httpexception',
    'timeoutexception',
    'clientexception',
    'networkimageloadexception',
  ];
  final errorString = error.toString().toLowerCase();
  return networkErrors.any(errorString.contains);
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    if (_isNetworkError(details.exception)) {
      if (kDebugMode) {
        log(
          'Network error suppressed from Crashlytics: '
          '${details.exceptionAsString()}',
        );
      }
      return;
    }

    if (kDebugMode) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    }
    getIt<CrashService>().recordError(
      details.exception,
      details.stack,
      reason: details.context?.toString(),
      fatal: true,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (_isNetworkError(error)) {
      if (kDebugMode) {
        log('Network error suppressed from Crashlytics: $error');
      }
      return true;
    }

    if (kDebugMode) {
      log(error.toString(), stackTrace: stack);
    }
    getIt<CrashService>().recordError(error, stack, fatal: true);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  getIt<CrashService>().log('Bootstrap started');
  final performance = getIt<PerformanceService>();
  final trace = performance.startTrace('bootstrap_process');

  runApp(await builder());
  performance.stopTrace(trace);
}
