abstract class NetworkStates {
  const NetworkStates();
}

class NoErrorState extends NetworkStates {}

class SocketErrorState extends NetworkStates {
  final String error;

  const SocketErrorState(this.error);
}

class ClientErrorState extends NetworkStates {
  final String error;

  const ClientErrorState(this.error);
}

class ServerErrorState extends NetworkStates {
  final String error;

  const ServerErrorState(this.error);
}

class UnauthenticatedState extends NetworkStates {
  final String error;

  UnauthenticatedState(this.error);
}

class StudentBannedNetworkState extends NetworkStates {
  final String message;
  const StudentBannedNetworkState(this.message);
}

class ErrorState extends NetworkStates {
  final String error;

  const ErrorState(this.error);
}

class AppUpdateRequiredState extends NetworkStates {
  final String message;
  final String? updateUrlAndroid;
  final String? updateUrlIos;

  const AppUpdateRequiredState(
    this.message, {
    this.updateUrlAndroid,
    this.updateUrlIos,
  });
}

class AppInternetDisconnectedState extends NetworkStates {
  const AppInternetDisconnectedState();
}

class AppInternetRestoredState extends NetworkStates {
  const AppInternetRestoredState();
}

