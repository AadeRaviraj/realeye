import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? textColor;  // Make this nullable
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool isOutlined;
  final Color borderColor; // Added borderColor

  CustomButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.textColor, // Allow null so we can handle it in the widget
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 10.0,
    this.elevation = 5.0,
    this.padding,
    this.textStyle,
    this.isOutlined = false,
    required this.borderColor, // Required borderColor
  });

  @override
  Widget build(BuildContext context) {
    // Determine whether dark mode is active
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Default textColor if it's not provided, or use the passed value
    final effectiveTextColor = textColor ?? (isDarkMode ? Colors.white : Colors.black);

    // Use borderColor that adapts to both modes
    final effectiveBorderColor = isOutlined
        ? (isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7))
        : borderColor;

    return GestureDetector(
      onTap: onPressed, // Ensure the button is clickable
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: isOutlined
              ? Colors.transparent
              : backgroundColor ?? (isDarkMode ? Colors.black : Colors.blue),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            if (!isOutlined)
              BoxShadow(
                color: Colors.black26,
                blurRadius: elevation,
                offset: Offset(0, 2),
              ),
          ],
          border: isOutlined
              ? Border.all(
            color: effectiveBorderColor, // Ensure the border color is applied
            width: 1,
          )
              : null,
        ),
        child: Material(
          color: Colors.transparent, // Make sure the material color is transparent
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, color: effectiveTextColor),
                  if (icon != null) SizedBox(width: 10),
                  Text(
                    text,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 18,
                          color: effectiveTextColor, // Set dynamic text color here
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
