String? errorTextUsername(String? username) {
  if (username != null) {
    if (username == '') {
      return 'This field is required.';
    }
    if (RegExp(r'(^\s)|(\s$)').hasMatch(username)) {
      return 'Shouldn\'t start with a blank. or shouldn\'t end with a space.';
    }
    if (RegExp(r'^[0-9]').hasMatch(username)) {
      return 'Shouldn\'t start with a number.';
    }
    if (RegExp(r'[ก-ฮ]').hasMatch(username)) {
      return 'Please use the English language only';
    }
    if (RegExp(r'[^a-zA-Z0-9]').hasMatch(username)) {
      return 'Cannot use special characters or blank space';
    }
    if (username.length > 50) {
      return 'Length of text must be between 1-50';
    }
  }
  return null;
}
