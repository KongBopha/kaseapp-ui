import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return message;
  }
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });

  @override
  List<Object> get props => [];
}

class UnAuthorizedRequest extends Failure {
  const UnAuthorizedRequest({
    required super.message,
  });

  @override
  List<Object?> get props => [message];
}

class RequestTimeOutFailure extends Failure {
  const RequestTimeOutFailure({
    required super.message,
  });

  @override
  List<Object?> get props => [];
}

class ServerDown extends Failure {
  const ServerDown({
    required super.message,
  });

  @override
  List<Object?> get props => [];
}

class MappingFailure extends Failure {
  const MappingFailure({
    required super.message,
  });

  @override
  List<Object?> get props => [message];
}

class UnknownResponse extends Failure {
  const UnknownResponse({
    required super.message,
  });

  @override
  List<Object?> get props => [];
}

class InvalidRequest extends Failure {
  const InvalidRequest({required super.message});

  @override
  List<Object?> get props => [message];
}

class ConvertToDateFailure extends Failure {
  const ConvertToDateFailure({
    required super.message,
  });

  @override
  List<Object?> get props => [];
}

class NoInternetConnection extends Failure {
  const NoInternetConnection({required super.message});

  @override
  List<Object?> get props => [];
}
