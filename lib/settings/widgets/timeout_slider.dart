import 'package:flutter/material.dart';

class TimeoutSlider extends StatelessWidget {
  const TimeoutSlider({
    super.key,
    required this.minLimit,
    required this.maxLimit,
    required this.value,
    required this.divisions,
    required this.onChanged,
  });

  final int minLimit, maxLimit, divisions;
  final double value;
  final void Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: value.toDouble(),
          onChanged: onChanged,
          min: minLimit.toDouble(),
          max: maxLimit.toDouble(),
          divisions: divisions,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLimit.toString()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  '${value.toInt()}s',
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: ColorScheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(maxLimit.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
