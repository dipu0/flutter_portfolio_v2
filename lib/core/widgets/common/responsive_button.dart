import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_text.dart';

enum ButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  ghost,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? minWidth;
  final double? maxWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Widget? icon;
  final bool iconAfter;
  final double? iconSpacing;
  final bool enableLoadingState;
  final bool isLoading;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.minWidth,
    this.maxWidth,
    this.padding,
    this.borderRadius,
    this.icon,
    this.iconAfter = false,
    this.iconSpacing,
    this.enableLoadingState = false,
    this.isLoading = false,
  });

  double _getBaseElevation() {
    switch (variant) {
      case ButtonVariant.primary:
        return 2.0;
      case ButtonVariant.secondary:
        return 1.0;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
      case ButtonVariant.ghost:
        return 0.0;
    }
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (padding != null) return padding!;

    final basePadding = switch (size) {
      ButtonSize.small => ResponsiveHelper.getResponsiveValue<EdgeInsets>(
          context: context,
          mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          smallLaptop: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          largeDesktop:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
      ButtonSize.medium => ResponsiveHelper.getResponsiveValue<EdgeInsets>(
          context: context,
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          smallLaptop: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          largeDesktop:
              const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
        ),
      ButtonSize.large => ResponsiveHelper.getResponsiveValue<EdgeInsets>(
          context: context,
          mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          smallLaptop: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
          desktop: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          largeDesktop:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
        ),
    };

    // Adjust padding if icon is present
    if (icon != null) {
      final iconSpacing = this.iconSpacing ?? _getIconSpacing(context);
      if (iconAfter) {
        return basePadding.copyWith(right: basePadding.right - iconSpacing / 2);
      } else {
        return basePadding.copyWith(left: basePadding.left - iconSpacing / 2);
      }
    }

    return basePadding;
  }

  double _getResponsiveMinWidth(BuildContext context) {
    if (minWidth != null) return minWidth!;

    return switch (size) {
      ButtonSize.small => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 80.0,
          tablet: 90.0,
          smallLaptop: 95.0,
          desktop: 100.0,
          largeDesktop: 110.0,
        ),
      ButtonSize.medium => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 120.0,
          tablet: 140.0,
          smallLaptop: 150.0,
          desktop: 160.0,
          largeDesktop: 180.0,
        ),
      ButtonSize.large => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 140.0,
          tablet: 160.0,
          smallLaptop: 170.0,
          desktop: 180.0,
          largeDesktop: 200.0,
        ),
    };
  }

  double _getIconSpacing(BuildContext context) {
    return switch (size) {
      ButtonSize.small => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 6.0,
          tablet: 7.0,
          smallLaptop: 7.5,
          desktop: 8.0,
          largeDesktop: 9.0,
        ),
      ButtonSize.medium => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 8.0,
          tablet: 9.0,
          smallLaptop: 9.5,
          desktop: 10.0,
          largeDesktop: 11.0,
        ),
      ButtonSize.large => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 10.0,
          tablet: 11.0,
          smallLaptop: 11.5,
          desktop: 12.0,
          largeDesktop: 13.0,
        ),
    };
  }

  double _getIconSize(BuildContext context) {
    return switch (size) {
      ButtonSize.small => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 16.0,
          tablet: 17.0,
          smallLaptop: 17.5,
          desktop: 18.0,
          largeDesktop: 19.0,
        ),
      ButtonSize.medium => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 18.0,
          tablet: 19.0,
          smallLaptop: 19.5,
          desktop: 20.0,
          largeDesktop: 21.0,
        ),
      ButtonSize.large => ResponsiveHelper.getResponsiveValue<double>(
          context: context,
          mobile: 20.0,
          tablet: 21.0,
          smallLaptop: 21.5,
          desktop: 22.0,
          largeDesktop: 23.0,
        ),
    };
  }

  (double, double, double, double, double) _getFontSizes() {
    return switch (size) {
      ButtonSize.small => (12.0, 13.0, 13.5, 14.0, 15.0),
      ButtonSize.medium => (14.0, 15.0, 15.5, 16.0, 17.0),
      ButtonSize.large => (16.0, 17.0, 17.5, 18.0, 19.0),
    };
  }

  ButtonStyle _getButtonStyle(BuildContext context, ThemeData theme) {
    final responsivePadding = _getResponsivePadding(context);
    final responsiveMinWidth = _getResponsiveMinWidth(context);
    final borderRadius = this.borderRadius ?? BorderRadius.circular(8);

    return switch (variant) {
      ButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: textColor ?? theme.colorScheme.onPrimary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize:
              maxWidth != null ? Size(maxWidth!, double.infinity) : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: _getBaseElevation(),
        ),
      ButtonVariant.secondary => ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
          foregroundColor: textColor ?? theme.colorScheme.onSecondary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize:
              maxWidth != null ? Size(maxWidth!, double.infinity) : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: _getBaseElevation(),
        ),
      ButtonVariant.outlined => OutlinedButton.styleFrom(
          foregroundColor: textColor ?? theme.colorScheme.primary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize:
              maxWidth != null ? Size(maxWidth!, double.infinity) : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          side: BorderSide(
            color: borderColor ?? backgroundColor ?? theme.colorScheme.primary,
          ),
        ),
      ButtonVariant.text => TextButton.styleFrom(
          foregroundColor: textColor ?? theme.colorScheme.primary,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize:
              maxWidth != null ? Size(maxWidth!, double.infinity) : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ButtonVariant.ghost => TextButton.styleFrom(
          foregroundColor: textColor ?? theme.colorScheme.onSurface,
          backgroundColor: Colors.transparent,
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          maximumSize:
              maxWidth != null ? Size(maxWidth!, double.infinity) : null,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
    };
  }

  Widget _buildButtonContent(BuildContext context) {
    final (
      mobileFontSize,
      tabletFontSize,
      smallLaptopFontSize,
      desktopFontSize,
      largeFontSize
    ) = _getFontSizes();
    final iconSize = _getIconSize(context);
    final iconSpacing = this.iconSpacing ?? _getIconSpacing(context);

    if (isLoading && enableLoadingState) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    final textWeight = switch (size) {
      ButtonSize.small => TextWeight.medium,
      ButtonSize.medium => TextWeight.semiBold,
      ButtonSize.large => TextWeight.semiBold,
    };

    final textWidget = ResponsiveText(
      text,
      variant: TextVariant.label,
      weight: textWeight,
      color: textColor,
      mobileFontSize: mobileFontSize,
      tabletFontSize: tabletFontSize,
      smallLaptopFontSize: smallLaptopFontSize,
      desktopFontSize: desktopFontSize,
      largeDesktopFontSize: largeFontSize,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      enableHapticFeedback: false,
    );

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = SizedBox(
      width: iconSize,
      height: iconSize,
      child: IconTheme(
        data: IconThemeData(
          size: iconSize,
          color: textColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
        child: icon!,
      ),
    );

    return iconAfter
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: textWidget),
              SizedBox(width: iconSpacing),
              iconWidget,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              SizedBox(width: iconSpacing),
              Flexible(child: textWidget),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(context, theme);
    final content = _buildButtonContent(context);

    return switch (variant) {
      ButtonVariant.primary || ButtonVariant.secondary => ElevatedButton(
          onPressed: (isLoading && enableLoadingState) ? null : onPressed,
          style: buttonStyle,
          child: content,
        ),
      ButtonVariant.outlined => OutlinedButton(
          onPressed: (isLoading && enableLoadingState) ? null : onPressed,
          style: buttonStyle,
          child: content,
        ),
      ButtonVariant.text || ButtonVariant.ghost => TextButton(
          onPressed: (isLoading && enableLoadingState) ? null : onPressed,
          style: buttonStyle,
          child: content,
        ),
    };
  }
}
