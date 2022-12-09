String convertGender(int? gender) {
  switch (gender) {
    case 1:
      return 'ชาย';
    case 2:
      return 'หญิง';
    default:
      return 'ชาย';
  }
}
