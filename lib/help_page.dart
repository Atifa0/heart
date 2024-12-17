import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';

//About Page
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get size
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/top_header.png')),
            ),
          ),
          SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Container(
                        height: 64,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Help',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat Medium',
                                            color: Colors.white,
                                            fontSize: 28)),
                                  ])
                            ])),

                    Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/how.png', width: 200,
                                    // Set the width
                                    height: 200,
                                  )),
                            ])),

                    Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: <Widget>[
                              SizedBox(height: 20),
                              Text('How to measure my heart rate?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Montserrat Medium')),
                              SizedBox(height: 10),
                              Text(
                                'Attach the electrode pads to your body as follows:'
                                ' Right arm: Near the shoulder.'
                                ' Left arm: Near the left shoulder.'
                                ' Right leg: Just above the hip.'
                                ' Connect the leads from the AD8232 module to these electrode pads:'
                                '  RA (Right Arm) lead to the right arm pad.'
                                ' LA (Left Arm) lead to the left arm pad.'
                                ' RL (Right Leg/Ground) lead to the right leg pad',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat Regular'),
                                textAlign: TextAlign.justify,
                              ),
                            ]))),

                    //Spacer(),
                    Container(
                      constraints: BoxConstraints(minHeight: 50.0),
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      HomeScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              }));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.black,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Go back',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'Montserrat Regular'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])))
        ]));
  }
}
