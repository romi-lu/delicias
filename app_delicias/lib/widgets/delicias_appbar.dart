import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DeliciasAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const DeliciasAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
