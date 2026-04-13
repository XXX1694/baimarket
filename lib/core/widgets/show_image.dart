import 'package:flutter/material.dart';
import 'shimmer.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.dark = false,
  });

  final String url;
  final BoxFit fit;
  final bool dark;

  Widget _placeholder() => dark
      ? SimpleShimmerBlack(borderRadius: 0)
      : SimpleShimmer(borderRadius: 0);

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();

    return Image.network(
      url,
      fit: fit,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        // Картинка была в кэше — показываем сразу без анимации
        if (wasSynchronouslyLoaded) return child;

        // Первая загрузка: шиммер снизу, картинка плавно появляется сверху
        return Stack(
          fit: StackFit.expand,
          children: [
            _placeholder(),
            AnimatedOpacity(
              opacity: frame == null ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: child,
            ),
          ],
        );
      },
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}

/// Обёртка для обратной совместимости — тёмный вариант с чёрным шиммером
class NetworkImageWidgetBlack extends NetworkImageWidget {
  const NetworkImageWidgetBlack({super.key, required super.url, super.fit})
      : super(dark: true);
}
