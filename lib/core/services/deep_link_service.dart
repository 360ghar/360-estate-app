import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:estate_app/core/logger/app_logger.dart';

final class DeepLinkService {
  DeepLinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;
  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  StreamSubscription<Uri>? _sub;
  Uri? _lastUri;

  Stream<Uri> get uriStream => _controller.stream;
  Uri? get lastUri => _lastUri;

  void start() {
    _sub ??= _appLinks.uriLinkStream.listen(
      _handle,
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.w(
          'Deep link stream error',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );

    unawaited(
      _appLinks.getInitialLink().then((uri) {
        if (uri != null) _handle(uri);
      }).catchError((Object error, StackTrace stackTrace) {
        AppLogger.w(
          'Initial deep link error',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }

  void _handle(Uri uri) {
    _lastUri = uri;
    _controller.add(uri);
    AppLogger.i('Deep link received: ${uri.scheme}://${uri.host}${uri.path}');
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _controller.close();
  }
}
