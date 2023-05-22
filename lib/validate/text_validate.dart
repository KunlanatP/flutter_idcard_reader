String? errorTextEmailAddress(String? emailAddress) {
  if (emailAddress == null) {
    return null;
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailAddress)) {
    return 'please insert a valid email address';
  }
  return 'This field is required.';
}

String? validateTextPhoneNumber(String? phoneNumber) {
  if (phoneNumber == null) return null;
  return phoneNumber.replaceAllMapped(
    RegExp(r'^0'),
    (_) => '(+66) ',
  );
}
