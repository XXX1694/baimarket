import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/create_order/presentation/cubit/create_order_cubit.dart';
import 'package:bai_market/features/create_order/presentation/widgets/city_choose.dart';
import 'package:bai_market/features/create_order/presentation/widgets/city_choose_with_fillial.dart';
import 'package:bai_market/features/create_order/presentation/widgets/phone_field.dart';
import 'package:bai_market/features/create_order/presentation/widgets/postal_field.dart';
import 'package:bai_market/features/create_order/presentation/widgets/total_price_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bai_market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:bai_market/features/my_address/data/models/user_address_model.dart';
import 'package:bai_market/features/my_address/presentation/widgets/address_bottom_sheet.dart';
import 'package:bai_market/features/my_address/presentation/cubit/my_address_cubit.dart';
import 'package:bai_market/features/my_address/data/datasources/user_address_remote_datasource.dart';
import 'package:bai_market/features/my_address/data/repositories/user_address_repository_impl.dart';
import 'package:dio/dio.dart';
import '../widgets/selected_address_card.dart';
import 'package:bai_market/features/my_address/presentation/pages/add_address_page.dart';
import 'package:bai_market/core/urls.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/widgets/main_button.dart';
import '../widgets/address_field.dart';
import '../widgets/name_field.dart';
import '../widgets/region_choose.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key, required this.cartModel});
  final CartModel cartModel;
  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  late TextEditingController whoTakesController;
  late TextEditingController cityController;
  late TextEditingController regionController;
  late TextEditingController phoneNumberController;
  late TextEditingController postalCodeController;
  late TextEditingController addressController;
  late TextEditingController filialId;
  int? selectedRegionId;
  final CreateOrderCubit createOrderPage = CreateOrderCubit();
  final ProfileCubit profileCubit = ProfileCubit();
  UserAddressModel? selectedUserAddress;

  @override
  void initState() {
    super.initState();
    whoTakesController = TextEditingController();
    cityController = TextEditingController();
    regionController = TextEditingController();
    phoneNumberController = TextEditingController();
    postalCodeController = TextEditingController();
    addressController = TextEditingController();
    filialId = TextEditingController();

    // Get profile data and pre-fill fields
    profileCubit.getProfileData();
  }

  @override
  void dispose() {
    whoTakesController.dispose();
    cityController.dispose();
    regionController.dispose();
    phoneNumberController.dispose();
    postalCodeController.dispose();
    addressController.dispose();
    filialId.dispose();
    profileCubit.close();
    super.dispose();
  }

  int _selectedSegment = 0;
  void _handleRegionSelected(int regionId) {
    if (kDebugMode) {
      print('Выбран регион с ID: $regionId');
    }
    setState(() {
      selectedRegionId = regionId;
      cityController.clear(); // Очищаем выбранный город при смене региона
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Оформление заказа',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSegment = 0;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  _selectedSegment == 0
                                      ? seconColor
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Курьером',
                                style: TextStyle(
                                  color:
                                      _selectedSegment == 0
                                          ? Colors.black
                                          : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSegment = 1;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  _selectedSegment == 1
                                      ? seconColor
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Самовывоз',
                                style: TextStyle(
                                  color:
                                      _selectedSegment == 1
                                          ? Colors.black
                                          : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: profileCubit,
                  builder: (context, state) {
                    if (state is ProfileGot) {
                      // Pre-fill name and phone if available
                      if (state.profile.firstName != null &&
                          state.profile.lastName != null) {
                        whoTakesController.text =
                            '${state.profile.firstName} ${state.profile.lastName}';
                      }
                      if (state.profile.phoneNumber != null) {
                        phoneNumberController.text = state.profile.phoneNumber!;
                      }
                    }
                    return _selectedSegment == 0
                        ? Column(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final cubit = MyAddressCubit(
                                  UserAddressRepositoryImpl(
                                    UserAddressRemoteDatasource(Dio(), mainUrl),
                                  ),
                                );
                                await cubit.loadAddresses();
                                if (!context.mounted) return;
                                final address = await showModalBottomSheet<
                                  UserAddressModel
                                >(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: cubit,
                                      child: BlocBuilder<
                                        MyAddressCubit,
                                        MyAddressState
                                      >(
                                        builder: (context, state) {
                                          if (state is MyAddressLoaded) {
                                            return AddressBottomSheet(
                                              addresses: state.addresses,
                                              selectedId:
                                                  selectedUserAddress?.id,
                                              onSelect: (addr) {
                                                Navigator.pop(context, addr);
                                              },
                                              onAdd: () async {
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          _,
                                                        ) => BlocProvider.value(
                                                          value: cubit,
                                                          child:
                                                              AddAddressPage(),
                                                        ),
                                                  ),
                                                );
                                                if (result == true) {
                                                  await cubit.loadAddresses();
                                                }
                                              },
                                            );
                                          }
                                          if (state is MyAddressLoading) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (state is MyAddressError) {
                                            return Center(
                                              child: Text(
                                                state.message,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            );
                                          }
                                          return AddressBottomSheet(
                                            addresses: [],
                                            selectedId: null,
                                            onSelect: (_) {},
                                            onAdd: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => BlocProvider.value(
                                                        value: cubit,
                                                        child: AddAddressPage(),
                                                      ),
                                                ),
                                              );
                                              if (result == true) {
                                                await cubit.loadAddresses();
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                                if (address != null) {
                                  if (!context.mounted) return;
                                  setState(() {
                                    selectedRegionId = address.regionId;
                                    regionController.text =
                                        address.regionId.toString();
                                    cityController.text = '';
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    setState(() {
                                      cityController.text =
                                          address.cityId.toString();
                                      addressController.text =
                                          address.addressLine;
                                      postalCodeController.text =
                                          address.postalCode;
                                      selectedUserAddress = address;
                                    });
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Адрес выбран'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Мои адреса',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      selectedUserAddress == null
                                          ? 'выбрать'
                                          : 'изменить',
                                      style: TextStyle(
                                        color: Color(0xFF1500FF),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (selectedUserAddress != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SelectedAddressCard(
                                  address: selectedUserAddress!,
                                  onClear: () {
                                    setState(() => selectedUserAddress = null);
                                    regionController.clear();
                                    cityController.clear();
                                    addressController.clear();
                                    postalCodeController.clear();
                                  },
                                ),
                              ),

                            NameField(controller: whoTakesController),
                            RegionChoose(
                              controller: regionController,
                              onRegionSelected: _handleRegionSelected,
                            ),
                            CityChoose(
                              controller: cityController,
                              selectedRegionId: selectedRegionId,
                            ),

                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: PhoneField(
                                    controller: phoneNumberController,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 6,
                                  child: PostalField(
                                    controller: postalCodeController,
                                  ),
                                ),
                              ],
                            ),
                            AddressField(controller: addressController),
                            TotalPriceBlock(cartModel: widget.cartModel),
                          ],
                        )
                        : Column(
                          children: [
                            NameField(controller: whoTakesController),
                            CityChooseWithFillial(
                              controller: cityController,
                              filialController: filialId,
                            ),
                            PhoneField(controller: phoneNumberController),
                            TotalPriceBlock(cartModel: widget.cartModel),
                          ],
                        );
                  },
                ),

                BlocConsumer<CreateOrderCubit, CreateOrderState>(
                  listener: (context, state) {
                    print(state);
                    if (state is OrderCreated) {
                      context.push('/payment', extra: state.paymentUrl);
                    }
                  },
                  bloc: createOrderPage,
                  builder: (context, state) {
                    if (state is OrderCreating) {
                      return CircularProgressIndicator();
                    } else {
                      return MainButton(
                        onPressed: () {
                          if (whoTakesController.text.isEmpty ||
                              cityController.text.isEmpty ||
                              phoneNumberController.text.isEmpty ||
                              (_selectedSegment == 0
                                  ? postalCodeController.text.isEmpty
                                  : false) ||
                              (_selectedSegment == 0
                                  ? addressController.text.isEmpty
                                  : false)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Пожалуйста, заполните все поля'),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(16),
                              ),
                            );
                            return;
                          }
                          createOrderPage.createOrder(
                            cartId: widget.cartModel.id,
                            fullName: whoTakesController.text,
                            phoneNumber: formatPhoneNumber(
                              phoneNumberController.text,
                            ),
                            selfPick: _selectedSegment == 0 ? false : true,
                            postalCode: postalCodeController.text,
                            cityId: int.parse(cityController.text),
                            deliveryAddress: addressController.text,
                            comment: 'Тест',
                            pickupUrl:
                                int.parse(cityController.text) == 1
                                    ? 'https://2gis.kz/almaty/geo/70000001081294407'
                                    : 'https://2gis.kz/shymkent/geo/70030076164123844',
                            selfPickDate: "",
                            filialId:
                                int.parse(cityController.text) == 1 ? 2 : 1,
                          );
                        },
                        text: 'Продолжить',
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Нажимая на кнопку, вы соглашаетесь с Условиями обработки персональных данных, а также с Условиями продажи',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
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

String formatPhoneNumber(String phoneNumber) {
  // Удаляем "+7" из начала, если есть
  String cleaned = phoneNumber.replaceFirst('+7', '');
  // Удаляем все нечисловые символы (пробелы, скобки, дефисы)
  return cleaned.replaceAll(RegExp(r'[^0-9]'), '');
}
