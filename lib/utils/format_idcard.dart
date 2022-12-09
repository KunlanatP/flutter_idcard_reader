String formattedIDCard(String? idcard) {
  if (idcard == null) return 'xxxxxxxxxxxxx';
  final group1 = idcard.substring(0, 1);
  final group2 = idcard.substring(1, 5);
  final group3 = idcard.substring(5, 10);
  final group4 = idcard.substring(10, 12);
  final group5 = idcard.substring(12, 13);

  return '$group1 $group2 $group3 $group4 $group5';
}
