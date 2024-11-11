// import 'dart:ui';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class AnimationTheme extends ThemeExtension<AnimationTheme> {
  final double hoverScale;
  final double pressScale;
  final Duration duration;

  const AnimationTheme({
    required this.hoverScale,
    required this.pressScale,
    required this.duration,
  });

  @override
  AnimationTheme copyWith({
    double? hoverScale,
    double? pressScale,
    Duration? duration,
  }) {
    return AnimationTheme(
      hoverScale: hoverScale ?? this.hoverScale,
      pressScale: pressScale ?? this.pressScale,
      duration: duration ?? this.duration,
    );
  }

  @override
  AnimationTheme lerp(ThemeExtension<AnimationTheme>? other, double t) {
    if (other is! AnimationTheme) {
      return this;
    }

    return AnimationTheme(
      hoverScale: lerpDouble(hoverScale, other.hoverScale, t) ?? hoverScale,
      pressScale: lerpDouble(pressScale, other.pressScale, t) ?? pressScale,
      duration: Duration(
        milliseconds: (duration.inMilliseconds +
                (other.duration.inMilliseconds - duration.inMilliseconds) * t)
            .round(),
      ),
    );
  }
}
