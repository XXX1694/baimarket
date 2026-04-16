import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_pallete.dart';
import '../../../../core/services/user_city_storage.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../create_order/presentation/widgets/city_choose.dart';
import '../../../create_order/presentation/widgets/region_choose.dart';
import '../../data/models/user_address_model.dart';
import '../cubit/my_address_cubit.dart';

class AddAddressBottomSheet extends StatefulWidget {
  const AddAddressBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    final cubit = context.read<MyAddressCubit>();
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: BlocProvider.value(
          value: cubit,
          child: const AddAddressBottomSheet(),
        ),
      ),
    );
  }

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _entranceController = TextEditingController();
  final _floorController = TextEditingController();
  final _postalController = TextEditingController();
  int? _selectedRegionId;
  String? _selectedCityName;
  bool _submitting = false;

  @override
  void dispose() {
    _labelController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _apartmentController.dispose();
    _entranceController.dispose();
    _floorController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  String _composeAddressLine() {
    final base = _addressController.text.trim();
    final parts = <String>[];
    if (_apartmentController.text.trim().isNotEmpty) {
      parts.add('кв. ${_apartmentController.text.trim()}');
    }
    if (_entranceController.text.trim().isNotEmpty) {
      parts.add('подъезд ${_entranceController.text.trim()}');
    }
    if (_floorController.text.trim().isNotEmpty) {
      parts.add('этаж ${_floorController.text.trim()}');
    }
    if (parts.isEmpty) return base;
    return '$base, ${parts.join(', ')}';
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;
    if (_regionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите регион'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите город'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await context.read<MyAddressCubit>().addAddress(
        UserAddressModel(
          id: 0,
          regionId: int.parse(_regionController.text),
          cityId: int.parse(_cityController.text),
          addressLine: _composeAddressLine(),
          postalCode: _postalController.text,
          label: _labelController.text.trim(),
        ),
      );
      if (_selectedCityName != null && _selectedCityName!.isNotEmpty) {
        await setUserCity(_selectedCityName!);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderRow(
                  title: _selectedCityName?.isNotEmpty == true
                      ? _selectedCityName!
                      : 'Новый адрес',
                  onClose: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 20),
                _FilledTextField(
                  controller: _labelController,
                  hint: 'Например: Дом или работа',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Введите название'
                      : null,
                ),
                const SizedBox(height: 16),
                RegionChoose(
                  controller: _regionController,
                  onRegionSelected: (id) => setState(() {
                    _selectedRegionId = id;
                    _cityController.clear();
                    _selectedCityName = null;
                  }),
                ),
                CityChoose(
                  controller: _cityController,
                  selectedRegionId: _selectedRegionId,
                  onCitySelected: (name) =>
                      setState(() => _selectedCityName = name),
                ),
                const _FieldLabel('Адрес доставки'),
                const SizedBox(height: 8),
                _FilledTextField(
                  controller: _addressController,
                  hint: 'Улица и номер дома',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Введите адрес'
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'Квартира',
                        child: _FilledTextField(
                          controller: _apartmentController,
                          hint: 'Квартира',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LabeledField(
                        label: 'Подъезд',
                        child: _FilledTextField(
                          controller: _entranceController,
                          hint: 'Подъезд',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LabeledField(
                        label: 'Этаж',
                        child: _FilledTextField(
                          controller: _floorController,
                          hint: 'Этаж',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _FieldLabel('Почтовый индекс'),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'КазПочта',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2F80ED),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _FilledTextField(
                  controller: _postalController,
                  hint: 'Индекс',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Введите индекс'
                      : null,
                ),
                const SizedBox(height: 24),
                MainButton(
                  onPressed: _submitting ? null : _submit,
                  text: _submitting ? 'Сохраняем...' : 'Добавить',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const _HeaderRow({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(32, 32),
          onPressed: onClose,
          child: Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: lightGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 18, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _FilledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _FilledTextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: lightGray,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Colors.black38,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
