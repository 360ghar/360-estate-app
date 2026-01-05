import 'package:estate_app/core/errors/failure.dart';

enum ViewStatus { idle, loading, success, empty, error }

final class ViewState<T> {
  const ViewState._({required this.status, this.data, this.failure});

  final ViewStatus status;
  final T? data;
  final Failure? failure;

  const ViewState.idle() : this._(status: ViewStatus.idle);

  const ViewState.loading() : this._(status: ViewStatus.loading);

  const ViewState.empty() : this._(status: ViewStatus.empty);

  const ViewState.success(T data)
      : this._(status: ViewStatus.success, data: data);

  const ViewState.error(Failure failure)
      : this._(status: ViewStatus.error, failure: failure);
}
