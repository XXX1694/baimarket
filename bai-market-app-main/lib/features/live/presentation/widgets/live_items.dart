import 'dart:ui'; // Не забудьте импортировать для BackdropFilter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/urls.dart';
import '../../../../core/utils/translation_utils.dart';
import '../../../../core/widgets/show_image.dart';
import '../../../catalog/data/models/category_product_model.dart';

class HorizontalProductList extends StatelessWidget {
  const HorizontalProductList({super.key, required this.products});
  final List<CategoryProductModel> products;

  @override
  Widget build(BuildContext context) {
    // Задаем фиксированную высоту для всего горизонтального списка
    return SizedBox(
      height: 80, // Можете настроить высоту по своему усмотрению
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          // Обертка для создания отступов между элементами
          return Padding(
            padding: EdgeInsets.only(
              right: 6.0,
              left:
                  index == 0
                      ? 20.0
                      : 0.0, // Отступ слева только для первого элемента
            ), // Отступ между карточками
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context.push('/product/${product.id}');
              },
              // Используем ClipRRect для скругления углов у эффекта размытия
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: 200, // Ширина карточки
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      // Полупрозрачный цвет фона
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        // --- Изображение товара ---
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: NetworkImageWidget(
                              url:
                                  product.photoUrls != null &&
                                          product.photoUrls!.isNotEmpty
                                      ? '$imgUrl${product.photoUrls![0]}'
                                      : '',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // --- Информация о товаре (справа от изображения) ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Название товара
                              Text(
                                product.name ?? 'Название товара',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              // Описание
                              Text(
                                TranslationUtils.getLocalizedName(
                                  context: context,
                                  nameKz: product.descriptionKz ?? '',
                                  nameRu: product.descriptionRu ?? '',
                                  nameEn: product.descriptionEn ?? '',
                                ),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              // Цены
                              Row(
                                children: [
                                  Text(
                                    '${product.price}₸',
                                    style: const TextStyle(
                                      color: Color(
                                        0xFF42F248,
                                      ), // Яркий зеленый цвет
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (product.oldPrice != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '${product.oldPrice}₸',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.white
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
