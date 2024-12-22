import 'package:flutter/material.dart';
import 'bluetooth_service.dart'; // Import the BluetoothService
import 'home_screen.dart'; // Add the home screen
import 'models/Chart.dart';
import 'models/measure.dart';

class MeasurePage extends StatefulWidget {
  @override
  MeasurePageView createState() => MeasurePageView();
}

class MeasurePageView extends State<MeasurePage> {
  bool _toggled = false; // Toggle button value
  List<int> _heartRateData = <int>[]; // Array to store heart rate values
  int? _currentHeartRate;
  String? _score;
  bool _isFinished = false;

  final BluetoothService _bluetoothService =
      BluetoothService(); // Bluetooth service instance

  @override
  void dispose() {
    _bluetoothService.disconnectDevice(); // Ensure the device is disconnected
    super.dispose();
  }

  // Toggle button to start or stop measurement
  void _toggle() {
    if (_toggled) {
      _untoggle();
    } else {
      _startBluetoothMeasurement();
    }
  }

  // Handle the case when toggling off
  void _untoggle() async {
    await _bluetoothService.disconnectDevice();
    setState(() {
      _toggled = false;
      _isFinished = true;
      _score = _heartRateData.isNotEmpty
          ? (_heartRateData.reduce((a, b) => a + b) / _heartRateData.length)
              .toStringAsFixed(0)
          : 'No data';
    });
  }

  // Start Bluetooth measurement
  Future<void> _startBluetoothMeasurement() async {
    try {
      await _bluetoothService.startBluetoothMeasurement(); // Call correctly
      setState(() {
        _toggled = true;
      });
    } catch (e) {
      print('Error starting Bluetooth measurement: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Header section
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Measure',
                          style: TextStyle(
                            fontFamily: 'Montserrat Medium',
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _toggled
                              ? "Connected to Bluetooth device"
                              : "Tap to connect and start measurement",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat Medium',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Measurement button
                  Container(
                    constraints: BoxConstraints(
                      minHeight: size.height * .3,
                      minWidth: size.height * .3,
                    ),
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _toggle,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20.0),
                        backgroundColor: Colors.grey[800],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _isFinished
                                ? (!_toggled ? "$_score BPM" : 'MEASUREMENT')
                                : 'TAP TO START',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Montserrat Regular',
                            ),
                          ),
                          SizedBox(height: 30),
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 64,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Display heart rate data
                  Expanded(
                    child: RepaintBoundary(
                      child: Chart(
                        _heartRateData
                            .map((value) => SensorValue(
                                  DateTime.now().add(Duration(
                                      seconds: _heartRateData.indexOf(value))),
                                  value.toDouble(),
                                ))
                            .toList(),
                      ),
                    ),
                  ),

                  // Button to go back to the home screen
                  Container(
                    constraints: BoxConstraints(minHeight: 50.0),
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        _bluetoothService.disconnectDevice();
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  HomeScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(-1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        backgroundColor: Colors.grey[800],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
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
                                fontFamily: 'Montserrat Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
