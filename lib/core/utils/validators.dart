class AppValidators {
  AppValidators._();

  static String? validateRequired(String? value, {required String fieldName}) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter $fieldName';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter email';
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter password';
    }

    if (trimmedValue.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter phone number';
    }

    final phoneRegex = RegExp(r'^[0-9+()\-\s]+$');

    if (!phoneRegex.hasMatch(trimmedValue) || trimmedValue.length < 8) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
