import 'package:example/homePage.dart';
import 'package:example/page.dart';
import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unipass_web_sdk/utils/interface.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';

void main() {
  runApp(const MyApp());
}

const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainTextColor = Color(0xFF8864FF);
const Color _lineBackground = Color(0XFFe5e5e5);
const Color _mainBackground = Color(0XFFF5F5F5);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const MyHomePage(title: 'UniPass Demo'),
    // );

    return OKToast(
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 3),
      child: MaterialApp(
        builder: (context, child) => Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: child,
          ),
        ),
        home: const MyHomePage(title: 'UniPass Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const List<String> list = <String>[];

class _MyHomePageState extends State<MyHomePage> {
  UnipassTheme theme = UnipassTheme.light;
  ChainType chainType = ChainType.polygon;
  bool returnEmail = false;

  bool _isDark = true;
  bool returnAddress = true;
  var chainList = const [
    {
      "value": "polygon",
      "label": "Mumbai (ChainID 80001)",
    },
    {
      "value": "bsc",
      "label": "BSCtestnet (ChainID 97)",
    },
    {
      "value": "rangers",
      "label": "Rangers robin (ChainID 9527)",
    },
    {
      "value": "eth",
      "label": "Goerli (ChainID 5)",
    },
  ];
  var chain = "polygon";

  String domain = "testnet.wallet.unipass.id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBackground,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: ListBody(
          children: [
            const Text(
              'UniPass Demo (Polygon-mumbai)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 40.0),
            Container(
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BrnRadioButton(
                          radioIndex: 0,
                          isSelected: _isDark,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Dark mode',
                            ),
                          ),
                          onValueChangedAtIndex: (index, value) {
                            setState(() {
                              _isDark = true;
                              theme = UnipassTheme.dark;
                              BrnToast.show('Dark mode', context);
                            });
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        BrnRadioButton(
                          radioIndex: 0,
                          isSelected: !_isDark,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Light mode',
                            ),
                          ),
                          onValueChangedAtIndex: (index, value) {
                            setState(() {
                              _isDark = false;
                              theme = UnipassTheme.light;
                              BrnToast.show('Light mode', context);
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      child: DropdownButton<String>(
                        value: chain,
                        focusColor: _mainTextColor,
                        // style: const TextStyle(color: _mainTextColor),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        onChanged: (v) {
                          // update the chain value
                          setState(() {
                            chain = v!;
                          });
                        },
                        items: chainList
                            .map<DropdownMenuItem<String>>(
                                (Map item) => DropdownMenuItem<String>(
                                value: item['value'],
                                // add this property an pass the _value to it
                                child: Text(
                                  item['label'],
                                  // style: const TextStyle(),
                                )))
                            .toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Return address'),
                        Switch(
                            value: returnAddress,
                            onChanged: (v) {
                              setState(() {
                                returnAddress = v!;
                              });
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Return email'),
                        Switch(
                            value: returnEmail,
                            onChanged: (_value) {
                              setState(() {
                                returnEmail = _value!;
                              });
                            })
                      ],
                    )
                  ],
                )),
            SizedBox(height: 40.0),
            Container(
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: _lineBackground,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Onboarding users through Google and Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: _lineBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TestPage(
                              theme: theme,
                              chainType: chainType,
                              domain: domain,
                              connectType: ConnectType.google,
                              returnEmail: returnEmail
                          );
                        }),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('images/google.svg'),
                        const SizedBox(width: 10.0),
                        Text(
                          "Continue with Google",
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                    minWidth: double.infinity,
                    height: 50.0,
                    color: _mainBackground,
                    textColor: _primaryTextColor,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TestPage(
                              theme: theme,
                              chainType: chainType,
                              domain: domain,
                              connectType: ConnectType.email,
                              returnEmail: returnEmail
                          );
                        }),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('images/email.svg'),
                        const SizedBox(width: 10.0),
                        Text(
                          "Continue with Email",
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                    minWidth: double.infinity,
                    height: 50.0,
                    color: _mainBackground,
                    textColor: _primaryTextColor,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: _lineBackground,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      const Expanded(
                        flex: 4,
                        child: Text(
                          'Connect UniPass through one button',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: _lineBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TestPage(
                              theme: theme,
                              chainType: chainType,
                              domain: domain,
                              returnEmail: returnEmail
                          );
                        }),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/unipass.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          "Connect UniPass",
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                    minWidth: double.infinity,
                    height: 50.0,
                    color: _mainBackground,
                    textColor: _primaryTextColor,
                  ),
                  //
                  // Radio<int>(
                  //   value: 0,
                  //   groupValue: groupValue,
                  //   onChanged: onChanged,
                  // ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Container(
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'UniPass Documents',
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 28.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 120),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: 2,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Color(0XFF5575FF),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              Text(
                                'UniPass Website',
                                style: TextStyle(color: _mainTextColor),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 110),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: 2,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Color(0XFF5575FF),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              Text(
                                'Flutter SDK',
                                style: TextStyle(color: _mainTextColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 120),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: 2,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Color(0XFF5575FF),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              const Text(
                                'Popup SDK',
                                style: TextStyle(color: _mainTextColor),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 110),
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                height: 2,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Color(0XFF5575FF),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              const Text(
                                'Unity SDK',
                                style: TextStyle(color: _mainTextColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
