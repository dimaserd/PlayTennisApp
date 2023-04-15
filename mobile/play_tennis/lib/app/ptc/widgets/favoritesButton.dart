import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
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
        setState(() {
          _isFavorite = !_isFavorite;
        });
        Future.delayed(const Duration(seconds: 1), () {
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
