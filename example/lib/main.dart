import 'package:simple_cookies/simple_cookies.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(Website());
}

///For Flutter Web only
class Website extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookie-Tester',
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool switcher;
  @override
  void initState() {
    Cookies.acceptedCookiesId = '{www.example.de}-acceptedCookies?';
    switcher = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Cookies.wrapBanner(
      banner: switcher ? null : CustomBanner(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cookies!'),
          actions: [
            FlatButton.icon(
                textColor: Colors.white,
                onPressed: () => Cookies.removeAllCookies(),
                icon: Icon(Icons.delete),
                label: Text('Remove all Cookies')),
            FlatButton.icon(
                textColor: Colors.white,
                onPressed: () => setState(() {}),
                icon: Icon(Icons.refresh),
                label: Text('Refresh Site'))
          ],
        ),
        body: Container(
          width: double.infinity,
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Example Page',
                style: TextStyle(color: Colors.white24, fontSize: 50),
              ),
              Switch(
                value: switcher,
                onChanged: (value) => setState(() => switcher = value),
              ),
              Text(switcher ? 'Default Banner' : 'Custom CookieBanner')
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBanner extends CookieBanner {
  CustomBanner() : super(Cookies.acceptedCookiesId);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue, width: 2)),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  'We are using cookies! Lorem Ipsum, feliz navidad!',
                  style: TextStyle(color: Colors.white),
                )),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: () => acceptCookies(context),
                      child: Text(
                        'Delicious!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () => denyCookies(context),
                      child: Text(
                        'Nope!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
