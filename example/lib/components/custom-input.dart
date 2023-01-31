import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainBackground = Color(0XFFF5F5F5);

class CustomInput extends StatefulWidget {
  CustomInput({Key? key,
    this.enabled = true,
    this.controller = "",
    this.maxLines = 1,
    this.onChanged,
    this.copyVisible = false,
    required this.title, })
      : super(key: key);

  final String title;
  final int? maxLines;
  final bool? copyVisible;
  final onChanged;
  late final String? controller;
  final bool? enabled;

  @override
  _CustomInput createState() => _CustomInput();
}

class _CustomInput extends State<CustomInput> {
  var textController= new TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.controller!;
    textController.addListener(() {
      widget.onChanged!(textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  color: _primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            widget.copyVisible! ? InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: textController.text));
                showToast('Copy succeeded!');
              },
              child: Text(
                'Copy',
                style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ) : Container()
          ],
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              color: (widget.enabled != null && widget.enabled == true)
                  ? Colors.white
                  : _mainBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Color(0XFFe4e7ed), width: 1)),
          child: TextField(
            controller: textController,
            autofocus: false,
            enabled: widget.enabled,
            keyboardType: TextInputType.text,
            maxLines: widget.maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
