import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.text, required this.tag});
  final String text;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: const Icon(
                color: Colors.black,
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Hero(
            tag: tag,
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                textStyle: Theme.of(context)
                    .textTheme
                    .apply(
                        displayColor: Theme.of(context).colorScheme.onSurface)
                    .headlineLarge,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
