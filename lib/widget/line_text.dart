import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineText extends StatelessWidget {
  LineText(this.text,
      {Key? key,
      this.maxLine = 2,
      this.style,
      this.direction = Axis.horizontal})
      : super(key: key);

  final String text;
  final int? maxLine;
  final TextStyle? style;

  final show = false.obs;

  final Axis? direction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        TextStyle textStyle = style ?? const TextStyle();
        final temp =
            textExceedMaxLines(text, textStyle, maxLine!, constraints.maxWidth);

        return Obx(() {
          Widget content = Text(
            text,
            style: textStyle,
            maxLines: temp
                ? show.value
                    ? null
                    : maxLine
                : maxLine,
          );

          Widget action = InkWell(
            onTap: () {
              show(!show.value);
            },
            child: Text(show.value ? "收起" : "展开"),
          );

          if (direction == Axis.horizontal) {
            return Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 12),
                if (temp) action,
              ],
            );
          } else {
            return Column(
              children: [
                content,
                const SizedBox(height: 12),
                if (temp) action,
              ],
            );
          }
        });
      },
    );
  }

  bool textExceedMaxLines(
      String text, TextStyle textStyle, int maxLine, double maxWidth) {
    TextSpan textSpan = TextSpan(text: text, style: textStyle);
    TextPainter textPainter = TextPainter(
        text: textSpan, maxLines: maxLine, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: maxWidth);
    if (textPainter.didExceedMaxLines) {
      return true;
    }
    return false;
  }
}
