import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/create_order/presentation/cubit/create_order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bai_market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bai_market/features/my_address/data/models/user_address_model.dart';
import 'package:bai_market/features/my_address/presentation/widgets/address_bottom_sheet.dart';
import 'package:bai_market/features/my_address/presentation/cubit/my_address_cubit.dart';
import 'package:bai_market/features/my_address/data/datasources/user_address_remote_datasource.dart';
import 'package:bai_market/features/my_address/data/repositories/user_address_repository_impl.dart';
import 'package:bai_market/features/my_address/presentation/pages/add_address_page.dart';
import 'package:bai_market/core/network/app_dio.dart';
import 'package:bai_market/core/urls.dart';

import '../../../../core/widgets/main_button.dart';
import '../../data/models/city_model.dart';
import '../widgets/bonus_tickets_row.dart';
import '../widgets/delivery_section.dart';
import '../widgets/filial_picker_sheet.dart';
import '../widgets/order_total_section.dart';
import '../widgets/payment_methods_section.dart';
import '../widgets/recipient_section.dart';

const int _kCourierDeliveryPrice = 900;
const int _kTicketsToEarn = 2;
const String _kFilialDistrict = 'Бостандыкский район';
const String _kFilialAddressLine = 'улица Абдуллы Розыбакиева, 112';

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
  CityModel? selectedPickupCity;
  int? selectedFilialIndex;

  int _selectedSegment = 0;
  PaymentMethod _paymentMethod = PaymentMethod.card;

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

  Future<void> _openAddressSheet() async {
    final cubit = MyAddressCubit(
      UserAddressRepositoryImpl(UserAddressRemoteDatasource(appDio, mainUrl)),
    );
    await cubit.loadAddresses();
    if (!mounted) return;
    final address = await showModalBottomSheet<UserAddressModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<MyAddressCubit, MyAddressState>(
            builder: (context, state) {
              if (state is MyAddressLoaded) {
                return AddressBottomSheet(
                  addresses: state.addresses,
                  selectedId: selectedUserAddress?.id,
                  onSelect: (addr) => Navigator.pop(context, addr),
                  onAdd: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const AddAddressPage(),
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
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MyAddressError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return AddressBottomSheet(
                addresses: const [],
                selectedId: null,
                onSelect: (_) {},
                onAdd: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const AddAddressPage(),
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

    if (address != null && mounted) {
      setState(() {
        selectedUserAddress = address;
        selectedRegionId = address.regionId;
        regionController.text = address.regionId.toString();
        cityController.text = address.cityId.toString();
        addressController.text = address.addressLine;
        postalCodeController.text = address.postalCode;
      });
    }
  }

  Future<void> _openFilialSheet() async {
    final result = await showFilialPickerSheet(
      context: context,
      initialCity: selectedPickupCity,
      initialFilialIndex: selectedFilialIndex,
    );
    if (result != null && mounted) {
      setState(() {
        selectedPickupCity = result.city;
        selectedFilialIndex = result.filialIndex;
        cityController.text = result.city.id.toString();
        filialId.text = result.filialIndex.toString();
      });
    }
  }

  String _cityName(CityModel c) =>
      c.nameRu ?? c.nameKz ?? c.nameEn ?? 'Город';

  void _onContinuePressed() {
    final isCourier = _selectedSegment == 0;
    final missingCourierAddress =
        isCourier && (selectedUserAddress == null || cityController.text.isEmpty);
    final missingPickupFilial =
        !isCourier && (selectedPickupCity == null || selectedFilialIndex == null);

    if (whoTakesController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        missingCourierAddress ||
        missingPickupFilial) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все поля'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    final cityId = int.parse(cityController.text);
    String? pickupUrl;
    if (!isCourier) {
      final urls = selectedPickupCity?.pickupUrls ?? const <String>[];
      if (urls.isNotEmpty &&
          selectedFilialIndex != null &&
          selectedFilialIndex! < urls.length) {
        pickupUrl = urls[selectedFilialIndex!];
      }
    }

    createOrderPage.createOrder(
      cartId: widget.cartModel.id,
      fullName: whoTakesController.text,
      phoneNumber: formatPhoneNumber(phoneNumberController.text),
      selfPick: !isCourier,
      postalCode: postalCodeController.text,
      cityId: cityId,
      deliveryAddress: addressController.text,
      comment: 'Тест',
      pickupUrl: pickupUrl,
      selfPickDate: '',
      filialId: isCourier ? null : (selectedFilialIndex ?? 0) + 1,
    );
  }

  Widget _buildDeliveryRow() {
    if (_selectedSegment == 0) {
      if (selectedUserAddress == null) {
        return DeliveryEntryRow(
          iconAsset: 'assets/icons/create_order/create_order_location.svg',
          title: 'Сохраненный адрес',
          actionLabel: 'выбрать',
          onTap: _openAddressSheet,
        );
      }
      return DeliveryEntryRow(
        iconAsset: 'assets/icons/create_order/create_order_location.svg',
        title: selectedUserAddress!.label.isEmpty
            ? 'Адрес'
            : selectedUserAddress!.label,
        subtitle: [
          selectedUserAddress!.addressLine,
          if (selectedUserAddress!.postalCode.isNotEmpty)
            'индекс: ${selectedUserAddress!.postalCode}',
        ].join('\n'),
        onTap: _openAddressSheet,
      );
    }

    if (selectedPickupCity == null || selectedFilialIndex == null) {
      return DeliveryEntryRow(
        iconAsset: 'assets/icons/create_order/create_order_location.svg',
        title: 'Филиалы',
        actionLabel: 'выбрать',
        onTap: _openFilialSheet,
      );
    }
    return DeliveryEntryRow(
      iconAsset: 'assets/icons/create_order/create_order_location.svg',
      title: _cityName(selectedPickupCity!),
      subtitle: 'Филиал: $_kFilialDistrict, $_kFilialAddressLine',
      actionLabel: 'Изменить',
      actionColor: const Color(0xFFFF3B47),
      onTap: _openFilialSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCourier = _selectedSegment == 0;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Оформление заказа',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {
            if (state is ProfileGot) {
              if (whoTakesController.text.isEmpty &&
                  state.profile.firstName != null &&
                  state.profile.lastName != null) {
                whoTakesController.text =
                    '${state.profile.firstName} ${state.profile.lastName}';
              }
              if (phoneNumberController.text.isEmpty &&
                  state.profile.phoneNumber != null) {
                phoneNumberController.text =
                    _stripLeadingCountry(state.profile.phoneNumber!);
              }
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              children: [
                DeliverySection(
                  selectedSegment: _selectedSegment,
                  onSegmentChanged: (i) => setState(() => _selectedSegment = i),
                  row: _buildDeliveryRow(),
                ),
                const SizedBox(height: 12),
                RecipientSection(
                  nameController: whoTakesController,
                  phoneController: phoneNumberController,
                  nameLabel:
                      isCourier ? 'Кто встретит (ФИО)' : 'Кто придет (ФИО)',
                ),
                const SizedBox(height: 12),
                PaymentMethodsSection(
                  selected: _paymentMethod,
                  onChanged: (m) => setState(() => _paymentMethod = m),
                ),
                const SizedBox(height: 12),
                const BonusTicketsRow(ticketsToEarn: _kTicketsToEarn),
                const SizedBox(height: 12),
                OrderTotalSection(
                  cartModel: widget.cartModel,
                  deliveryPrice: isCourier ? _kCourierDeliveryPrice : 0,
                ),
                const SizedBox(height: 16),
                BlocConsumer<CreateOrderCubit, CreateOrderState>(
                  listener: (context, state) {
                    if (state is OrderCreated) {
                      context.push('/payment', extra: state.paymentUrl);
                    }
                  },
                  bloc: createOrderPage,
                  builder: (context, state) {
                    if (state is OrderCreating) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      );
                    }
                    return MainButton(
                      onPressed: _onContinuePressed,
                      text: 'Продолжить',
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Нажимая на кнопку, вы соглашаетесь с Условиями обработки персональных данных, а также с Условиями продажи',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6E6E6E),
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
  String cleaned = phoneNumber.replaceFirst('+7', '');
  return cleaned.replaceAll(RegExp(r'[^0-9]'), '');
}

String _stripLeadingCountry(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length > 10 && digits.startsWith('7')) {
    return digits.substring(1);
  }
  return digits;
}
