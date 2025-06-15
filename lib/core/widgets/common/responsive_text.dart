import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

enum TextVariant {
  display,
  headline,
  title,
  body,
  label,
  caption,
}

enum TextWeight {
  light,
  regular,
  medium,
  semiBold,
  bold,
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? smallLaptopFontSize;
  final double? desktopFontSize;
  final double? largeDesktopFontSize;

  final bool enableInteractiveSelection;
  final bool enableCopyOnLongPress;
  final bool enableHapticFeedback;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(String)? onSelectionChanged;

  final TextWeight? weight;
  final Color? color;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final List<Shadow>? shadows;

  final String? semanticsLabel;
  final bool excludeFromSemantics;
  final TextDirection? textDirection;

  const ResponsiveText(
    this.text, {
    super.key,
    this.variant = TextVariant.body,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.mobileFontSize,
    this.tabletFontSize,
    this.smallLaptopFontSize,
    this.desktopFontSize,
    this.largeDesktopFontSize,
    this.enableInteractiveSelection = true,
    this.enableCopyOnLongPress = false,
    this.enableHapticFeedback = true,
    this.onTap,
    this.onLongPress,
    this.onSelectionChanged,
    this.weight,
    this.color,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.shadows,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.textDirection,
  });

  const ResponsiveText.display(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextWeight? weight,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.display,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          weight: weight,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.headline(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextWeight? weight,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.headline,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          weight: weight,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.title(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextWeight? weight,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.title,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          weight: weight,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.body(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.body,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.label(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    Color? color,
    TextWeight? weight,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.label,
          style: style,
          textAlign: textAlign,
          color: color,
          weight: weight,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  const ResponsiveText.caption(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    VoidCallback? onTap,
    String? semanticsLabel,
  }) : this(
          text,
          key: key,
          variant: TextVariant.caption,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          color: color,
          onTap: onTap,
          semanticsLabel: semanticsLabel,
        );

  (double, double, double, double, double) _getVariantFontSizes() {
    return switch (variant) {
      TextVariant.display => (32.0, 40.0, 48.0, 56.0, 64.0),
      TextVariant.headline => (24.0, 28.0, 32.0, 36.0, 40.0),
      TextVariant.title => (18.0, 20.0, 22.0, 24.0, 26.0),
      TextVariant.body => (14.0, 16.0, 16.0, 18.0, 20.0),
      TextVariant.label => (12.0, 14.0, 14.0, 16.0, 16.0),
      TextVariant.caption => (10.0, 12.0, 12.0, 14.0, 14.0),
    };
  }

  FontWeight _getTextWeight() {
    final variantWeight = switch (variant) {
      TextVariant.display => TextWeight.bold,
      TextVariant.headline => TextWeight.semiBold,
      TextVariant.title => TextWeight.medium,
      TextVariant.body => TextWeight.regular,
      TextVariant.label => TextWeight.medium,
      TextVariant.caption => TextWeight.regular,
    };
    final effectiveWeight = weight ?? variantWeight;
    return switch (effectiveWeight) {
      TextWeight.light => FontWeight.w300,
      TextWeight.regular => FontWeight.w400,
      TextWeight.medium => FontWeight.w500,
      TextWeight.semiBold => FontWeight.w600,
      TextWeight.bold => FontWeight.w700,
    };
  }

  double _getResponsiveFontSize(BuildContext context) {
    final (mobile, tablet, smallLaptop, desktop, largeDesktop) =
        _getVariantFontSizes();

    return context.responsiveValue<double>(
      mobile: mobileFontSize ?? mobile,
      tablet: tabletFontSize ?? tablet,
      smallLaptop: smallLaptopFontSize ?? smallLaptop,
      desktop: desktopFontSize ?? desktop,
      largeDesktop: largeDesktopFontSize ?? largeDesktop,
    );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = _getResponsiveFontSize(context);
    final fontWeight = _getTextWeight();

    final baseStyle = switch (variant) {
      TextVariant.display => theme.textTheme.displayLarge,
      TextVariant.headline => theme.textTheme.headlineMedium,
      TextVariant.title => theme.textTheme.titleLarge,
      TextVariant.body => theme.textTheme.bodyLarge,
      TextVariant.label => theme.textTheme.labelLarge,
      TextVariant.caption => theme.textTheme.bodySmall,
    };

    final fallback = TextStyle(fontSize: fontSize, fontWeight: fontWeight);

    return (baseStyle ?? fallback)
        .copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          height: height,
          decoration: decoration,
          shadows: shadows,
        )
        .merge(style);
  }

  void _handleLongPress(BuildContext context) {
    if (enableHapticFeedback) HapticFeedback.mediumImpact();

    if (enableCopyOnLongPress) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Text copied to clipboard'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    onLongPress?.call();
  }

  void _handleTap() {
    if (enableHapticFeedback && onTap != null) HapticFeedback.lightImpact();
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _buildTextStyle(context);

    Widget textWidget;

    if (enableInteractiveSelection) {
      textWidget = SelectableText(
        text,
        style: textStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        onSelectionChanged: (selection, cause) {
          if (selection.start >= 0 &&
              selection.end <= text.length &&
              selection.start < selection.end) {
            final selected = text.substring(selection.start, selection.end);
            onSelectionChanged?.call(selected);
          }
        },
        onTap: _handleTap,
        textDirection: textDirection,
      );
    } else {
      textWidget = Text(
        text,
        style: textStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        semanticsLabel: semanticsLabel,
        textDirection: textDirection,
      );
    }

    if (onTap != null || onLongPress != null || enableCopyOnLongPress) {
      textWidget = GestureDetector(
        onTap: onTap != null ? _handleTap : null,
        onLongPress: (onLongPress != null || enableCopyOnLongPress)
            ? () => _handleLongPress(context)
            : null,
        child: textWidget,
      );
    }

    if (semanticsLabel != null && !excludeFromSemantics) {
      textWidget = Semantics(label: semanticsLabel, child: textWidget);
    } else if (excludeFromSemantics) {
      textWidget = ExcludeSemantics(child: textWidget);
    }

    return textWidget;
  }
}
