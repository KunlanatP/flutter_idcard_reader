import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/pages/empty_header.dart';
import 'package:flutter_idcard_reader/pages/idcard_detail_page.dart';
import 'package:flutter_idcard_reader/pages/idcard_view_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';

class IDCardPage extends StatefulWidget {
  final Position? position;

  const IDCardPage({
    super.key,
    required this.position,
  });

  @override
  State<IDCardPage> createState() => _IDCardPageState();
}

class _IDCardPageState extends State<IDCardPage> {
  ThaiIDCard? _data;
  UsbDevice? _device;
  StreamSubscription? subscription;
  List<String> selectedTypes = [];
  bool isView = false;

  @override
  void initState() {
    super.initState();
    ThaiIdcardReaderFlutter.deviceHandlerStream.listen(_onUSB);
  }

  void _onUSB(usbEvent) {
    try {
      if (usbEvent.hasPermission) {
        subscription =
            ThaiIdcardReaderFlutter.cardHandlerStream.listen(_onData);
      } else {
        if (subscription == null) {
          subscription?.cancel();
          subscription = null;
        }
        _clear();
      }
      setState(() {
        _device = usbEvent;
      });
    } catch (e) {
      setState(() {});
    }
  }

  void _onData(readerEvent) {
    try {
      setState(() {});
      if (readerEvent.isReady) {
        readCard(only: selectedTypes);
      } else {
        _clear();
      }
    } catch (e) {
      setState(() {});
    }
  }

  readCard({List<String> only = const []}) async {
    try {
      var response = await ThaiIdcardReaderFlutter.read(only: only);
      setState(() {
        _data = response;
      });
    } catch (e) {
      setState(() {});
    }
  }

  _clear() {
    setState(() {
      _data = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_device == null || !_device!.isAttached) {
      return EmptyHeader(
        text: translation(context).connect_smart_card_reader,
      );
    }
    if (_data == null && (_device != null && _device!.hasPermission)) {
      return EmptyHeader(
        imageUrl: 'assets/images/insert_idcard.png',
        text: translation(context).insert_idcard,
      );
    }
    if (_data != null) {
      return Container(
        color: Colors.white,
        child: Stack(
          children: [
            IDCardViewPage(thaiIDCard: _data),
            Align(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withAlpha(125),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IDCardDetailPage(
                          thaiIDCard: _data,
                          position: widget.position,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(FluentIcons.search_20_filled),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}

class UsbDeviceCard extends StatelessWidget {
  final dynamic device;
  const UsbDeviceCard({
    Key? key,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: device.isAttached ? 1.0 : 0.5,
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.usb,
            size: 32,
          ),
          title: Text('${device!.manufacturerName} ${device!.productName}'),
          subtitle: Text(device!.identifier ?? ''),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            color: device!.hasPermission ? Colors.green : Colors.grey,
            child: Text(
                device!.hasPermission
                    ? 'Listening'
                    : (device!.isAttached ? 'Connected' : 'Disconnected'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }
}

class DisplayInfo extends StatelessWidget {
  const DisplayInfo({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    TextStyle sTitle =
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    TextStyle sVal = const TextStyle(fontSize: 28);

    copyFn(value) {
      Clipboard.setData(ClipboardData(text: value)).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Copy it already")));
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$title : ',
                style: sTitle,
              ),
            ],
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: sVal,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => copyFn(value),
                child: const Icon(Icons.copy),
              )
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
