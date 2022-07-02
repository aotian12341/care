import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, {this.start})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;
  @override
  InlineSpan finishText() {
    final String key = toString();

    if (EmojiUtil().emojiMap.containsKey(key)) {
      //fontsize id define image height
      //size = 30.0/26.0 * fontSize
      const double size = 20.0;

      ///fontSize 26 and text height =30.0
      //final double fontSize = 26.0;
      return ImageSpan(
          AssetImage(
            "assets/images/emoji/${EmojiUtil().emojiMap[key]!}.png",
          ),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          fit: BoxFit.fill,
          margin: const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUtil {
  static EmojiUtil? _singleton;

  /// 单例
  factory EmojiUtil() {
    _singleton ??= EmojiUtil._();
    return _singleton!;
  }

  EmojiUtil._();

  ///
  Map<String, String> get emojiMap => _emojiMap;
  final Map<String, String> _emojiMap = <String, String>{
    '[微笑]': 'weixiao',
    '[撇嘴]': 'piezui',
    '[色]': 'se',
    '[发呆]': 'fadai',
    '[得意]': 'deyi',
    '[流泪]': 'liulei',
    '[害羞]': 'haixiu',
    '[闭嘴]': 'bizui',
    '[睡]': 'shui',
    '[大哭]': 'daku',
    '[尴尬]': 'ganga',
    '[发怒]': 'fanu',
    '[调皮]': 'tiaopi',
    '[呲牙]': 'ciya',
    '[惊讶]': 'jingya',
    '[难过]': 'nanguo',
    '[囧]': 'jiong',
    '[抓狂]': 'zhuakuang',
    '[吐]': 'tu',
    '[偷笑]': 'touxiao',
    '[白眼]': 'baiyan',
    '[傲慢]': 'aoman',
    '[困]': 'kun',
    '[惊恐]': 'jingkong',
    '[憨笑]': 'hanxiao',
    '[咒骂]': 'zhouma',
    '[疑问]': 'yiwen',
    '[嘘]': 'xu',
    '[晕]': 'yun',
    '[衰]': 'shuai',
    '[再见]': 'zaijian',
    '[擦汗]': 'cahan',
    '[抠鼻]': 'koubi',
    '[鼓掌]': 'guzhang',
    '[坏笑]': 'huaixiao',
    '[右哼哼]': 'youhengheng',
    '[委屈]': 'weiqu',
    '[快哭了]': 'kuaikule',
    '[阴险]': 'yinxian',
    '[亲亲]': 'qinqin',
    '[可怜]': 'kelian',
    '[笑脸]': 'xiaolian',
    '[脸红]': 'lianhong',
    '[破涕为笑]': 'potiweixiao',
    '[失望]': 'shiwang',
    '[无语]': 'wuyu',
    '[奸笑]': 'jianxiao',
    '[皱眉]': 'zhoumei',
    '[汗]': 'han',
    '[天啊]': 'tiana',
    '[Emm]': 'emm',
    '[翻白眼]': 'fanbaiyan',
    '[叹气]': 'tanqi',
    '[苦涩]': 'kuse',
  };
}

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false});

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    }
    return null;
  }
}
