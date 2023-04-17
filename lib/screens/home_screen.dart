import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const twentyFiveMinutes = 1500;
const fiveMinutes = 300;
int totalSeconds = twentyFiveMinutes;
int totalRestSeconds = fiveMinutes;
bool isRunning = false;
bool restTime = false;
int totalPomodoros = 0;
int totalRound = 0;
int startTime = 0;
int limitPomodoros = 2;
int limitTotalRounds = 2;
int settingTime = 0;
late Timer timer;
late Timer restTimer;

class _HomeScreenState extends State<HomeScreen> {
  void startRest() {
    setState(() {
      restTimer = Timer.periodic(const Duration(seconds: 1), restOnTick);
    });
  }

  void restOnTick(Timer restTimer) {
    if (totalRestSeconds == 0) {
      setState(() {
        restTime = false;
        totalRestSeconds = fiveMinutes;
        restTimer.cancel();
      });
    } else {
      setState(() {
        totalRestSeconds -= 1;
      });
    }
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = startTime;
        timer.cancel();
        if (totalPomodoros == limitPomodoros) {
          setState(() {
            totalPomodoros = 0;
            totalRound += 1;
          });
          if (totalRound == limitTotalRounds) {
            setState(() {
              totalRound = 0;
              restTime = true;
            });
            startRest();
          }
        }
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );

    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void setTimer() {
    setState(() {
      startTime = settingTime * 60;
      totalSeconds = settingTime * 60;
    });
  }

  void countPomodoros() {
    setState(() {
      if (totalPomodoros == 12) {
        totalPomodoros == 0;
        totalRound += 1;
      }
    });
  }

  void restart() {
    setState(() {
      totalSeconds = startTime;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          restTime
              ? Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      format(totalRestSeconds),
                      style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 89,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : isRunning
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            format(totalSeconds),
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 89,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ])
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              format(totalSeconds),
                              style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 89,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [
                                    0,
                                    0.1
                                  ],
                                  colors: [
                                    Colors.transparent,
                                    Colors.white
                                  ]).createShader(bounds);
                            },
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    stops: [
                                      0,
                                      0.1
                                    ],
                                    colors: [
                                      Colors.transparent,
                                      Colors.white
                                    ]).createShader(bounds);
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child:
                                          ToggleTest(parentsFunction: setTimer),
                                    )
                                    // ButtonContainer(
                                    //   timerSetting: 1,
                                    //   parentFucntion: () =>
                                    //       setTimer(settingTime: 1),
                                    // ),
                                    // ButtonContainer(
                                    //   timerSetting: 20,
                                    //   parentFucntion: () =>
                                    //       setTimer(settingTime: 20),
                                    // ),
                                    // ButtonContainer(
                                    //   timerSetting: 25,
                                    //   parentFucntion: () =>
                                    //       setTimer(settingTime: 25),
                                    // ),
                                    // ButtonContainer(
                                    //   timerSetting: 30,
                                    //   parentFucntion: () =>
                                    //       setTimer(settingTime: 30),
                                    // ),
                                    // ButtonContainer(
                                    //   timerSetting: 35,
                                    //   parentFucntion: () =>
                                    //       setTimer(settingTime: 35),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          Flexible(
            flex: 3,
            child: Center(
              child: restTime
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Rest Time"),
                        Icon(Icons.bedtime),
                      ],
                    )
                  : isRunning
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: onPausePressed,
                              icon: const Icon(Icons.pause_circle_outline),
                            ),
                            IconButton(
                              onPressed: restart,
                              icon: const Icon(Icons.replay),
                            )
                          ],
                        )
                      : IconButton(
                          color: Theme.of(context).cardColor,
                          iconSize: 120,
                          onPressed: onStartPressed,
                          icon: const Icon(Icons.play_circle_outline),
                        ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pomodoros",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                            Text(
                              "$totalPomodoros/$limitPomodoros",
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "TotalRound",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                            Text(
                              "$totalRound/$limitTotalRounds",
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonContainer extends StatefulWidget {
  final Function() parentFucntion;
  final int? timerSetting;
  const ButtonContainer({
    super.key,
    this.timerSetting,
    required this.parentFucntion,
  });

  @override
  State<ButtonContainer> createState() => _ButtonContainerState();
}

class _ButtonContainerState extends State<ButtonContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: widget.parentFucntion,
        child: Text("${widget.timerSetting}"),
      ),
    );
  }
}

class ToggleTest extends StatefulWidget {
  final Function() parentsFunction;
  const ToggleTest({
    super.key,
    required this.parentsFunction,
  });
  @override
  State<ToggleTest> createState() => _ToggleTestState();
}

class _ToggleTestState extends State<ToggleTest> {
  List<int> timeList = [1, 2, 3, 4, 5];
  final List<bool> _isSelected = [false, false, false, false, false];
  int selectCheck = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButtons(
          isSelected: _isSelected,
          onPressed: (index) {
            setState(() {
              settingTime = timeList[index];
              widget.parentsFunction();
              _isSelected[index] = !_isSelected[index];
              selectCheck = index;
              if (selectCheck == index) {
                _isSelected[index] = true;
              }
              for (int i = 0; i < _isSelected.length; i++) {
                if (i == index) continue;
                _isSelected[i] = false;
                // Do something with list[i]
              }
            });
          },
          children: [
            Text("${timeList[0]}"),
            Text("${timeList[1]}"),
            Text("${timeList[2]}"),
            Text("${timeList[3]}"),
            Text("${timeList[4]}"),
          ],
        ),
      ],
    );
  }
}
