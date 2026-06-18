// =============================================================================
// IronLink — Design Tokens (Flutter)
// -----------------------------------------------------------------------------
// Platform-agnostic design decisions expressed as Dart consts, mirroring
// `ironlink.tokens.json` (the cross-platform source) and `styles/ironlink.css`
// (the web reference). DESIGN reference — drop into the app's lib/ and wire to
// ThemeData, or read via `Theme.of(context).extension<IronlinkTokens>()`.
//
// Tiers:
//   _P*   primitive   — raw values, not used directly by widgets
//   IlColor / IlType / IlSpace / IlRadius / IlShadow / IlMotion  — semantic
//   IlComp*            — component-level decisions
//
// Fonts: declare "Archivo" and "Archivo Expanded" in pubspec.yaml (or
// google_fonts). Spacing/radius values are logical pixels == Flutter units.
// =============================================================================

// ThemeExtension + Color/TextStyle/etc. all come from material.dart.
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PRIMITIVES (private — reference via the semantic layer below)
// Some primitives are intentionally unused by the semantic layer today but kept
// for completeness / future theming, so silence the unused-field lint here.
// ─────────────────────────────────────────────────────────────────────────────
// ignore_for_file: unused_field
abstract final class _P {
  // yellow
  static const yellow500 = Color(0xFFFFD53F);
  static const yellow600 = Color(0xFFF5C400);
  static const yellow300 = Color(0xFFFFF7DC);
  static const yellow200b = Color(0xFFFEFAE9);
  static const yellowInkOn = Color(0xFF8A6D00);
  // ink / navy
  static const ink900 = Color(0xFF162138);
  static const ink800 = Color(0xFF1E2C4A);
  static const ink700 = Color(0xFF2A3A5C);
  static const ink950 = Color(0xFF0B0F18);
  // slate / neutrals
  static const slate600 = Color(0xFF596682);
  static const slate400 = Color(0xFFA0AABF);
  static const slate300 = Color(0xFFD6DCEA);
  static const slate200 = Color(0xFFE7EBF4);
  static const slate100 = Color(0xFFF4F6FB);
  static const slate50 = Color(0xFFF7F9FD);
  static const mutedOnDark = Color(0xFF9FB0D0);
  static const white = Color(0xFFFFFFFF);
  // semantic hues
  static const green500 = Color(0xFF2E9E6B);
  static const greenTint = Color(0xFFE6F5EE);
  static const red500 = Color(0xFFD8453B);
  static const redTint = Color(0xFFFBE7E5);
  static const amber500 = Color(0xFFE08A00);
  static const amberTint = Color(0xFFFDF0D9);
  static const amberInkOn = Color(0xFF8A5A00);
  static const blue500 = Color(0xFF3768C4);
  static const blueTint = Color(0xFFE7EEFA);
}

// ─────────────────────────────────────────────────────────────────────────────
// SEMANTIC — COLOR (role-based; this is what UI reads)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class IlColor {
  // brand
  static const accent = _P.yellow500; // primary action / single highlight
  static const accentPressed = _P.yellow600;
  static const accentWash = _P.yellow200b;
  static const onAccent = _P.ink900;
  static const ink = _P.ink900; // dark heavyweight actions
  static const onInk = _P.white;

  // surfaces
  static const bg = _P.slate100;
  static const surface = _P.white;
  static const surfaceAlt = _P.slate50;
  static const border = _P.slate200;
  static const borderStrong = _P.slate300;

  // text
  static const textPrimary = _P.ink900;
  static const textSecondary = _P.slate600;
  static const textTertiary = _P.slate400;
  static const textOnDark = _P.white;
  static const textMutedOnDark = _P.mutedOnDark;

  // feedback (each has a *Bg tint)
  static const positive = _P.green500;
  static const positiveBg = _P.greenTint;
  static const danger = _P.red500;
  static const dangerBg = _P.redTint;
  static const warning = _P.amber500;
  static const warningBg = _P.amberTint;
  static const warningText = _P.amberInkOn;
  static const info = _P.blue500;
  static const infoBg = _P.blueTint;

  // device chrome
  static const frame = _P.ink950;
}

// ─────────────────────────────────────────────────────────────────────────────
// SEMANTIC — SPACING & RADII (4-pt grid)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class IlSpace {
  static const s1 = 4.0, s2 = 8.0, s3 = 12.0, s4 = 16.0;
  static const s5 = 20.0, s6 = 24.0, s7 = 32.0, s8 = 40.0;

  static const gutter = s5; // screen left/right padding
  static const cardGap = s3; // gap between stacked cards
}

abstract final class IlRadius {
  static const xs = 6.0, sm = 10.0, md = 14.0, lg = 18.0, xl = 24.0;
  static const pill = 999.0;

  static const Radius rXs = Radius.circular(xs);
  static const Radius rSm = Radius.circular(sm);
  static const Radius rMd = Radius.circular(md);
  static const Radius rLg = Radius.circular(lg);
  static const Radius rXl = Radius.circular(xl);
}

