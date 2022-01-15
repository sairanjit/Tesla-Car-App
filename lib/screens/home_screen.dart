import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesla/constants.dart';
import 'package:tesla/home_controller.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/temp_details.dart';
import 'components/tesla_bottom_navigationbar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationShowTempInfo;
  late Animation<double> _animationCoolGlow;

  void setUpBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.6, 1),
    );
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.2, 0.4),
    );

    _animationShowTempInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.45, 0.65),
    );

    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.7, 1),
    );
  }

  @override
  void initState() {
    setUpBatteryAnimation();
    setupTempAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller,
        _batteryAnimationController,
        _tempAnimationController,
      ]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1) {
                _batteryAnimationController.forward();
              } else if (_controller.selectedBottomTab == 1 && index != 1) {
                _batteryAnimationController.reverse(from: 0.7);
              }
              if (index == 2) {
                _tempAnimationController.forward();
              } else if (_controller.selectedBottomTab == 2 && index != 2) {
                _tempAnimationController.reverse(from: 0.4);
              }
              _controller.updateSelectedTab(index);
            },
            selectedTab: _controller.selectedBottomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constrains) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: constrains.maxHeight,
                    width: constrains.maxWidth,
                  ),
                  Positioned(
                    left: constrains.maxWidth / 2 * _animationCarShift.value,
                    height: constrains.maxHeight,
                    width: constrains.maxWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: constrains.maxHeight * 0.1,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/Car.svg',
                        width: double.infinity,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    right: _controller.selectedBottomTab == 0
                        ? constrains.maxWidth * 0.05
                        : constrains.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isRightDoorLock,
                        press: _controller.updateRightDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    left: _controller.selectedBottomTab == 0
                        ? constrains.maxWidth * 0.05
                        : constrains.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isLeftDoorLock,
                        press: _controller.updateLeftDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    top: _controller.selectedBottomTab == 0
                        ? constrains.maxHeight * 0.13
                        : constrains.maxHeight / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isBonnetLock,
                        press: _controller.updateBonnetLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    bottom: _controller.selectedBottomTab == 0
                        ? constrains.maxHeight * 0.17
                        : constrains.maxHeight / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isTrunkLock,
                        press: _controller.updateTrunkLock,
                      ),
                    ),
                  ),
                  //Battery
                  Opacity(
                    opacity: _animationBattery.value,
                    child: SvgPicture.asset(
                      "assets/icons/Battery.svg",
                      width: constrains.maxWidth * 0.45,
                    ),
                  ),
                  Positioned(
                    top: 50 * (1 - _animationBatteryStatus.value),
                    height: constrains.maxHeight,
                    width: constrains.maxWidth,
                    child: Opacity(
                      opacity: _animationBatteryStatus.value,
                      child: BatteryStatus(constrains: constrains),
                    ),
                  ),
                  //Temp
                  Positioned(
                    height: constrains.maxHeight,
                    width: constrains.maxWidth,
                    top: 60 * (1 - _animationShowTempInfo.value),
                    child: Opacity(
                      opacity: _animationShowTempInfo.value,
                      child: TempDetails(
                        controller: _controller,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -180 * (1 - _animationCoolGlow.value),
                    child: AnimatedSwitcher(
                      duration: defaultDuration,
                      child: _controller.isCoolSelected
                          ? Image.asset(
                              "assets/images/Cool_glow_2.png",
                              key: UniqueKey(),
                              width: 200,
                            )
                          : Image.asset(
                              "assets/images/Hot_glow_4.png",
                              key: UniqueKey(),
                              width: 200,
                            ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
