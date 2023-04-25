import 'package:example/page.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:unipass_web_sdk/unipass_web_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: child,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UnipassTheme theme = UnipassTheme.light;
  ChainType chainType = ChainType.polygon;
  bool returnEmail = false;

  String domain = "d.wallet.unipass.vip";

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("light"),
            Radio<UnipassTheme>(
              value: UnipassTheme.light,
              groupValue: theme,
              onChanged: (UnipassTheme? value) {
                setState(() {
                  theme = value!;
                });
              },
            ),
            const Text("dark"),
            Radio<UnipassTheme>(
              value: UnipassTheme.dark,
              groupValue: theme,
              onChanged: (UnipassTheme? value) {
                setState(() {
                  theme = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 40),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: ChainType.values.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(item.name),
                  Radio<ChainType>(
                    value: item,
                    groupValue: chainType,
                    onChanged: (ChainType? value) {
                      setState(() {
                        chainType = value!;
                      });
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: returnEmail,
              onChanged: (bool? value) {
                setState(() {
                  returnEmail = value!;
                });
              },
            ),
            const Text("returnEmail"),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          child: Text("domain: $domain", textAlign: TextAlign.center),
          onTap: () {
            setState(() {
              count++;
            });
            if (count == 10) {
              setState(() {
                domain = "t.wallet.unipass.vip";
              });
            }
          },
        ),
        const SizedBox(height: 30),
        const Text("Onboarding users through Google and Email", textAlign: TextAlign.center),
        Align(
          alignment: Alignment.center,
          child: OutlinedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TestPage(
                      theme: theme,
                      chainType: chainType,
                      domain: domain,
                      connectType: ConnectType.google,
                      returnEmail: returnEmail);
                }),
              );
            },
            child: const Text("Connect With Google"),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: OutlinedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TestPage(
                      theme: theme,
                      chainType: chainType,
                      domain: domain,
                      connectType: ConnectType.email,
                      returnEmail: returnEmail);
                }),
              );
            },
            child: const Text("Connect With Email"),
          ),
        ),
        const SizedBox(height: 30),
        const Text("Onboarding users through one button", textAlign: TextAlign.center),
        Align(
          alignment: Alignment.center,
          child: OutlinedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TestPage(theme: theme, chainType: chainType, domain: domain, returnEmail: returnEmail);
                }),
              );
            },
            child: const Text("Connect UniPass"),
          ),
        ),
      ],
    );
  }

  Color getColor(Set<MaterialState> states) {
    return Colors.blue;
  }
}
