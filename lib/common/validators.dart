final _emailRegExp =
    RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$'); // simple, practical

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!_emailRegExp.hasMatch(value.trim())) return 'Enter a valid email';
  return null;
}

/// Password: at least 8 chars, includes a letter and a number.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 8) return 'Min 8 characters';
  if (!RegExp(r'[A-Za-z]').hasMatch(value)) return 'Include at least one letter';
  if (!RegExp(r'\d').hasMatch(value)) return 'Include at least one number';
  return null;
}