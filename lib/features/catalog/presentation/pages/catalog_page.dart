// ignore_for_file: deprecated_member_use

import 'package:bai_market/core/app_pallete.dart';
import 'package:bai_market/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:bai_market/features/catalog/presentation/widgets/category_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/select_category.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late CatalogCubit cubit = CatalogCubit();
  final ValueNotifier<String> slug = ValueNotifier<String>('all');

  @override
  void initState() {
    super.initState();
    slug.addListener(onTextChanged);
  }

  void onTextChanged() {
    cubit.getCategories(slug: slug.value);
  }

  @override
  void dispose() {
    slug.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: false, // Прикрепляем AppBar к верхней части
                  // snap: true,
                  floating: true,
                  centerTitle: false,
                  stretchTriggerOffset: 130.0,
                  expandedHeight: 130.0,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  collapsedHeight: 90,
                  automaticallyImplyLeading: false,

                  title: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          l10n.catalog,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: mainColorLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.freeDelivery,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/ring.svg',
                            color: Color(0xFF575E6E),
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 16, width: double.infinity),
                        SelectCategory(notifier: slug),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.black12, height: 1),
                      const SizedBox(height: 4),
                      CategoryProducts(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
