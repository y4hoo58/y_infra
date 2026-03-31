class ValidatorMessages {
  final String required;
  final String invalidEmail;
  final String invalidPhone;
  final String invalidNumber;
  final String mismatch;
  final String Function(int min) minLength;
  final String Function(int min) passwordMinLength;

  const ValidatorMessages({
    this.required = 'This field is required',
    this.invalidEmail = 'Enter a valid email',
    this.invalidPhone = 'Enter a valid phone number',
    this.invalidNumber = 'Enter a valid number',
    this.mismatch = 'Values do not match',
    this.minLength = _defaultMinLength,
    this.passwordMinLength = _defaultPasswordMinLength,
  });

  static String _defaultMinLength(int min) => 'Minimum $min characters';
  static String _defaultPasswordMinLength(int min) =>
      'Password must be at least $min characters';
}
