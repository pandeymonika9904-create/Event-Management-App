import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: isOutlined
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              color: Colors.transparent,
            )
          : BoxDecoration(
              gradient: isLoading ? null : AppTheme.primaryGradient,
              color: isLoading ? Colors.grey.withOpacity(0.5) : null,
              borderRadius: BorderRadius.circular(28),
              boxShadow: isLoading || isOutlined
                  ? []
                  : [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: _buildChild(isOutlined ? AppTheme.primaryColor : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2.5,
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }
}
