import 'package:flutter/material.dart';

import '../../../core/base/state.dart';
import '../../../core/init/theme/color_manager.dart';

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      width: Utility.dynamicWidthPixel(9),
      height: Utility.dynamicWidthPixel(9),
      margin: EdgeInsets.all(Utility.dynamicWidthPixel(4)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? ColorManager.instance.white : ColorManager.instance.greyPassiveText.withOpacity(0.4),
      ),
    );
  }
}
