class ValidationConstants {
  static const emailRegExp = r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const passwordRegExp = r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]';

  static const int minNicknameLength = 2;
  static const int maxNicknameLength = 20;
  static const int minPasswordLength = 8;
}