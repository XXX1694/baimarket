import 'dart:async';
import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:bai_market/features/main/presentation/cubit/main_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/app_pallete.dart';
import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/main_featured.dart';
import '../widgets/main_items.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selected = 0;
  final MainCubit cubit = MainCubit();
  final CollectionCubit collectionCubit = CollectionCubit();
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  final bool _isUserInteracting = false;

  @override
  void initState() {
    collectionCubit.getCollection(slug: 'new', sort: 'popular');
    _pageController = PageController(initialPage: 1000);
    _startAutoSlide();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (cubit.state is! BannerGot) return;
      if (_isUserInteracting) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<MainCubit, MainState>(
        bloc: cubit,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BannerGot) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 380,
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (state.banners.isEmpty) return;
                          if (details.primaryVelocity == null) return;
                          if (details.primaryVelocity! < 0) {
                            // свайп влево — следующий баннер
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else if (details.primaryVelocity! > 0) {
                            // свайп вправо — предыдущий баннер
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Stack(
                          children: [
                            // Бесконечный PageView для фонового изображения
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _selected = index % state.banners.length;
                                });
                              },
                              itemBuilder: (context, index) {
                                final bannerIndex =
                                    index % state.banners.length;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 380,
                                  child: NetworkImageWidget(
                                    url:
                                        '$imgUrl${state.banners[bannerIndex].photoUrl ?? ''}',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                            // Фиксированный контент поверх
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black, Colors.transparent],
                                    stops: const [0.0, 0.8],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      layoutBuilder: (widget, previousWidgets) {
                                        return Stack(
                                          alignment: Alignment.topLeft,
                                          children: <Widget>[
                                            ...previousWidgets,
                                            if (widget != null) widget,
                                          ],
                                        );
                                      },
                                      child: Text(
                                        TranslationUtils.getLocalizedDescription(
                                          context: context,
                                          descriptionKz:
                                              state.banners[_selected].nameKz ??
                                              '',
                                          descriptionRu:
                                              state.banners[_selected].nameRu ??
                                              '',
                                          descriptionEn:
                                              state.banners[_selected].nameEn ??
                                              '',
                                        ),
                                        key: ValueKey(
                                          state.banners[_selected].nameRu,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.6,
                                        child: Text(
                                          TranslationUtils.getLocalizedDescription(
                                            context: context,
                                            descriptionKz:
                                                state
                                                    .banners[_selected]
                                                    .descriptionKz ??
                                                '',
                                            descriptionRu:
                                                state
                                                    .banners[_selected]
                                                    .descriptionRu ??
                                                '',
                                            descriptionEn:
                                                state
                                                    .banners[_selected]
                                                    .descriptionEn ??
                                                '',
                                          ),
                                          key: ValueKey(
                                            state
                                                .banners[_selected]
                                                .descriptionRu,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            _openInApp(
                                              state.banners[_selected].link ??
                                                  'https://www.instagram.com/iris_cosmetika?igsh=MXJqNzB6MDhzbXR2eA==',
                                            );
                                          },
                                          child: Container(
                                            height: 48,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: seconColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                l10n.more,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: mainColorDark,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            state.banners.length,
                                            (i) => Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    _selected == i
                                                        ? seconColor
                                                        : Colors.white
                                                            .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Notification button
                            Positioned(
                              top: MediaQuery.of(context).padding.top,
                              right: 20,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  context.push('/notification');
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/ring.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          const MainFeatured(),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.prize_goods,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                BlocConsumer<CollectionCubit, CollectionState>(
                                  bloc: collectionCubit,
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    if (state is CollectionGot) {
                                      return MainItems(
                                        products: state.collection.products,
                                      );
                                    } else {
                                      return Container(
                                        height: 500,
                                        width: double.infinity,
                                        color: Colors.white,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold();
        },
      ),
    );
  }

  Future<void> _openInApp(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView, // вот он — in‑app WebView
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true, // если нужна JS-поддержка
      ),
    )) {
      throw 'Не удалось открыть $url';
    }
  }
}
