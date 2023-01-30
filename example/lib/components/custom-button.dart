import 'package:flutter/material.dart';
const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainTextColor = Color(0xFF8864FF);
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _lineBackground = Color(0XFFe5e5e5);
const Color _mainBackground = Color(0XFFF5F5F5);

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onPressed,
    required this.title
  }) : super(key: key);

  final String title;
  //点击回调
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      height: 50.0,
      color: _mainTextColor,
      textColor: _primaryTextColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          )
        ],
      ),
    );
  }
}