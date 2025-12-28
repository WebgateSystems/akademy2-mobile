import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularProgressWidget extends StatefulWidget {
  final double? value;
  final double? size;
  const CircularProgressWidget({
    super.key,
    this.value,
    this.size,
  });

  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size ?? 48.r,
      height: widget.size ?? 48.r,
      child: CircularProgressIndicator(
        strokeWidth: 2.r,
        value: widget.value,
        backgroundColor: AppColors.borderPrimary(context),
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.contentAccent(context),
        ),
      ),
    );
  }
}