// ─────────────────────────────────────────────────────────────────────────────
// SEMANTIC — TYPOGRAPHY
// lineHeight expressed as Flutter `height` (== ratio). letterSpacing in logical
// px (converted from em at the given size). Set `color` at the call site.
// ─────────────────────────────────────────────────────────────────────────────
abstract final class IlFont {
  static const display = 'Archivo Expanded';
  static const text = 'Archivo';
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
}

abstract final class IlType {
  static const display = TextStyle(
      fontFamily: IlFont.display, fontWeight: IlFont.extrabold,
      fontSize: 30, height: 1.08, letterSpacing: -0.3);
  static const h1 = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.extrabold,
      fontSize: 26, height: 1.12, letterSpacing: -0.52);
  static const h2 = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.bold,
      fontSize: 20, height: 1.18, letterSpacing: -0.2);
  static const h3 = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.bold, fontSize: 16, height: 1.25);
  static const body = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.regular, fontSize: 15, height: 1.5);
  static const bodyMedium = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.medium, fontSize: 15, height: 1.5);
  static const small = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.regular, fontSize: 13, height: 1.45);
  static const smallStrong = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.semibold, fontSize: 13, height: 1.4);
  static const xs = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.medium, fontSize: 11.5, height: 1.35);
  static const metric = TextStyle(
      fontFamily: IlFont.display, fontWeight: IlFont.extrabold,
      fontSize: 38, height: 1.0, letterSpacing: -0.76,
      fontFeatures: [FontFeature.tabularFigures()]);
  static const metricSm = TextStyle(
      fontFamily: IlFont.display, fontWeight: IlFont.extrabold,
      fontSize: 26, height: 1.0, fontFeatures: [FontFeature.tabularFigures()]);
  static const eyebrow = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.bold,
      fontSize: 11, height: 1.2, letterSpacing: 1.1);
}

