import 'dart:convert';
import 'dart:io';

import 'package:drop_shadow/drop_shadow.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_idcard_reader/themes/colors.dart';
import 'package:flutter_idcard_reader/utils/format_date.dart';
import 'package:flutter_idcard_reader/utils/gender_convert.dart';
import 'package:flutter_idcard_reader/widgets/alert_dialog.dart';
import 'package:flutter_idcard_reader/widgets/btn_language.dart';
import 'package:flutter_idcard_reader/widgets/custom_on_click.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/mock_data.dart';
import '../models/location_model.dart';
import '../models/model.dart';
import '../models/people_model.dart';
import '../validate/phone_formatter.dart';

class IDCardDetailPage extends StatefulWidget {
  final ThaiIDCard? thaiIDCard;
  final Position? position;

  const IDCardDetailPage({
    super.key,
    required this.thaiIDCard,
    required this.position,
  });

  @override
  State<IDCardDetailPage> createState() => _IDCardDetailPageState();
}

class _IDCardDetailPageState extends State<IDCardDetailPage> {
  final imagePicker = ImagePicker();
  final _mobileTxt = TextEditingController();

  List<XFile>? imageFileList = [];

  Future<void> selectImages() async {
    final selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList?.addAll(selectedImages);
    }
    setState(() {});
  }

  Future<void> cameraImages() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    imageFileList?.add(image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final language = AppLocalizations.of(context)!;

    final appBar = AppBar(
      title: Text(
        'Card Reader',
        style: GoogleFonts.inter(
          color: const Color(0xFF333335),
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Image.asset('assets/images/ship.png'),
      ),
      actions: const [LanguageButtonWidget()],
    );

    final appBarHeight = appBar.preferredSize.height;

    Future<void> showAlertDialog({Widget? content}) => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.only(),
              content: SizedBox(
                height: height / 2,
                width: width < 390 ? width : 390,
                child: content,
              ),
            );
          },
        );

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: appBar,
        body: Center(
          child: Container(
            height: (constraints.maxHeight < 853 ? height : 853) - appBarHeight,
            width: constraints.maxWidth < 390 ? width : 390,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: constraints.maxWidth >= 390 ? 50 : 30),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      DropShadow(
                        child: widget.thaiIDCard?.photo == null ||
                                widget.thaiIDCard!.photo.isEmpty
                            ? Image.asset('assets/images/default.png', scale: 3)
                            : Image.memory(
                                Uint8List.fromList(widget.thaiIDCard!.photo),
                              ),
                      ),
                      SizedBox(
                        height: 200,
                        width: 170,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blueAccent.withAlpha(200),
                            ),
                            child: IconButton(
                              onPressed: () => showAlertDialog(
                                content: widget.thaiIDCard?.photo == null ||
                                        widget.thaiIDCard!.photo.isEmpty
                                    ? Image.asset(
                                        'assets/images/default.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.memory(
                                        Uint8List.fromList(
                                            widget.thaiIDCard!.photo),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              icon: const Icon(FluentIcons.search_32_filled),
                            ),
                          ),
                        ),
                      )
                      // const Icon(FluentIcons.search_20_regular)
                    ],
                  ),
                  const SizedBox(height: 30),
                  buildFormInputWidget(
                    subTitle: 'เลขบัตรประชาชน :',
                    value: '${widget.thaiIDCard?.cid}',
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: 'ชื่อและนามสกุล (TH) :',
                    value:
                        '${widget.thaiIDCard?.titleTH} ${widget.thaiIDCard?.firstnameTH} ${widget.thaiIDCard?.lastnameTH}',
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: '',
                    value:
                        '${widget.thaiIDCard?.titleEN} ${widget.thaiIDCard?.firstnameEN} ${widget.thaiIDCard?.lastnameEN}',
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: 'เพศ :',
                    value: convertGender(widget.thaiIDCard?.gender),
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: 'เกิดวันที่ :',
                    value: formattedDateTH('${widget.thaiIDCard?.birthdate}'),
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: 'วันออกบัตร :',
                    value: formattedDateTH('${widget.thaiIDCard?.issueDate}'),
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: 'วันบัตรหมดอายุ :',
                    value: formattedDateTH('${widget.thaiIDCard?.expireDate}'),
                  ),
                  const SizedBox(height: 15),
                  buildFormInputWidget(
                    subTitle: 'ที่อยู่ :',
                    value: widget.thaiIDCard?.address,
                    minLines: 1,
                    maxLines: 2,
                    subTitleFlex: 2,
                    valueFlex: 9,
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เบอร์โทรศัพท์ :',
                        style: theme.textTheme.titleMedium!.merge(
                          const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: textColorTitle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _mobileTxt,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 12,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          PhoneNumberTextInputFormatter(
                            mask: '###-###-####',
                            separator: '-',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => cameraImages(),
                          icon: const FaIcon(FontAwesomeIcons.camera),
                          label: const Text('กล้อง'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => selectImages(),
                          icon: const FaIcon(FontAwesomeIcons.image),
                          label: const Text('รูปภาพ'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 200,
                    width: constraints.maxWidth < 390 ? width : 390,
                    color: Colors.grey,
                    padding: const EdgeInsets.all(10),
                    child: imageFileList!.isNotEmpty
                        ? GridView.builder(
                            itemCount: imageFileList?.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              return UICustomOnClick(
                                onTap: () => showAlertDialog(
                                  content: Stack(
                                    children: [
                                      Image.file(
                                        File(imageFileList![index].path),
                                        width: width,
                                        fit: BoxFit.cover,
                                      ),
                                      Align(
                                        alignment: const Alignment(0.9, -1.0),
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FluentIcons.delete_24_regular,
                                          ),
                                          label: const Text('DELETE'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    File(imageFileList![index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: constraints.maxWidth < 390 ? width : 390,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // final userData = mockUserData;
                        // var personData = ThaiIDCard().toResponse(
                        //   idCard: widget.thaiIDCard,
                        //   mobilePhone: _mobileTxt.text.replaceAll('-', ''),
                        // );

                        // final newData = IDCardDetailModel(
                        //   userNationID: userData.idCard,
                        //   personData: PeopleModel(
                        //     nationID: personData.cid,
                        //     titleTH: personData.titleTH,
                        //     firstnameTH: personData.firstnameTH,
                        //     lastnameTH: personData.lastnameTH,
                        //     titleEN: personData.titleEN,
                        //     firstnameEN: personData.firstnameEN,
                        //     lastnameEN: personData.lastnameEN,
                        //     address: personData.address,
                        //     birthdate: personData.birthdate,
                        //     issueDate: personData.issueDate,
                        //     expireDate: personData.expireDate,
                        //     gender: personData.gender,
                        //     photo: base64.encode(
                        //       MemoryImage(
                        //         Uint8List.fromList(personData.photo),
                        //       ).bytes,
                        //     ),
                        //     mobile: personData.mobile,
                        //   ),
                        //   location: LocationModel(
                        //     latitude: widget.position!.latitude,
                        //     longitude: widget.position!.longitude,
                        //   ),
                        // );

                        // print(jsonEncode(newData));
                        // showDialogConfirm(
                        //   language.txt_do_you_want_to_save_it,
                        //   context,
                        //   () async {
                        //     Navigator.of(context).pop();
                        //   },
                        // );
                      },
                      icon: const FaIcon(FontAwesomeIcons.floppyDisk),
                      label: const Text('บันทึก'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: constraints.maxWidth < 390 ? width : 390,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('ย้อนกลับ'),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormInputWidget(
      {String? subTitle,
      String? value,
      int? minLines,
      int? maxLines = 1,
      int subTitleFlex = 5,
      int valueFlex = 6}) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          flex: subTitleFlex,
          child: Text(
            '$subTitle',
            style: theme.textTheme.titleMedium!.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: textColorTitle,
              ),
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: valueFlex,
          child: Text(
            '$value',
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium!.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: textColorTitle,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        )
      ],
    );
  }
}
