import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Base controller that automatically manages stream subscriptions.
///
/// Use this controller when you need to subscribe to streams and ensure
/// they are properly cancelled when the controller is disposed.
///
/// Example:
/// ```dart
/// class MyController extends DisposableController {
///   final Stream<String> _myStream;
///
///   @override
///   void onInit() {
///     super.onInit();
///     addSubscription(_myStream.listen((data) {
///       // Handle data
///     }));
///   }
/// }
/// ```
abstract base class DisposableController extends GetxController {
  final List<StreamSubscription> _subscriptions = [];

  /// Add a stream subscription to be automatically cancelled on disposal.
  ///
  /// This ensures that streams are properly cleaned up when the controller
  /// is removed from memory, preventing memory leaks.
  @protected
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Add multiple stream subscriptions at once.
  @protected
  void addSubscriptions(Iterable<StreamSubscription> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  @override
  void onClose() {
    // Cancel all subscriptions in reverse order (LIFO)
    for (var i = _subscriptions.length - 1; i >= 0; i--) {
      final sub = _subscriptions[i];
      unawaited(sub.cancel());
    }
    _subscriptions.clear();
    super.onClose();
  }
}
