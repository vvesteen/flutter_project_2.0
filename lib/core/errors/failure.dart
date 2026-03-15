import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

// ─────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({String? message})
      : super(message: message ?? 'Ошибка сервера');
}

class CacheFailure extends Failure {
  const CacheFailure({String? message})
      : super(message: message ?? 'Ошибка кэша');
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message})
      : super(message: message ?? 'Нет соединения с интернетом');
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String? message})
      : super(message: message ?? 'Неизвестная ошибка');
}

// ─────────────────────────────
// Auth Failures
// ─────────────────────────────

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure()
      : super(message: 'Неверный email или пароль');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure()
      : super(message: 'Пользователь не найден');
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure()
      : super(message: 'Неверный пароль');
}

class AccountDisabledFailure extends Failure {
  const AccountDisabledFailure()
      : super(message: 'Аккаунт заблокирован');
}

class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure()
      : super(message: 'Email не подтверждён');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure()
      : super(message: 'Пароль слишком слабый');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure()
      : super(message: 'Email уже используется');
}