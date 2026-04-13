import 'package:bai_market/features/collection/presentation/cubit/collection_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:bai_market/core/utils/translation_utils.dart';

import '../../../../core/urls.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/select_soring.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key, required this.slug});
  final String? slug;
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

CollectionCubit globalCollectionCubit = CollectionCubit();

class _CollectionPageState extends State<CollectionPage> {
  late TextEditingController controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      controller = TextEditingController(text: l10n.sortPopular);
      _initialized = true;
    }
  }

  @override
  void initState() {
    globalCollectionCubit.getCollection(
      slug: widget.slug ?? 'new',
      sort: 'popular',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<CollectionCubit, CollectionState>(
        bloc: globalCollectionCubit,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CollectionGot) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  NetworkImageWidget(
                    url: '$imgUrl${state.collection.detail.backgroundUrl}',
                  ),
                  SafeArea(
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: false,
                          stretchTriggerOffset: 300.0,
                          expandedHeight: 200.0,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          collapsedHeight: 80,
                          actions: [
                            CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                context.push('/notification');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
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
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    TranslationUtils.getLocalizedName(
                                      context: context,
                                      nameKz: state.collection.detail.nameKz,
                                      nameRu: state.collection.detail.nameRu,
                                      nameEn: state.collection.detail.nameEn,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      TranslationUtils.getLocalizedDescription(
                                        context: context,
                                        descriptionKz:
                                            state
                                                .collection
                                                .detail
                                                .descriptionKz,
                                        descriptionRu:
                                            state
                                                .collection
                                                .detail
                                                .descriptionRu,
                                        descriptionEn:
                                            state
                                                .collection
                                                .detail
                                                .descriptionEn,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${state.collection.products.length} ${l10n.products}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        showSortingSelectionModal(
                                          context,
                                          controller,
                                          widget.slug ?? 'new',
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            controller.text,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          SvgPicture.asset(
                                            'assets/icons/sort.svg',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: state.collection.products.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 320,
                                  ),
                                  itemBuilder: (context, index) =>
                                      ProductCard(product: state.collection.products[index]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold();
          }
        },
      ),
    );
  }
}
