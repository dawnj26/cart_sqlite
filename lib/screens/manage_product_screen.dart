import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quinto_assignment2/models/product.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({
    super.key,
    this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? 'Add product' : 'Edit product'),
      ),
      body: ProductForm(
        product: product,
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  const ProductForm({
    super.key,
    this.product,
  });

  final Product? product;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.product != null) {
      codeController.text = widget.product!.code;
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Product Code"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Code must not be empty';
                }

                return null;
              },
              readOnly: widget.product != null,
            ),
            const Gap(12.0),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Product Name"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name must not be empty';
                }

                return null;
              },
            ),
            const Gap(12.0),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Product Price"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price must not be empty';
                }

                if (double.tryParse(value) == null) {
                  return 'Price must be a number';
                }

                return null;
              },
            ),
            const Gap(16.0),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                final p = Product(
                  code: codeController.text,
                  name: nameController.text,
                  price: double.parse(priceController.text),
                );

                if (widget.product == null) {
                  Provider.of<Products>(context, listen: false)
                      .insertProduct(p);
                } else {
                  p.isFavorite = widget.product!.isFavorite;
                  Provider.of<Products>(context, listen: false)
                      .updateProduct(p);
                }

                Navigator.pop(context);
              },
              child: Text(widget.product == null ? 'Add product' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
