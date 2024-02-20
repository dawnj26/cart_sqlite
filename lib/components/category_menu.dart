import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({
    super.key,
    required this.categories,
  });

  final List<Widget> categories;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: categories,
      builder: (_, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
