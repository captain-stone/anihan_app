// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously

import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/add_product_page/add_product_page_bloc.dart';

import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'add_ons/variation_card.dart';

@RoutePage()
class AddProductFormPage extends StatefulWidget {
  final String? uid;
  const AddProductFormPage({super.key, required this.uid});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductFormPage> with LoggerEvent {
  final _addProductBloc = getIt<AddProductPageBloc>();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>(); // GlobalKey to manage form state
  List<Uint8List> _imageDataList = [];
  List<Widget> _variationCards = [];
  String fileExtension = "";
  List<GlobalKey<VariationCardState>> _variationKeys = [];
  final _productNameController = TextEditingController();
  final _labelController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productQuantityQuantity = TextEditingController();
  bool isLoading = false;
  String? selectedValue;
  final List<String> label = [
    "Seeds",
    "Fruits",
    "Vegetables",
    "Fertilizers",
    "Farming Tools",
    "Saplings"
  ];

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (selected != null) {
      fileExtension = selected.name.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        final Uint8List data = await selected.readAsBytes();
        setState(() {
          _imageDataList.add(data);
        });
        // logger.d(fileExtension);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Only .png, .jpg, and .jpeg formats are allowed.')),
        );
      }
    }
  }

  void _addVariationCard() {
    final key = GlobalKey<VariationCardState>();

    _variationKeys.add(key);

    setState(() {
      _variationCards.add(
        VariationCard(
          key: key, // Use the unique key for this variation card
          onDelete: () {
            _removeVariationCard(key);
          },
        ),
      );
    });
  }

  void _removeVariationCard(GlobalKey<VariationCardState> key) {
    setState(() {
      int index = _variationKeys.indexOf(key);
      if (index != -1) {
        _variationKeys.removeAt(index);
        _variationCards.removeAt(index);
      }
    });
  }

  List<ProductVariantEntity> _retrieveVariationData() {
    List<ProductVariantEntity> allData = [];

    for (var key in _variationKeys) {
      final state = key.currentState;
      if (state != null) {
        allData.add(state.data);
      }
    }

    return allData;
  }

  _validateAllFields(List<ProductVariantEntity> data) {
    // Validate the main form (text fields)
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Check if at least one image is uploaded
    if (_imageDataList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please upload at least one product image.')),
      );
      return false;
    }

    // // Validate each variation card using the keys
    for (var key in _variationKeys) {
      final state = key.currentState;

      if (state == null) {
        return false;
      }

      // final variantName = state.context.co
      if (!key.currentState!.validate()) {
        return false;
      }
    }

    ProductParams params = ProductParams(
      _productNameController.text,
      selectedValue ?? "None",
      double.tryParse(_priceController.text)!,
      double.tryParse(_productQuantityQuantity.text)!,
      _imageDataList,
      _descriptionController.text,
      productVariant: data,
    );

    logger.d(data);

    // logger.d(
    //     "DETAILS:\n${data[1]['productVariantImage'].length}\n${data[0]['productVariantImage'].runtimeType}");

    _addProductBloc.add(AddProductEvent(params));

    return true;
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -200,
          child: Transform.rotate(
            angle: 0.3490,
            child: Container(
              width: MediaQuery.of(context).size.width * 2.0,
              height: 250,
              color: Colors.green,
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -200,
          child: Transform.rotate(
            angle: 0.3490,
            child: Container(
              width: MediaQuery.of(context).size.width * 2.0,
              height: 250,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add a Product!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54),
            iconSize: 30,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ..._imageDataList.map((imageData) => _buildImageContainer(imageData)),
          _buildAddImageButton(),
        ],
      ),
    );
  }

  Widget _buildImageContainer(Uint8List imageData) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          imageData,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54),
        ),
        child: Center(
          child: Icon(
            _imageDataList.isEmpty ? Icons.add_photo_alternate : Icons.add,
            size: 50,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name:',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: _productQuantityQuantity,
                decoration: InputDecoration(
                  labelText: 'Quantity:',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter a price.';
                //   }
                //   return null;
                // },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: DropdownButtonFormField(
                    hint: const Text("Label"),
                    value: selectedValue,
                    items: label.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    })),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price:',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVariationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ADD Variations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _addVariationCard,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xFF12662A),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _variationCards,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: 'Item Description:',
          labelStyle: TextStyle(color: Colors.green.shade700),
          border: InputBorder.none,
        ),
        maxLines: 4,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a description.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final data = _retrieveVariationData();

          _validateAllFields(data);
          // Proceed with submission if all validations pass
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color(0xFF12662A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: Colors.black.withOpacity(0.2),
          elevation: 5,
        ),
        child: const Text(
          'Submit Product',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white60),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductPageBloc, AddProductPageState>(
      bloc: _addProductBloc,
      listener: (context, state) {
        // TODO: implement listener
        logger.d(state);

        if (state is AddProductPageLoadingState) {
          showDialog(
              context: context,
              builder: (context) {
                return const Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                );
              });
          setState(() {
            isLoading = true;
          });
        }

        if (state is AddProductPageSuccessState) {
          if (isLoading) {
            Navigator.of(context).pop();
            setState(() {
              isLoading = false;
            });
          }
          logger.d(state.entity);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product submitted successfully!')),
          );
          // AutoRouter.of(context)
          //     .popAndPush(HomeNavigationRoute(uid: widget.uid));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              _buildBackground(context),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(context),
                        const SizedBox(height: 20),
                        _buildImageUploadSection(),
                        const SizedBox(height: 20),
                        _buildProductDetailsForm(),
                        const SizedBox(height: 20),
                        _buildVariationsSection(),
                        const SizedBox(height: 20),
                        _buildDescriptionField(),
                        const SizedBox(height: 20),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
