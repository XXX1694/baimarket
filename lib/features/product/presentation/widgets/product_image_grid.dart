import 'package:flutter/material.dart';
import '../../../../core/urls.dart';
import '../../../../core/widgets/show_image.dart';
import '../../data/models/product_model.dart';

class ProductImageGrid extends StatelessWidget {
  const ProductImageGrid({super.key, required this.model});
  final ProductModel model;

  void _openFullScreen(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenViewer(
          urls: model.photoUrls ?? [],
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = model.photoUrls ?? [];
    if (urls.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey)),
      );
    }

    if (urls.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () => _openFullScreen(context, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 280,
              width: double.infinity,
              child: NetworkImageWidget(
                url: '$imgUrl${urls[0]}',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 240,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _openFullScreen(context, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 240,
                    child: NetworkImageWidget(
                      url: '$imgUrl${urls[0]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openFullScreen(context, 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: NetworkImageWidget(
                            url: '$imgUrl${urls[1]}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (urls.length > 2) ...[
                    const SizedBox(height: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openFullScreen(context, 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              NetworkImageWidget(
                                url: '$imgUrl${urls[2]}',
                                fit: BoxFit.cover,
                              ),
                              if (urls.length > 3)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${urls.length - 3}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullScreenViewer extends StatefulWidget {
  const _FullScreenViewer({required this.urls, required this.initialIndex});
  final List<String> urls;
  final int initialIndex;

  @override
  State<_FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<_FullScreenViewer> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Center(
                child: NetworkImageWidgetBlack(
                  url: '$imgUrl${widget.urls[i]}',
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_current + 1}/${widget.urls.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.urls.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _current ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _current ? Colors.white : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
