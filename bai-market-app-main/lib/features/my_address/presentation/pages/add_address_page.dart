import 'package:bai_market/core/widgets/main_button.dart';
import 'package:bai_market/features/create_order/presentation/widgets/address_field.dart';
import 'package:bai_market/features/create_order/presentation/widgets/postal_field.dart';
import 'package:flutter/material.dart';
import '../../data/models/user_address_model.dart';
import 'package:bai_market/features/create_order/presentation/widgets/region_choose.dart';
import 'package:bai_market/features/create_order/presentation/widgets/city_choose.dart';
import 'package:bai_market/features/my_address/presentation/cubit/my_address_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/address_name.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  int? selectedRegionId;

  void _handleRegionSelected(int regionId) {
    setState(() {
      selectedRegionId = regionId;
      cityController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Адрес доставки',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AddressName(controller: labelController),

                RegionChoose(
                  controller: regionController,
                  onRegionSelected: _handleRegionSelected,
                ),

                CityChoose(
                  controller: cityController,
                  selectedRegionId: selectedRegionId,
                ),
                AddressField(controller: addressController),

                PostalField(controller: postalCodeController),
                const Spacer(),
                MainButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await context.read<MyAddressCubit>().addAddress(
                          UserAddressModel(
                            id: 0,
                            regionId: int.parse(regionController.text),
                            cityId: int.parse(cityController.text),
                            addressLine: addressController.text,
                            postalCode: postalCodeController.text,
                            label: labelController.text,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Адрес успешно добавлен'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context, true);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ошибка: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  text: 'Сохранить адрес',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
