// import 'package:bai_market/core/app_pallete.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../core/widgets/main_button.dart';
// import '../cubit/product_cubit.dart';
// import '../widgets/price_block.dart';
// import '../widgets/product_image.dart';

// class ProductPage extends StatefulWidget {
//   const ProductPage({super.key, required this.id});
//   final String? id;

//   @override
//   State<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   late ProductCubit cubit = ProductCubit();
//   @override
//   void initState() {
//     cubit.getProductDetail(id: int.parse(widget.id ?? '0'));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BlocConsumer<ProductCubit, ProductState>(
//         bloc: cubit,
//         listener: (context, state) {},
//         builder: (context, state) {
//           if (state is ProductGot) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 360,
//                           width: double.infinity,
//                           decoration: BoxDecoration(color: lightGray),
//                           child: Stack(
//                             children: [
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ProductImagesCarousel(
//                                   photoUrls: state.productModel.photoUrls ?? [],
//                                 ),
//                               ),
//                               SafeArea(
//                                 child: Column(
//                                   children: [
//                                     const SizedBox(height: 16),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 20,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           CupertinoButton(
//                                             padding: const EdgeInsets.all(0),
//                                             onPressed: () {
//                                               context.pop();
//                                             },
//                                             child: Container(
//                                               height: 50,
//                                               width: 50,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                               ),
//                                               child: Center(
//                                                 child: SvgPicture.asset(
//                                                   'assets/icons/arrow_left.svg',
//                                                 ),
//                                               ),
//                                             ),
//                                           ),

//                                           Container(
//                                             height: 32,
//                                             width: 32,
//                                             decoration: BoxDecoration(
//                                               color: seconColor,
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                             child: Center(
//                                               child: SvgPicture.asset(
//                                                 'assets/icons/ticket.svg',
//                                                 height: 24,
//                                                 width: 24,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 20),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     state.productModel.name ??
//                                         'Название продукта',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   CupertinoButton(
//                                     padding: const EdgeInsets.all(0),
//                                     onPressed: () {},
//                                     child: SvgPicture.asset(
//                                       'assets/icons/like_product.svg',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 state.productModel.descriptionRu ?? '',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               const Divider(height: 1, color: Colors.black12),
//                               const SizedBox(height: 24),
//                               PriceBlock(productModel: state.productModel),
//                               const SizedBox(height: 24),
//                               Text(
//                                 'Описание',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 state.productModel.detailedDescriptionRu ?? '',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(
//                     right: 20,
//                     left: 20,
//                     top: 16,
//                     bottom: 32,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.fromBorderSide(BorderSide(color: lightGray)),
//                   ),
//                   child: MainButton(onPressed: () {}, text: 'В корзину'),
//                 ),
//               ],
//             );
//           } else {
//             return SizedBox();
//           }
//         },
//       ),
//     );
//   }
// }
