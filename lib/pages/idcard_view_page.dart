import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/utils/format_date.dart';
import 'package:flutter_idcard_reader/utils/format_idcard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';

class IDCardViewPage extends StatefulWidget {
  final ThaiIDCard? thaiIDCard;
  const IDCardViewPage({
    super.key,
    required this.thaiIDCard,
  });

  @override
  State<IDCardViewPage> createState() => _IDCardViewPageState();
}

class _IDCardViewPageState extends State<IDCardViewPage> {
  final textStyle = GoogleFonts.inter(
    color: const Color(0xFF333335),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  _renderContent(context) {
    return Center(
      child: SizedBox(
        width: 350,
        height: 237,
        child: Card(
          elevation: 0.0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC3E7F3),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 350,
                    height: 87,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA7D9F0),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                        top: 7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              'ที่อยู่  ${widget.thaiIDCard?.address}',
                              overflow: TextOverflow.clip,
                              style: textStyle.merge(
                                GoogleFonts.inter(
                                  fontSize: 8,
                                  color: const Color(0xFF333335),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 190,
                            child: TableCardDateWidget(
                              thaiIDCard: widget.thaiIDCard,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 27,
                    height: 166,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.97, 0.5),
                  child: Image.asset(
                    'assets/images/barcode.png',
                    height: 140,
                  ),
                ),
                ThaiIDCardDetailWidget(thaiIDCard: widget.thaiIDCard),
                Align(
                  alignment: const Alignment(0.88, 0.52),
                  child: widget.thaiIDCard?.photo == null
                      ? Image.asset(
                          'assets/images/default.png',
                          width: 76,
                          height: 94,
                          fit: BoxFit.fill,
                        )
                      : Image.memory(
                          Uint8List.fromList(widget.thaiIDCard!.photo),
                          width: 76,
                          height: 94,
                          fit: BoxFit.fill,
                        ),
                ),
                Align(
                  alignment: const Alignment(-0.18, 0.73),
                  child: SizedBox(
                    height: 20,
                    child: Image.asset('assets/images/logo1.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Zoom(
      backgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      child: _renderContent(context),
    );
  }
}

class ThaiIDCardDetailWidget extends StatelessWidget {
  final ThaiIDCard? thaiIDCard;

  const ThaiIDCardDetailWidget({super.key, required this.thaiIDCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10),
      child: Stack(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Container(
                  height: 41,
                  width: 41,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(100), //<-- SEE HERE
                  ),
                  child: Image.asset('assets/images/garuda.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  child: Stack(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'บัตรประจำตัวประชาชน ',
                          style: theme.textTheme.subtitle2!.merge(
                            GoogleFonts.inter(
                              fontSize: 15,
                              color: const Color(0xFF333335),
                              letterSpacing: -1.2,
                            ),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Thai National ID Card',
                              style: theme.textTheme.subtitle2!.merge(
                                GoogleFonts.inter(
                                  fontSize: 15,
                                  letterSpacing: -1.0,
                                  color: const Color(0xFF000D55),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 18),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เลขบัตรประจำตัวประชาชน',
                                  style: theme.textTheme.caption!.merge(
                                    GoogleFonts.inter(
                                      fontSize: 10,
                                      color: const Color(0xFF333335),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Identityfication Number',
                                  style: theme.textTheme.caption!.merge(
                                    GoogleFonts.inter(
                                      fontSize: 9,
                                      color: const Color(0xFF000D55),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                formattedIDCard(thaiIDCard?.cid),
                                style: theme.textTheme.subtitle1!.merge(
                                  GoogleFonts.inter(
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                    color: const Color(0xFF333335),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 45,
            ),
            child: TableWidget(thaiIDCard: thaiIDCard),
          ),
        ],
      ),
    );
  }
}

class TableWidget extends StatelessWidget {
  final ThaiIDCard? thaiIDCard;

  const TableWidget({super.key, required this.thaiIDCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Text(
                  'ชื่อและนามสกุล',
                  style: theme.textTheme.caption!.merge(
                    GoogleFonts.inter(
                      fontSize: 8,
                      color: const Color(0xFF333335),
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                Image.asset(
                  'assets/images/ship.png',
                  height: 42,
                  width: 54,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${thaiIDCard?.titleTH} ${thaiIDCard?.firstnameTH} ${thaiIDCard?.lastnameTH}',
                style: theme.textTheme.subtitle1!.merge(
                  GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF333335),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'Name',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${thaiIDCard?.titleEN} ${thaiIDCard?.firstnameEN}',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Last name',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${thaiIDCard?.lastnameEN}',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      'เกิดวันที่',
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF333335),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDateTH('${thaiIDCard?.birthdate}'),
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF333335),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      'Date of Birth',
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF000D55),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDateEN('${thaiIDCard?.birthdate}'),
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF000D55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'ศาสนา   -',
                  style: theme.textTheme.caption!.merge(
                    GoogleFonts.inter(
                      fontSize: 8,
                      color: const Color(0xFF333335),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TableCardDateWidget extends StatelessWidget {
  final ThaiIDCard? thaiIDCard;

  const TableCardDateWidget({super.key, required this.thaiIDCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 235,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(50),
          1: FixedColumnWidth(50),
          2: FixedColumnWidth(50),
        },
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDateTH('${thaiIDCard?.issueDate}'),
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF333335),
                      ),
                    ),
                  ),
                  Text(
                    'วันออกบัตร',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF333335),
                      ),
                    ),
                  ),
                ],
              ),
              Container(),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDateTH('${thaiIDCard?.expireDate}'),
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF333335),
                        ),
                      ),
                    ),
                    Text(
                      'วันบัตรหมดอายุ',
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF333335),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDateEN('${thaiIDCard?.issueDate}'),
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                  Text(
                    'Date of Issue',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'xxxxxx xxxxxx',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 8,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                  Text(
                    '(เจ้าหน้าที่ออกบัตร)',
                    style: theme.textTheme.caption!.merge(
                      GoogleFonts.inter(
                        fontSize: 7,
                        color: const Color(0xFF000D55),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDateEN('${thaiIDCard?.expireDate}'),
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF000D55),
                        ),
                      ),
                    ),
                    Text(
                      'Date of Expiry',
                      style: theme.textTheme.caption!.merge(
                        GoogleFonts.inter(
                          fontSize: 8,
                          color: const Color(0xFF000D55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
