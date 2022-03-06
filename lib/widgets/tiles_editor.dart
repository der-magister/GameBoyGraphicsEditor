import 'package:flutter/material.dart';
import 'package:gbdk_graphic_editor/background.dart';
import 'package:gbdk_graphic_editor/widgets/dot_matrix.dart';
import 'package:gbdk_graphic_editor/widgets/tile_list_view.dart';

import '../colors.dart';
import '../tiles.dart';
import 'background_widget.dart';
import 'graphics_data_display.dart';

class TilesEditor extends StatelessWidget {
  final Background preview;
  final Tiles tiles;
  final Function setTilesIndex;
  final Function setPixel;
  final bool showGrid;
  final int selectedTileIndex;

  const TilesEditor(
      {Key? key,
      required this.preview,
      required this.tiles,
      required this.setTilesIndex,
      required this.showGrid,
      required this.setPixel,
      required this.selectedTileIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TileListView(
          onTap: (index) => setTilesIndex(index),
          tiles: tiles,
          selectedTile: selectedTileIndex),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DotMatrix(
          onTap: setPixel,
          pixels:
              tiles.getData(selectedTileIndex).map((e) => colors[e]).toList(),
          showGrid: showGrid,
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 200,
                child: BackgroundWidget(
                  background: preview,
                  tiles: tiles,
                  onTap: null,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GraphicsDataDisplay(
                  graphics: tiles,
                ),
              ),
            )
          ],
        ),
      )
    ]);
  }
}