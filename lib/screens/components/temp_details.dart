import 'package:flutter/material.dart';
import 'package:tesla/screens/components/temp_btn.dart';

import '../../constants.dart';
import '../../home_controller.dart';

class TempDetails extends StatelessWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempBtn(
                  svgSrc: "assets/icons/coolShape.svg",
                  onPress: _controller.updateCoolSelectedTab,
                  title: "Cool",
                  isActive: _controller.isCoolSelected,
                ),
                const SizedBox(width: defaultPadding),
                TempBtn(
                  svgSrc: "assets/icons/heatShape.svg",
                  onPress: _controller.updateCoolSelectedTab,
                  title: "Heat",
                  isActive: !_controller.isCoolSelected,
                  activeColor: redColor,
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 48,
                ),
              ),
              const Text(
                "29" "\u2103",
                style: TextStyle(fontSize: 86),
              ),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 48,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text("CURRENT TEMPERATURE"),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Inside".toUpperCase(),
                  ),
                  Text(
                    "20" + "\u2103",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Outside".toUpperCase(),
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "35" + "\u2103",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
