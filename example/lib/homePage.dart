import 'package:example/components/custom-button.dart';
import 'package:example/components/custom-card.dart';
import 'package:example/components/custom-input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'main.dart';

const Color _primaryTextColor = Color(0xFF1F202A);
const Color _mainTextColor = Color(0xFF8864FF);
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _lineBackground = Color(0XFFe5e5e5);
const Color _mainBackground = Color(0XFFF5F5F5);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'UniPass Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State {
  bool returnAddress = true;
  bool returnEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBackground,
      appBar: AppBar(
        title: Text('demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: ListBody(
          children: [
            //
            const Text(
              'UniPass Demo (Polygon-mumbai)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 40.0),
            CustomCard(
                child: Column(
              children: [
                CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    title: 'Continue with Google'),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Your address',
                  enabled: false,
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Your email',
                  enabled: false,
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'New born',
                  enabled: false,
                ),
                const SizedBox(height: 40.0),
                CustomButton(onPressed: () {}, title: 'Disconnect'),
              ],
            )),
            CustomCard(
                child: Column(
              children: [
                const Text(
                  'Send ETH',
                  style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                CustomInput(
                  title: 'Your balance',
                  enabled: false,
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Transfer to',
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Amount',
                ),
                const SizedBox(height: 40.0),
                CustomButton(onPressed: () {}, title: 'Send'),
              ],
            )),
            CustomCard(
                child: Column(
              children: [
                const Text(
                  'Send ERC20',
                  style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                CustomInput(
                  title: 'Your balance',
                  enabled: false,
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Transfer to',
                ),
                const SizedBox(height: 20.0),
                CustomInput(
                  title: 'Amount',
                ),
                const SizedBox(height: 40.0),
                CustomButton(onPressed: () {}, title: 'Send'),
              ],
            )),
            CustomCard(
                child: Column(
              children: [
                const Text(
                  'Sign Message',
                  style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                CustomInput(
                  title: 'Message',
                ),
                const SizedBox(height: 40.0),
                CustomButton(onPressed: () {}, title: 'Sign Message'),
              ],
            )),
            CustomCard(
                child: Column(
              children: [
                const Text(
                  'Sign Typed Data V4',
                  style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                JsonView.string(
                  '{"AccountPending":"Wallet is recovering...","AccountStatus":"Wallet Status:","ActionNotCommitted":"There is a pending action, are you sure you want to exit?","Add":"Add guardians","AddGuardian":"Add Guardian Email","AddGuardianFailed":"Add Guardian Email Failed","AddSuccess":"Add success","AmountOutOfRange":"Your balance is insufficient, the transfer amount will be changed","ApprovalTo":"Approval to","BackToHome":"Return to homepage","Balance":"Balance","Cancel":"Cancel","CastingSuccess":"Verification successful!"}',
                  theme: const JsonViewTheme(
                    keyStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    doubleStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    intStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    stringStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    boolStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                CustomButton(onPressed: () {}, title: 'Sign Typed Data'),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
