import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return ListenableBuilder(
      listenable: router.routerDelegate,
      builder: (context, _) {
        final canPop = context.canPop(); // ✅ GoRouter-aware pop check

        return AppBar(
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 4.0,
                    bottom: 4.0,
                  ),
                  child: Image.asset('assets/images/logo.png'),
                ),
          title: const Text(
            'MonkeyFood',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
