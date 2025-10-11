import 'package:xrp_monitor_flutter_admin/constants/validation.constants.dart';
import 'package:xrp_monitor_flutter_admin/constants/strings.dart';

class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegExp = RegExp(ValidationConstants.emailRegExp);
    if (!emailRegExp.hasMatch(value)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? nicknameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nicknameRequired;
    }
    if (value.length < ValidationConstants.minNicknameLength) {
      return AppStrings.nicknameTooShort(ValidationConstants.minNicknameLength);
    }
    if (value.length > ValidationConstants.maxNicknameLength) {
      return AppStrings.nicknameTooLong(ValidationConstants.maxNicknameLength);
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < ValidationConstants.minPasswordLength) {
      return AppStrings.passwordTooShort(ValidationConstants.minPasswordLength);
    }
    final passwordRegExp = RegExp(ValidationConstants.passwordRegExp);
    if (!passwordRegExp.hasMatch(value)) {
      return AppStrings.passwordInvalid;
    }
    return null;
  }

  static String? simplePasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordConfirmRequired;
    }
    if (value != password) {
      return AppStrings.passwordNotMatch;
    }
    return null;
  }

  // Custom validators
  static String? quantityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.quantityRequired;
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return AppStrings.quantityInvalid;
    }
    return null;
  }

  static String? averagePriceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.averagePriceRequired;
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return AppStrings.averagePriceInvalid;
    }
    return null;
  }
}