// ─────────────────────────────────────────────────────────────────────────────
// SEMANTIC — ELEVATION
// ─────────────────────────────────────────────────────────────────────────────
abstract final class IlShadow {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F162138), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0A162138), offset: Offset(0, 1), blurRadius: 1),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x14162138), offset: Offset(0, 4), blurRadius: 16),
    BoxShadow(color: Color(0x0D162138), offset: Offset(0, 1), blurRadius: 3),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x24162138), offset: Offset(0, 12), blurRadius: 32),
    BoxShadow(color: Color(0x14162138), offset: Offset(0, 4), blurRadius: 10),
  ];
  static const List<BoxShadow> accent = [
    BoxShadow(color: Color(0x6BFFBD00), offset: Offset(0, 8), blurRadius: 20),
  ];
  static const List<BoxShadow> ink = [
    BoxShadow(color: Color(0x4D162138), offset: Offset(0, 8), blurRadius: 22),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// SEMANTIC — MOTION
// ─────────────────────────────────────────────────────────────────────────────
abstract final class IlMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration dialog = Duration(milliseconds: 200);
  static const Duration pop = Duration(milliseconds: 250);
  static const Duration sheet = Duration(milliseconds: 280);
  static const Duration page = Duration(milliseconds: 300);
  static const Duration staggerStep = Duration(milliseconds: 40);

  static const Cubic standard = Cubic(0.4, 0, 0.2, 1);
  static const Cubic entrance = Cubic(0.3, 0, 0.4, 1);
  static const Cubic exit = Cubic(0.4, 0, 1, 1);

  static const double pressScale = 0.97;
  static const double scrimOpacity = 0.45;
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPONENT TOKENS
// ─────────────────────────────────────────────────────────────────────────────
abstract final class IlButton {
  static const double heightSm = 40, heightMd = 52, heightLg = 56;
  static const double radius = IlRadius.md, radiusSm = IlRadius.sm;
  static const double paddingX = IlSpace.s5, gap = IlSpace.s2;
  static const font = TextStyle(
      fontFamily: IlFont.text, fontWeight: IlFont.bold, fontSize: 15, letterSpacing: 0.15);
  // intents: (bg, fg, shadow)
  static const primaryBg = IlColor.accent, primaryFg = IlColor.onAccent, primaryBgPressed = IlColor.accentPressed;
  static const darkBg = IlColor.ink, darkFg = IlColor.onInk;
  static const outlineBg = IlColor.surface, outlineFg = IlColor.textPrimary, outlineBorder = IlColor.borderStrong;
  static const double outlineBorderWidth = 1.5;
  static const dangerBg = IlColor.dangerBg, dangerFg = IlColor.danger;
  static const disabledBg = IlColor.surfaceAlt, disabledFg = IlColor.textTertiary;
}

abstract final class IlCard {
  static const bg = IlColor.surface, border = IlColor.border;
  static const double radius = IlRadius.lg, padding = IlSpace.s5;
  static const highlightBg = IlColor.accentWash, highlightBorder = IlColor.accent;
  static const darkBg = IlColor.ink;
  static const List<BoxShadow> shadow = IlShadow.sm;
}

abstract final class IlInput {
  static const double height = 52, radius = IlRadius.md, paddingX = IlSpace.s4, borderWidth = 1.5;
  static const fill = IlColor.surface, border = IlColor.border;
  static const borderFocus = IlColor.ink, borderError = IlColor.danger, placeholder = IlColor.textTertiary;
}

abstract final class IlChip {
  static const double height = 36, radius = IlRadius.pill, paddingX = IlSpace.s4;
  static const bg = IlColor.surface, fg = IlColor.textSecondary, border = IlColor.border;
  static const activeBg = IlColor.accent, activeFg = IlColor.onAccent;
}

abstract final class IlTag {
  static const double height = 24, radius = IlRadius.sm;
  static const font = TextStyle(fontFamily: IlFont.text, fontWeight: IlFont.bold, fontSize: 11.5, height: 1);
  static const matchBg = IlColor.ink, matchFg = IlColor.accent; // "92% match"
}

abstract final class IlTabbar {
  static const double height = 92, fabSize = 58;
  static const bg = IlColor.surface; // render @ ~94% opacity + blur
  static const borderTop = IlColor.border;
  static const itemActive = IlColor.ink, itemInactive = IlColor.textTertiary;
  static const itemLabel = TextStyle(fontFamily: IlFont.text, fontWeight: IlFont.semibold, fontSize: 10.5, height: 1);
  static const fabWorkerBg = IlColor.accent, fabWorkerFg = IlColor.onAccent; // yellow
  static const fabEmployerBg = IlColor.ink, fabEmployerFg = IlColor.onInk; // ink
}

abstract final class IlAvatar {
  static const double xs = 28, sm = 34, md = 40, lg = 56, xl = 84;
  static const bg = IlColor.ink, fg = IlColor.textOnDark;
  static const double orgRadius = IlRadius.md; // companies = squared
}

abstract final class IlIcon {
  static const double strokeWidth = 1.9;
  static const double sm = 18, md = 22, lg = 26, xl = 30;
}

abstract final class IlSheet {
  static const double radiusTop = IlRadius.xl;
  static const bg = IlColor.surface, grab = IlColor.borderStrong;
  static const scrim = Color(0x73162138); // ink @ 45%
  static const List<BoxShadow> shadow = IlShadow.lg;
  static const Duration enter = IlMotion.sheet;
  static const Cubic enterCurve = IlMotion.entrance;
}

abstract final class IlDialog {
  static const double radius = IlRadius.xl, maxWidth = 320;
  static const Duration enter = IlMotion.dialog;
}

abstract final class IlProgress {
  static const track = IlColor.border, fill = IlColor.accent;
  static const double height = 8;
}

// ─────────────────────────────────────────────────────────────────────────────
// THEME EXTENSION — ergonomic access via Theme.of(context).extension<IronlinkTokens>()
// Exposes the role colors that Material's ColorScheme can't carry 1:1
// (tints, tertiary text, border-strong, etc.).
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class IronlinkTokens extends ThemeExtension<IronlinkTokens> {
  final Color surfaceAlt, border, borderStrong;
  final Color textSecondary, textTertiary;
  final Color positive, positiveBg, danger, dangerBg, warning, warningBg, info, infoBg;
  final Color accentWash;

  const IronlinkTokens({
    this.surfaceAlt = IlColor.surfaceAlt,
    this.border = IlColor.border,
    this.borderStrong = IlColor.borderStrong,
    this.textSecondary = IlColor.textSecondary,
    this.textTertiary = IlColor.textTertiary,
    this.positive = IlColor.positive,
    this.positiveBg = IlColor.positiveBg,
    this.danger = IlColor.danger,
    this.dangerBg = IlColor.dangerBg,
    this.warning = IlColor.warning,
    this.warningBg = IlColor.warningBg,
    this.info = IlColor.info,
    this.infoBg = IlColor.infoBg,
    this.accentWash = IlColor.accentWash,
  });

  @override
  IronlinkTokens copyWith({Color? surfaceAlt, Color? border, Color? borderStrong,
      Color? textSecondary, Color? textTertiary, Color? positive, Color? positiveBg,
      Color? danger, Color? dangerBg, Color? warning, Color? warningBg, Color? info,
      Color? infoBg, Color? accentWash}) {
    return IronlinkTokens(
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      positive: positive ?? this.positive,
      positiveBg: positiveBg ?? this.positiveBg,
      danger: danger ?? this.danger,
      dangerBg: dangerBg ?? this.dangerBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
      accentWash: accentWash ?? this.accentWash,
    );
  }

  @override
  IronlinkTokens lerp(ThemeExtension<IronlinkTokens>? other, double t) {
    if (other is! IronlinkTokens) return this;
    return IronlinkTokens(
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      positiveBg: Color.lerp(positiveBg, other.positiveBg, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      accentWash: Color.lerp(accentWash, other.accentWash, t)!,
    );
  }
}
