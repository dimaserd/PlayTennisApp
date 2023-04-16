import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';

class FavoriteButton extends StatefulWidget {
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        context.loaderOverlay.show();
        
        setState(() {
          _isFavorite = !_isFavorite;
        });
        Future.delayed(const Duration(seconds: 1), () {
          context.loaderOverlay.hide();
          setState(() {
            _isFavorite = false;
          });
        });

        if (_isFavorite) {
          AnimatedSnackBar.material(
            'Пока не реализовано',
            type: AnimatedSnackBarType.info,
            mobileSnackBarPosition: MobileSnackBarPosition
                .bottom, // Position of snackbar on mobile devices
            duration: const Duration(
                seconds: 2), // Position of snackbar on desktop devices
          ).show(context);
        }
      },
    );
  }
}


