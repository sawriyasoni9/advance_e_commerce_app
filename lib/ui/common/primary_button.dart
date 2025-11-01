import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final Color? backgroundColor;
  final Color? borderColor;
  final GestureTapCallback? onTap;
  final TextStyle? textStyles;
  final double? height;
  final double? width;
  final double leftPaddingBtnLabel;
  final bool roundedCorner;
  final Alignment? alignmentBtnLabel;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.textStyles,
    this.roundedCorner = false,
    this.height,
    this.width,
    this.leftPaddingBtnLabel = 0,
    this.alignmentBtnLabel,
    this.textColor,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor ?? Colors.transparent),
          borderRadius: widget.roundedCorner ? BorderRadius.circular(10) : null,
          color: Colors.black,
        ),
        height: widget.height ?? 65,
        width: widget.width ?? double.infinity,
        child: Align(
          alignment: widget.alignmentBtnLabel ?? Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: widget.leftPaddingBtnLabel),
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 20,
                height: 28 / 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
