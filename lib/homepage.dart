import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot_p1/data.dart';
import 'package:iot_p1/widgets/backgroun_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

bool switch1 = false;
bool switch2 = false;
bool switch3 = false;
bool switch4 = false;
String? humidity;
String? temperature;

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    getSwitchStat();
    getTempAndHumidity();
  }

  @override
  getSwitch1Status() {
    databaseRefferal
        .child("Switch Status")
        .child("Switch 1")
        .once()
        .then((value) {
      if (value.snapshot.value.toString() == "true") {
        setState(() {
          switch1 = true;
        });
      } else {
        setState(() {
          switch1 = false;
        });
      }
    });
  }

  getSwitch2Status() {
    databaseRefferal
        .child("Switch Status")
        .child("Switch 2")
        .once()
        .then((value) {
      if (value.snapshot.value.toString() == "true") {
        setState(() {
          switch2 = true;
        });
      } else {
        setState(() {
          switch2 = false;
        });
      }
    });
  }

  getSwitch3Status() {
    databaseRefferal
        .child("Switch Status")
        .child("Switch 3")
        .once()
        .then((value) {
      if (value.snapshot.value.toString() == "true") {
        setState(() {
          switch3 = true;
        });
      } else {
        setState(() {
          switch3 = false;
        });
      }
    });
  }

  getSwitch4Status() {
    databaseRefferal
        .child("Switch Status")
        .child("Switch 4")
        .once()
        .then((value) {
      if (value.snapshot.value.toString() == "true") {
        setState(() {
          switch4 = true;
        });
      } else {
        setState(() {
          switch4 = false;
        });
      }
    });
  }

  Future<void> getSwitchStat() async {
    getSwitch1Status();
    getSwitch2Status();
    getSwitch3Status();
    getSwitch4Status();
    Timer(const Duration(microseconds: 1), () => getSwitchStat());
  }

  Future<void> getTempAndHumidity() async {
    databaseRefferal.child("Data").child("humidity").once().then((value) {
      setState(() {
        humidity = value.snapshot.value.toString();
      });
    });
    databaseRefferal.child("Data").child("temperature").once().then((value) {
      setState(() {
        temperature = value.snapshot.value.toString();
      });
    });

    Timer(const Duration(seconds: 1), () => getTempAndHumidity());
  }

  @override
  update(int switchno) {
    if (switchno == 1) {
      setState(() {
        switch1 = !switch1;
      });
    } else if (switchno == 2) {
      setState(() {
        switch2 = !switch2;
      });
    } else if (switchno == 3) {
      setState(() {
        switch3 = !switch3;
      });
    } else if (switchno == 4) {
      setState(() {
        switch4 = !switch4;
      });
    }
  }

  final databaseRefferal = FirebaseDatabase.instance.ref();
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BackgroundGradient(
      child: StreamBuilder(
          stream: databaseRefferal.child("Data").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      alignment: Alignment.bottomCenter,
                      width: 100.w,
                      child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        axes: [
                          RadialAxis(
                            startAngle: 180,
                            axisLineStyle:
                                const AxisLineStyle(color: Colors.white),
                            majorTickStyle:
                                const MajorTickStyle(color: Colors.white),
                            minorTickStyle:
                                const MinorTickStyle(color: Colors.white),
                            axisLabelStyle:
                                const GaugeTextStyle(color: Colors.white),
                            endAngle: 360,
                            minimum: 0,
                            maximum: 70,
                            interval: 5,
                            ranges: gaugeRange,
                            pointers: [
                              NeedlePointer(
                                knobStyle: KnobStyle(color: Colors.white),
                                needleStartWidth: 1,
                                needleEndWidth: 1.w,
                                needleLength: 0.85,
                                needleColor:
                                    const Color.fromARGB(255, 184, 183, 183),
                                value: double.parse(temperature!),
                                enableAnimation: true,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 33.h,
                    left: 20.w,
                    child: SizedBox(
                      width: 60.w,
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.temperatureQuarter,
                            color: Colors.white,
                            size: 4.h,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            temperature! + ' °C',
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 3.h),
                          ),
                          Spacer(),
                          FaIcon(
                            FontAwesomeIcons.droplet,
                            color: Colors.white,
                            size: 4.h,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            humidity! + ' %',
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 3.h),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40.h,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 61, 60, 60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 10.h,
                          width: 100.w,
                          margin: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 1.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.w),
                                height: 8.h,
                                width: 8.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bedroom.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const Text(
                                'Switch 1',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              InkWell(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                // overlayColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  update(1);
                                  writeData(switch1, switch2, switch3, switch4,
                                      "switch_1");
                                  // saveSwitch1Status(switch1);
                                },
                                child: SizedBox(
                                  height: 7.h,
                                  width: 16.w < 65 ? 65 : 16.w,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 184, 183, 183),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 15,
                                          width: 18.w,
                                        ),
                                      ),
                                      Align(
                                        alignment: switch1
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          height: 4.h < 33 ? 33 : 4.h,
                                          width: 4.h < 33 ? 33 : 4.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: switch1
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      255, 233, 233, 233)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 61, 60, 60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 10.h,
                          width: 100.w,
                          margin: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 1.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.w),
                                height: 8.h,
                                width: 8.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bedroom.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const Text(
                                'Switch 2',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              InkWell(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                // overlayColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  update(2);
                                  writeData(switch1, switch2, switch3, switch4,
                                      "switch_2");
                                  // saveSwitch2Status(switch2);
                                },
                                child: SizedBox(
                                  height: 7.h,
                                  width: 16.w < 65 ? 65 : 16.w,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 184, 183, 183),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 15,
                                          width: 18.w,
                                        ),
                                      ),
                                      Align(
                                        alignment: switch2
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          height: 4.h < 33 ? 33 : 4.h,
                                          width: 4.h < 33 ? 33 : 4.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: switch2
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      255, 233, 233, 233)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 61, 60, 60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 10.h,
                          width: 100.w,
                          margin: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 1.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.w),
                                height: 8.h,
                                width: 8.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bedroom.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const Text(
                                'Switch 3',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              InkWell(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                // overlayColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  update(3);
                                  writeData(switch1, switch2, switch3, switch4,
                                      "switch_3");
                                  // saveSwitch3Status(switch3);
                                },
                                child: SizedBox(
                                  height: 7.h,
                                  width: 16.w < 65 ? 65 : 16.w,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 184, 183, 183),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 15,
                                          width: 18.w,
                                        ),
                                      ),
                                      Align(
                                        alignment: switch3
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          height: 4.h < 33 ? 33 : 4.h,
                                          width: 4.h < 33 ? 33 : 4.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: switch3
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      255, 233, 233, 233)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 61, 60, 60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 10.h,
                          width: 100.w,
                          margin: EdgeInsets.symmetric(
                            vertical: 1.h,
                            horizontal: 1.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.w),
                                height: 8.h,
                                width: 8.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bedroom.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const Text(
                                'Switch 4',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              InkWell(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                // overlayColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  update(4);
                                  writeData(switch1, switch2, switch3, switch4,
                                      "switch_4");
                                  // saveSwitch4Status(switch4);
                                },
                                child: SizedBox(
                                  height: 7.h,
                                  width: 16.w < 65 ? 65 : 16.w,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 184, 183, 183),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 15,
                                          width: 18.w,
                                        ),
                                      ),
                                      Align(
                                        alignment: switch4
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          height: 4.h < 33 ? 33 : 4.h,
                                          width: 4.h < 33 ? 33 : 4.h,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: switch4
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      255, 233, 233, 233)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> writeData(bool switchStat1, bool switchStat2, bool switchStat3,
      bool switchStat4, String switchName) async {
    // databaseRefferal.child("Data").set({"Humidity: ": 0, "Temperature: ": 0});
    databaseRefferal.child("Switch Status").set({
      "Switch 1": (switchStat1).toString(),
      "Switch 2": (switchStat2).toString(),
      "Switch 3": (switchStat3).toString(),
      "Switch 4": (switchStat4).toString()
    });
  }
}
