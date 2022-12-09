String? validateString(String? value) {
  if (value != null) {
    if (value == '') {
      return 'This field is required.';
    }
    if (RegExp(r'(^\s)|(\s$)').hasMatch(value)) {
      return 'Shouldn\'t start with a blank. or shouldn\'t end with a space.';
    }
    if (RegExp(r'^[0-9]').hasMatch(value)) {
      return 'Shouldn\'t start with a number.';
    }
    if (RegExp(r'[ก-ฮ]').hasMatch(value)) {
      return 'Please use the English language only';
    }
    if (RegExp(r'[^a-zA-Z0-9]').hasMatch(value)) {
      return 'Cannot use special characters or blank space';
    }
    if (value.length > 50) {
      return 'Length of text must be between 1-50';
    }
  }
  return null;
}
