import 'package:flutter/material.dart';

class AppSpacing {
  // المسافات الأساسية
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // المسافات المخصصة
  static const double cardPadding = 16.0;
  static const double screenPadding = 20.0;
  static const double sectionSpacing = 32.0;
  static const double itemSpacing = 12.0;
  static const double buttonSpacing = 16.0;
  
  // Padding constants
  static const EdgeInsets paddingTopXS = EdgeInsets.only(top: xs);
  static const EdgeInsets paddingBottomSM = EdgeInsets.only(bottom: sm);
  
  // Icon sizes
  static const double iconSizeXSmall = 16.0;

  // المسافات العمودية
  static const SizedBox verticalXS = SizedBox(height: xs);
  static const SizedBox verticalSM = SizedBox(height: sm);
  static const SizedBox verticalMD = SizedBox(height: md);
  static const SizedBox verticalLG = SizedBox(height: lg);
  static const SizedBox verticalXL = SizedBox(height: xl);
  static const SizedBox verticalXXL = SizedBox(height: xxl);
  static const SizedBox verticalXXXL = SizedBox(height: xxxl);

  // المسافات الأفقية
  static const SizedBox horizontalXS = SizedBox(width: xs);
  static const SizedBox horizontalSM = SizedBox(width: sm);
  static const SizedBox horizontalMD = SizedBox(width: md);
  static const SizedBox horizontalLG = SizedBox(width: lg);
  static const SizedBox horizontalXL = SizedBox(width: xl);
  static const SizedBox horizontalXXL = SizedBox(width: xxl);
  static const SizedBox horizontalXXXL = SizedBox(width: xxxl);

  // الحواف والزوايا
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 50.0;

  // BorderRadius المحددة مسبقاً
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderRadiusCircle = BorderRadius.all(Radius.circular(radiusCircle));

  // BorderRadius للبطاقات
  static const BorderRadius cardBorderRadius = borderRadiusXL;
  static const BorderRadius buttonBorderRadius = borderRadiusMD;
  static const BorderRadius inputBorderRadius = borderRadiusLG;

  // Button specific spacing
  static const EdgeInsets buttonPaddingXLarge = EdgeInsets.symmetric(horizontal: xl, vertical: lg);

  // EdgeInsets المحددة مسبقاً
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  // EdgeInsets للشاشات
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: screenPadding);

  // EdgeInsets للبطاقات
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);
  static const EdgeInsets cardPaddingHorizontal = EdgeInsets.symmetric(horizontal: cardPadding);
  static const EdgeInsets cardPaddingVertical = EdgeInsets.symmetric(vertical: cardPadding);

  // EdgeInsets للأزرار
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets buttonPaddingMedium = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(horizontal: xl, vertical: lg);

  // EdgeInsets للحقول النصية
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: md);
  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);

  // المسافات للشبكات
  static const double gridSpacingSmall = sm;
  static const double gridSpacingMedium = md;
  static const double gridSpacingLarge = lg;

  // المسافات للقوائم
  static const double listItemSpacing = md;
  static const double listSectionSpacing = xl;

  // الارتفاعات والظلال
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationVeryHigh = 16.0;

  // أحجام الأيقونات
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // أحجام الصور المصغرة
  static const double thumbnailSizeSmall = 40.0;
  static const double thumbnailSizeMedium = 60.0;
  static const double thumbnailSizeLarge = 80.0;
  static const double thumbnailSizeXLarge = 120.0;

  // المسافات للتنقل
  static const double bottomNavHeight = 60.0;
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;

  // المسافات للحوارات
  static const EdgeInsets dialogPadding = EdgeInsets.all(lg);
  static const EdgeInsets dialogContentPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets dialogActionsPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);

  // المسافات للقوائم المنسدلة
  static const EdgeInsets dropdownPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets dropdownItemPadding = EdgeInsets.symmetric(horizontal: md, vertical: md);

  // المسافات للبحث
  static const EdgeInsets searchBarPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets searchResultPadding = EdgeInsets.all(md);

  // دوال مساعدة للمسافات المخصصة
  static SizedBox verticalSpace(double height) => SizedBox(height: height);
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);
  
  static EdgeInsets symmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    );
  }
  
  static EdgeInsets only({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
    );
  }
  
  static BorderRadius customRadius({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 0),
      topRight: Radius.circular(topRight ?? 0),
      bottomLeft: Radius.circular(bottomLeft ?? 0),
      bottomRight: Radius.circular(bottomRight ?? 0),
    );
  }
}

// ويدجت مساعد للمسافات
class SpacedColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SpacedColumn({
    Key? key,
    required this.children,
    this.spacing = AppSpacing.md,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacedChildren,
    );
  }
}

class SpacedRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SpacedRow({
    Key? key,
    required this.children,
    this.spacing = AppSpacing.md,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: spacing));
      }
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacedChildren,
    );
  }
}