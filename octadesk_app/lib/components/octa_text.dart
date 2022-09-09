import 'package:flutter/material.dart';

enum TextStyleEnum {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  labelLarge,
  labelMedium,
  labelSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
}

class OctaText extends StatelessWidget {
  final String content;
  final TextStyleEnum? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const OctaText(this.content, {this.style, this.textAlign, this.maxLines, this.overflow, Key? key}) : super(key: key);

  factory OctaText.displayLarge(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.displayLarge,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.displayMedium(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.displayMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.displaySmall(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.displaySmall,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.headlineLarge(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.headlineLarge,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.headlineMedium(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.headlineMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.headlineSmall(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.headlineSmall,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.titleLarge(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.titleLarge,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.titleMedium(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.titleMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.titleSmall(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.titleSmall,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.labelLarge(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.labelLarge,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.labelMedium(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.labelMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.labelSmall(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.labelSmall,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.bodyLarge(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.bodyLarge,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.bodyMedium(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.bodyMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  factory OctaText.bodySmall(String content, {TextAlign? textAlign, int? maxLines, TextOverflow? overflow}) {
    return OctaText(
      content,
      style: TextStyleEnum.bodySmall,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    // Função para retornar
    TextStyle? getTextStyle() {
      switch (style) {
        case TextStyleEnum.displayLarge:
          return theme.displayLarge;

        case TextStyleEnum.displayMedium:
          return theme.displayMedium;

        case TextStyleEnum.displaySmall:
          return theme.displaySmall;

        case TextStyleEnum.headlineLarge:
          return theme.headlineLarge;

        case TextStyleEnum.headlineMedium:
          return theme.headlineMedium;

        case TextStyleEnum.headlineSmall:
          return theme.headlineSmall;

        case TextStyleEnum.titleLarge:
          return theme.titleLarge;

        case TextStyleEnum.titleMedium:
          return theme.titleMedium;

        case TextStyleEnum.titleSmall:
          return theme.titleSmall;

        case TextStyleEnum.labelLarge:
          return theme.labelLarge;

        case TextStyleEnum.labelMedium:
          return theme.labelMedium;

        case TextStyleEnum.labelSmall:
          return theme.labelSmall;

        case TextStyleEnum.bodyLarge:
          return theme.bodyLarge;

        case TextStyleEnum.bodyMedium:
          return theme.bodyMedium;

        case TextStyleEnum.bodySmall:
          return theme.bodySmall;

        default:
          return theme.bodyMedium;
      }
    }

    return Text(
      content,
      style: getTextStyle(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
