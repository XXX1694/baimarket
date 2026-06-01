import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Описание одной плитки. Картинка содержит фон+иконку+название уже
/// внутри PNG (так подготовил макет), поэтому отдельно label не рисуем.
/// `slug` — куда уходим при тапе. Бэк сейчас знает только `new`,
/// `discount`, `lottery` + спец-`all`; категории без своего слага
/// фолбэчатся на `all`.
class _CatalogTile {
  final String asset;
  final String label;
  final String slug;
  const _CatalogTile({
    required this.asset,
    required this.label,
    required this.slug,
  });
}

// Порядок и маппинг проверены по содержимому PNG (текст и иконки внутри
// каждой картинки уже отрисованы дизайнером). Если файлы пере-экспортируют
// — пересмотри соответствие здесь.
const _tiles = <_CatalogTile>[
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_1.png',
    label: 'Розыгрышные товары',
    slug: 'lottery',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_2.png',
    label: 'Товары со скидками',
    slug: 'discount',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_11.png',
    label: 'Для макияжа',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_3.png',
    label: 'Парфюмерия',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_4.png',
    label: 'Уход за телом',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_7.png',
    label: 'Уход за волосами',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_6.png',
    label: 'Наборы косметики',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_5.png',
    label: 'Уход за лицом',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_8.png',
    label: 'Солнечная линия',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_9.png',
    label: 'Личная гигиена',
    slug: 'all',
  ),
  _CatalogTile(
    asset: 'assets/images/catalog/catalog_10.png',
    label: 'Уход за полостью рта',
    slug: 'all',
  ),
];

class CatalogTilesGrid extends StatelessWidget {
  const CatalogTilesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Frame 16271 в Figma: горизонтальный паддинг 20, шаг 10 — 3×110.
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _tiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, i) => _CatalogTileCard(tile: _tiles[i]),
    );
  }
}

class _CatalogTileCard extends StatelessWidget {
  const _CatalogTileCard({required this.tile});
  final _CatalogTile tile;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Передаём `title` как extra — потенциально collection-page
        // сможет переопределить заголовок на имя категории. Сейчас
        // CollectionPage его не читает; если потребуется — расширю.
        context.push(
          '/collection/${tile.slug}',
          extra: {'title': tile.label},
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            tile.asset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE8E8E8),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_outlined,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
