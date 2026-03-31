import 'package:flutter/material.dart';

class YInfraColors extends ThemeExtension<YInfraColors> {
  final Color successColor;
  final Color warningColor;

  const YInfraColors({
    required this.successColor,
    required this.warningColor,
  });

  @override
  YInfraColors copyWith({
    Color? successColor,
    Color? warningColor,
  }) {
    return YInfraColors(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
    );
  }

  @override
  YInfraColors lerp(covariant YInfraColors? other, double t) {
    if (other == null) return this;
    return YInfraColors(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
    );
  }
}

extension YInfraColorsExtension on BuildContext {
  YInfraColors get yColors => Theme.of(this).extension<YInfraColors>()!;
}
