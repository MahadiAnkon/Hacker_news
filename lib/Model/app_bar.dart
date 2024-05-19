import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool back = false;

  const CustomAppBar({super.key, required this.title, back,});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: back,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Row(
        children: [
          const Icon(Icons.home_max_outlined),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
