import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class TempBtn extends StatelessWidget {
  const TempBtn({
    Key? key,
    required this.svgSrc,
    required this.isActive,
    required this.onPress,
    required this.title,
    this.activeColor = primaryColor,
  }) : super(key: key);

  final String svgSrc, title;
  final bool isActive;
  final VoidCallback onPress;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutBack,
            height: isActive ? 76 : 50,
            width: isActive ? 76 : 50,
            child: SvgPicture.asset(
              svgSrc,
              color: isActive ? activeColor : Colors.white38,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 16,
              color: isActive ? activeColor : Colors.white38,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(
              title.toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}
