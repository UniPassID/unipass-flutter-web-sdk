import 'package:flutter/material.dart';

const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainBackground = Color(0XFFF5F5F5);

class CustomInput extends StatefulWidget {
  CustomInput({Key? key,
    this.onTab,
    this.enabled = true,
    this.controller = "",
    required this.title, })
      : super(key: key);

  final String title;
  final String? controller;
  final bool? enabled;
  final GestureTapCallback? onTab;
  @override
  _CustomInput createState() => _CustomInput();
}

class _CustomInput extends State<CustomInput> {
  var textController= new TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.controller!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
              color: _primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
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
