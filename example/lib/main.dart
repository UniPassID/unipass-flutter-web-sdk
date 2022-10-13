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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("polygon"),
            Radio<ChainType>(
              value: ChainType.polygon,
              groupValue: chainType,
              onChanged: (ChainType? value) {
                setState(() {
                  chainType = value!;
                });
              },
            ),
            const Text("bsc"),
            Radio<ChainType>(
              value: ChainType.bsc,
              groupValue: chainType,
              onChanged: (ChainType? value) {
                setState(() {
                  chainType = value!;
                });
              },
            ),
            const Text("rangers"),
            Radio<ChainType>(
              value: ChainType.rangers,
              groupValue: chainType,
              onChanged: (ChainType? value) {
                setState(() {
                  chainType = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: OutlinedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TestPage(theme: theme, chainType: chainType);
                }),
              );
            },
            child: const Text("init sdk"),
          ),
        ),
      ],
    );
  }
}
