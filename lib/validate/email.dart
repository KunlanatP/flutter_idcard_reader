String? errorTextEmailAddress(String? emailAddress) {
  if (emailAddress != null) {
    if (emailAddress == '') {
      return 'This field is required.';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailAddress)) {
      return 'please insert a valid email address';
    }
  }
  return null;
}
