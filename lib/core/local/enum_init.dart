abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;
}

class CachingKey extends Enum<String> {
  const CachingKey(super.val);
  static const String userData = 'userData';
  static const String isFirstInstall = 'isFirstInstall';
  static const String verified = 'verified';
  static const String isLogged = 'isLogged';
  static const String onBoarding = 'onBoarding';
  static const String settings = 'settings';
}
