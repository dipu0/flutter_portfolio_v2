import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_text.dart';

class SectionHeader extends StatefulWidget {
  final String title;
  final String? subtitle;

  // Title styling
  final TextVariant titleVariant;
  final TextWeight? titleWeight;
  final Color? titleColor;
  final TextStyle? titleStyle;

  // Subtitle styling
  final TextVariant subtitleVariant;
  final TextWeight? subtitleWeight;
  final Color? subtitleColor;
  final TextStyle? subtitleStyle;

  // Layout
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // Interaction
  final VoidCallback? onTitleTap;
  final VoidCallback? onSubtitleTap;

  // Accessibility
  final String? titleSemanticsLabel;
  final String? subtitleSemanticsLabel;

  // Hover
  final Color? hoverColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleVariant = TextVariant.headline,
    this.titleWeight,
    this.titleColor,
    this.titleStyle,
    this.subtitleVariant = TextVariant.title,
    this.subtitleWeight,
    this.subtitleColor,
    this.subtitleStyle,
    this.textAlign = TextAlign.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8.0,
    this.padding,
    this.margin,
    this.onTitleTap,
    this.onSubtitleTap,
    this.titleSemanticsLabel,
    this.subtitleSemanticsLabel,
    this.hoverColor,
  });

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  bool _isHoveringTitle = false;

  CrossAxisAlignment _getCrossAxisAlignment() {
    if (widget.crossAxisAlignment != CrossAxisAlignment.start) {
      return widget.crossAxisAlignment;
    }

    return switch (widget.textAlign) {
      TextAlign.center => CrossAxisAlignment.center,
      TextAlign.end || TextAlign.right => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.start,
    };
  }

  Color _getDefaultSubtitleColor(BuildContext context) {
    final theme = Theme.of(context);
    return widget.subtitleColor ??
        theme.colorScheme.primary.withOpacity(0.8) ??
        theme.textTheme.titleMedium?.color?.withOpacity(0.7) ??
        theme.colorScheme.onSurface.withOpacity(0.7);
  }

  Widget _buildSubtitle(BuildContext context) {
    if (widget.subtitle == null) return const SizedBox.shrink();

    return ResponsiveText(
      widget.subtitle!,
      variant: widget.subtitleVariant,
      weight: widget.subtitleWeight ?? TextWeight.medium,
      color: _getDefaultSubtitleColor(context),
      style: widget.subtitleStyle,
      textAlign: widget.textAlign,
      onTap: widget.onSubtitleTap,
      semanticsLabel: widget.subtitleSemanticsLabel,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final overlayColor =
        widget.hoverColor ?? theme.colorScheme.primary.withOpacity(0.3);
    final textColor = widget.titleColor ?? theme.textTheme.headlineSmall?.color;
    final textStyle = widget.titleStyle ?? theme.textTheme.headlineSmall;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringTitle = true),
      onExit: (_) => setState(() => _isHoveringTitle = false),
      child: GestureDetector(
        onTap: widget.onTitleTap,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: _isHoveringTitle ? (textStyle?.fontSize ?? 32) * 2 : 0,
                  decoration: BoxDecoration(
                    color: overlayColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            ResponsiveText(
              widget.title,
              variant: widget.titleVariant,
              weight: widget.titleWeight ?? TextWeight.bold,
              color: textColor,
              style: widget.titleStyle,
              textAlign: widget.textAlign,
              semanticsLabel: widget.titleSemanticsLabel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final hasSubtitle = widget.subtitle != null;
    final actualCrossAxisAlignment = _getCrossAxisAlignment();

    return Column(
      crossAxisAlignment: actualCrossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSubtitle) ...[
          _buildSubtitle(context),
          SizedBox(height: widget.spacing),
        ],
        _buildTitle(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent(context);

    if (widget.padding != null) {
      content = Padding(
        padding: widget.padding!,
        child: content,
      );
    }

    if (widget.margin != null) {
      content = Container(
        margin: widget.margin,
        child: content,
      );
    }

    return content;
  }
}
