import 'package:flutter_idcard_reader/models/user_model.dart';
import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';

final mockPeopleData = ThaiIDCard(
  cid: '1419901758925',
  titleTH: 'น.ส.',
  firstnameTH: 'กุลณัฐ',
  lastnameTH: 'ปะกิเน',
  titleEN: 'Miss',
  firstnameEN: 'Kunlanat',
  lastnameEN: 'Pakine',
  address: '204 หมู่ที่6 ตำบลตูมใต้ อำเภอกุมภวาปี จังหวัดอุดรธานี',
  birthdate: '1998-03-30',
  issueDate: '2020-11-02',
  expireDate: '2029-03-29',
  gender: 2,
);

final mockUserData = UserModel(
  id: "60f781a4-3f29-4616-954a-7fffeeb47735",
  idCard: "1234567890123",
  firstname: "Admin",
  lastname: "Admin",
  mobile: "0123456789",
  email: "admin123@gmail.com",
  rank: "Admin",
  affiliation: "Admin",
  status: "Admin",
);
