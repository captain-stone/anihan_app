import 'dart:typed_data';

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VariationCard extends StatefulWidget {
  final VoidCallback onDelete;

  const VariationCard({super.key, required this.onDelete});

  @override
  VariationCardState createState() => VariationCardState();
}

class VariationCardState extends State<VariationCard> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _variationImage;
  final _variationNameController = TextEditingController();
  final _variationPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // FormKey for the variation card

  TextEditingController get controllerName => _variationNameController;
  TextEditingController get controllerPrice => _variationPriceController;
  Map<String, dynamic> get variantData => {};

  ProductVariantEntity get data => ProductVariantEntity(
      imageData: _variationImage,
      varianName: controllerName.text,
      variantPrice: controllerPrice.text);
  // "productVariantImage": _variationImage,
  // "productName": controllerName.text,
  // "productPrice": controllerPrice.text,

  Future<void> _pickVariationImage() async {
    final XFile? selected = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (selected != null) {
      final String fileExtension = selected.name.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        final Uint8List data = await selected.readAsBytes();
        setState(() {
          _variationImage = data;
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Only .png, .jpg, and .jpeg formats are allowed.')),
        );
      }
    }
  }

  bool validate() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    if (_variationImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a variation image.')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(right: 10),
      child: Form(
        key: _formKey,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Variation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                    tooltip: 'Delete Variation',
                  ),
                ],
              ),
              InkWell(
                onTap: _pickVariationImage,
                child: _variationImage == null
                    ? Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade100,
                              Colors.green.shade400
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_photo_alternate,
                              size: 50, color: Colors.white),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _variationImage!,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _variationNameController,
                decoration: InputDecoration(
                  labelText: 'Variation Name',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a variation name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _variationPriceController,
                decoration: InputDecoration(
                  labelText: 'Variation Price',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a variation price.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
