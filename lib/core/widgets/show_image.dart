import 'dart:typed_data';
import 'package:bai_market/core/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Глобальный кэш для изображений, доступный всем виджетам
class ImageCache {
  static final Map<String, Uint8List> _cache = {};

  static Uint8List? getFromCache(String url) {
    return _cache[url];
  }

  static void addToCache(String url, Uint8List data) {
    _cache[url] = data;
  }

  static bool hasInCache(String url) {
    return _cache.containsKey(url);
  }
}

class NetworkImageWidget extends StatefulWidget {
  final String url;
  final BoxFit fit;

  const NetworkImageWidget({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  State<NetworkImageWidget> createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget>
    with AutomaticKeepAliveClientMixin {
  Uint8List? _imageData;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true; // Сохраняем состояние виджета при скроллинге

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Предзагружаем изображение в Image кэш Flutter для более быстрого рендеринга
    if (_imageData != null) {
      precacheImage(MemoryImage(_imageData!), context);
    }
  }

  @override
  void didUpdateWidget(NetworkImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если URL изменился, загружаем заново
    if (widget.url != oldWidget.url) {
      _imageData = null;
      _isLoading = false;
      _hasError = false;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    // Избегаем повторной загрузки, если уже загружаем
    if (_isLoading) return;

    // Проверяем сначала глобальный кэш
    if (ImageCache.hasInCache(widget.url)) {
      if (mounted) {
        setState(() {
          _imageData = ImageCache.getFromCache(widget.url);
          _isLoading = false;
          _hasError = false;
        });
      }
      return;
    }

    _isLoading = true;

    try {
      final response = await http.get(Uri.parse(widget.url));

      // Проверяем, что виджет всё ещё в дереве
      if (!mounted) return;

      if (response.statusCode == 200) {
        // Сохраняем в глобальном кэше
        ImageCache.addToCache(widget.url, response.bodyBytes);

        setState(() {
          _imageData = response.bodyBytes;
          _isLoading = false;
          _hasError = false;
        });

        // Предзагружаем также в кэш Flutter
        precacheImage(MemoryImage(_imageData!), context);
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Необходимо для AutomaticKeepAliveClientMixin

    // Если данные уже загружены, показываем изображение сразу
    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        fit: widget.fit,
        gaplessPlayback: true, // Устраняет мигание при перезагрузке
      );
    }

    // В случае ошибки или загрузки - показываем заглушку
    return SimpleShimmer(borderRadius: 0);
  }
}

class NetworkImageWidgetBlack extends StatefulWidget {
  final String url;
  final BoxFit fit;

  const NetworkImageWidgetBlack({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  State<NetworkImageWidgetBlack> createState() =>
      _NetworkImageWidgetBlackState();
}

class _NetworkImageWidgetBlackState extends State<NetworkImageWidgetBlack>
    with AutomaticKeepAliveClientMixin {
  Uint8List? _imageData;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true; // Сохраняем состояние виджета при скроллинге

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Предзагружаем изображение в Image кэш Flutter для более быстрого рендеринга
    if (_imageData != null) {
      precacheImage(MemoryImage(_imageData!), context);
    }
  }

  @override
  void didUpdateWidget(NetworkImageWidgetBlack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если URL изменился, загружаем заново
    if (widget.url != oldWidget.url) {
      _imageData = null;
      _isLoading = false;
      _hasError = false;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    // Избегаем повторной загрузки, если уже загружаем
    if (_isLoading) return;

    // Проверяем сначала глобальный кэш
    if (ImageCache.hasInCache(widget.url)) {
      if (mounted) {
        setState(() {
          _imageData = ImageCache.getFromCache(widget.url);
          _isLoading = false;
          _hasError = false;
        });
      }
      return;
    }

    _isLoading = true;

    try {
      final response = await http.get(Uri.parse(widget.url));

      // Проверяем, что виджет всё ещё в дереве
      if (!mounted) return;

      if (response.statusCode == 200) {
        // Сохраняем в глобальном кэше
        ImageCache.addToCache(widget.url, response.bodyBytes);

        setState(() {
          _imageData = response.bodyBytes;
          _isLoading = false;
          _hasError = false;
        });

        // Предзагружаем также в кэш Flutter
        precacheImage(MemoryImage(_imageData!), context);
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Необходимо для AutomaticKeepAliveClientMixin

    // Если данные уже загружены, показываем изображение сразу
    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        fit: widget.fit,
        gaplessPlayback: true, // Устраняет мигание при перезагрузке
      );
    }

    // В случае ошибки или загрузки - показываем заглушку
    return SimpleShimmerBlack(borderRadius: 0);
  }
}
