import 'package:flutter/material.dart';

import 'pixel.dart';

class PixelGridWidget extends StatefulWidget {
  final List intensity;
  final Function? onTap;

  const PixelGridWidget({Key? key, required this.intensity, this.onTap})
      : super(key: key);

  @override
  _PixelGridWidgetState createState() => _PixelGridWidgetState();
}

class _PixelGridWidgetState extends State<PixelGridWidget> {
  int spriteSize = 8;

  Widget _buildEditor(BuildContext context, int index) {
    return GestureDetector(
      child: GridTile(
        child: GestureDetector(
          onTap: () => widget.onTap != null ? widget.onTap!(index) : null,
          child: PixelWidget(intensity: widget.intensity[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: _buildEditor,
        itemCount: spriteSize * spriteSize,
      ),
    );
  }
}