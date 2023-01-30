import 'package:flutter/material.dart';

const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainTextColor = Color(0xFF8864FF);
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _lineBackground = Color(0XFFe5e5e5);
const Color _mainBackground = Color(0XFFF5F5F5);

class CustomInput extends StatelessWidget {
  const CustomInput({Key? key, this.onTab, this.enabled = true, required this.title})
      : super(key: key);

  final String title;
  final bool? enabled;
  final GestureTapCallback? onTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: _primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              color: (enabled != null && enabled == true) ? Colors.white : _mainBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Color(0XFFe4e7ed), width: 1)),
          child: TextField(
            autofocus: true,
            enabled: enabled,
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
