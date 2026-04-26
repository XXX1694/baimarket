import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class _Tile {
  final String slug;
  final Color background;
  final String iconAsset;
  final Color textColor;
  final double iconSize;
  final Offset iconOffset;
  final double iconRotation; // degrees
  final Map<String, String> labels;

  const _Tile({
    required this.slug,
    required this.background,
    required this.iconAsset,
    required this.labels,
    this.textColor = Colors.white,
    this.iconSize = 86,
    this.iconOffset = const Offset(-6, -6),
    this.iconRotation = 0,
  });

  String labelFor(String locale) {
    return labels[locale] ?? labels['ru'] ?? labels.values.first;
  }
}

// Призы — подарок чуть повёрнут влево (CCW), размер ~70% высоты карточки
const _prizeTile = _Tile(
  slug: 'prize',
  background: Color(0xFF3FE0DE),
  iconAsset: 'assets/icons/main/prize.svg',
  iconSize: 50,
  iconOffset: Offset(-3, 0),
  iconRotation: 0,
  labels: {'ru': 'Призы', 'kk': 'Сыйлықтар', 'en': 'Prizes'},
);

// Новинки — широкий текст NEW занимает дно карточки, без доп. поворота
const _newTile = _Tile(
  slug: 'new',
  background: Color(0xFF22923C),
  iconAsset: 'assets/icons/main/new.svg',
  iconSize: 42,
  iconOffset: Offset(0, 0),
  iconRotation: 0,
  labels: {'ru': 'Новинки', 'kk': 'Жаңалықтар', 'en': 'New'},
);

// Хиты — пламя внизу справа, чуть повёрнуто по часовой
const _hitTile = _Tile(
  slug: 'hit',
  background: Color(0xFFB6B4F0),
  iconAsset: 'assets/icons/main/hit.svg',
  iconSize: 61,
  iconOffset: Offset(1, 1),
  iconRotation: 0,
  labels: {'ru': 'Хиты', 'kk': 'Хиттер', 'en': 'Hits'},
);

// Скидки — большие ценники, повёрнуты по часовой ~22°
const _salesTile = _Tile(
  slug: 'sales',
  background: Color(0xFFEF5746),
  iconAsset: 'assets/icons/main/sales.svg',
  iconSize: 78,
  iconOffset: Offset(0, 5),
  iconRotation: 0,
  labels: {'ru': 'Скидки', 'kk': 'Жеңіл-\nдіктер', 'en': 'Discounts'},
);

// Весь каталог — 4 квадрата без поворота, справа в горизонтальном лейауте
const _allTile = _Tile(
  slug: 'all',
  background: Color(0xFFEDEDED),
  iconAsset: 'assets/icons/main/all.svg',
  textColor: Color(0xFF8C8C8C),
  iconSize: 56,
  iconOffset: Offset(11, 8),
  iconRotation: 0,
  labels: {
    'ru': 'Весь\nКаталог',
    'kk': 'Барлық\nкаталог',
    'en': 'Whole\nCatalog',
  },
);

class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryCard(
                    tile: _prizeTile,
                    height: 80,
                    locale: locale,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryCard(
                    tile: _newTile,
                    height: 80,
                    locale: locale,
                  ),
                ),
              ),
              Expanded(
                child: _CategoryCard(
                  tile: _hitTile,
                  height: 80,
                  locale: locale,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryCard(
                    tile: _salesTile,
                    height: 80,
                    locale: locale,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: _CategoryCard(
                  tile: _allTile,
                  height: 80,
                  locale: locale,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.tile,
    required this.locale,
    this.height = 80,
  });

  final _Tile tile;
  final String locale;
  final double height;

  @override
  Widget build(BuildContext context) {
    final label = tile.labelFor(locale);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.push('/collection/${tile.slug}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: tile.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                top: 9,
                left: 9,
                right: 12,
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: GoogleFonts.unbounded().fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: tile.textColor,
                  ),
                ),
              ),
              Positioned(
                right: tile.iconOffset.dx,
                bottom: tile.iconOffset.dy,
                child: _buildIcon(),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _InnerShadowPainter(
                      borderRadius: BorderRadius.circular(12),
                      offset: const Offset(4, 4),
                      blur: 8,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final icon = SvgPicture.asset(
      tile.iconAsset,
      height: tile.iconSize,
      width: tile.iconSize,
      fit: BoxFit.contain,
    );
    if (tile.iconRotation == 0) return icon;
    return Transform.rotate(
      angle: tile.iconRotation * math.pi / 180,
      child: icon,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  _InnerShadowPainter({
    required this.borderRadius,
    required this.offset,
    required this.color,
    this.blur = 0,
  });

  final BorderRadius borderRadius;
  final Offset offset;
  final Color color;
  final double blur;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(rect, Paint()..color = color);
    final cut =
        Paint()
          ..color = Colors.black
          ..blendMode = BlendMode.dstOut;
    if (blur > 0) {
      cut.maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    }
    canvas.drawRRect(rrect.shift(offset), cut);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter old) =>
      old.offset != offset || old.color != color || old.blur != blur;
}
