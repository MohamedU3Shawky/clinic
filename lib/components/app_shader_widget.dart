// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

enum AppShaderMode {
  primary,
  secondary,
  gradient,
}

class AppShaderWidget extends StatelessWidget {
  final Widget? child;
  final AppShaderMode mode;
  final Color? color;

  const AppShaderWidget({Key? key, this.child, this.color, this.mode = AppShaderMode.primary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color shaderColor;
    if (color == null) {
      switch (mode) {
        case AppShaderMode.gradient:
          shaderColor = appColorPrimary;
          break;
        case AppShaderMode.secondary:
          shaderColor = appColorSecondary;
          break;
        default:
          shaderColor = appColorPrimary;
      }
    } else {
      shaderColor = color ?? white;
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [shaderColor, shaderColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: child,
    );
  }
}
