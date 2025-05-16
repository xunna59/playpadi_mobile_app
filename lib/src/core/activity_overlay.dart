import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          top: 0,
          left: 0,
          child: Material(
            color: const Color.fromARGB(107, 255, 255, 255),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(120, 66, 255, 1),
                ),
              ),
            ),
          ),
        ),
  );

  static void show(BuildContext context) {
    Overlay.of(context).insert(overlayEntry);
  }

  static void hide() {
    overlayEntry.remove();
  }
}
