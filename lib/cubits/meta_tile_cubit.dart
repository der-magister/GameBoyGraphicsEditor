import 'package:game_boy_graphics_editor/models/graphics/meta_tile.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../models/sourceConverters/source_converter.dart';

class MetaTileCubit extends ReplayCubit<MetaTile> {
  MetaTileCubit() : super(MetaTile(height: 8, width: 8));

  List<int> _shift(List<int> list, int v) {
    var i = v % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }

  flood(int rowIndex, int colIndex, int metaTileIndex, int intensity, int targetColor) =>
      emit(state.copyWith()..flood(metaTileIndex, intensity, rowIndex, colIndex, targetColor));

  void setPixel(int rowIndex, int colIndex, int tileIndexTile, int intensity) {
    List<int> tileData = [...state.data];
    tileData[(colIndex * state.width + rowIndex) + state.nbPixel * tileIndexTile] = intensity;
    emit(state.copyWith(data: tileData));
  }

  void setDimensions(int width, int height) => emit(state.copyWith(
      width: width, height: height, data: List.generate(width * height, (index) => 0)));

  void addTile(int index) {
    List<int> tileData = [...state.data];
    var newTile = List.generate(state.width * state.height, (index) => 0);
    tileData.insertAll((index + 1) * state.nbPixel, newTile);
    emit(state.copyWith(data: tileData));
  }

  void removeTile(int tileIndex) {
    List<int> tileData = [...state.data];
    tileData.removeRange((tileIndex) * state.nbPixel, tileIndex * state.nbPixel + state.nbPixel);
    emit(state.copyWith(data: tileData));
  }

  void rightShift(int tileIndex, int index) {
    var metaTile = state.copyWith();

    for (int indexRow = 0; indexRow < metaTile.height; indexRow++) {
      var row = metaTile.getRow(tileIndex, indexRow);
      row.replaceRange(0, row.length, _shift(row, -1));
      metaTile.setRow(tileIndex, indexRow, row);
    }

    emit(metaTile);
  }

  void leftShift(int tileIndex, int index) {
    var metaTile = state.copyWith();

    for (int indexRow = 0; indexRow < metaTile.height; indexRow++) {
      var row = metaTile.getRow(tileIndex, indexRow);
      row.replaceRange(0, row.length, _shift(row, 1));
      metaTile.setRow(tileIndex, indexRow, row);
    }

    emit(metaTile);
  }

  void upShift(int tileIndex, int index) {
    var metaTile = state.copyWith();
    var rowTemp = metaTile.getRow(tileIndex, 0);

    for (int indexRow = 0; indexRow < metaTile.height - 1; indexRow++) {
      var row = metaTile.getRow(tileIndex, indexRow + 1);
      metaTile.setRow(tileIndex, indexRow, row);
    }

    metaTile.setRow(tileIndex, metaTile.height - 1, rowTemp);
    emit(metaTile);
  }

  void downShift(int tileIndex, int index) {
    var metaTile = state.copyWith();
    var rowTemp = metaTile.getRow(tileIndex, metaTile.height - 1);

    for (int indexRow = metaTile.height - 1; indexRow > 0; indexRow--) {
      var row = metaTile.getRow(tileIndex, indexRow - 1);
      metaTile.setRow(tileIndex, indexRow, row);
    }

    metaTile.setRow(tileIndex, 0, rowTemp);
    emit(metaTile);
  }

  flipHorizontal(int tileIndex) {
    var metaTile = state.copyWith();

    for (int rowIndex = 0; rowIndex < state.height; rowIndex++) {
      for (int colIndex = 0; colIndex < state.width; colIndex++) {
        int intensity = state.getPixel(rowIndex, state.width - 1 - colIndex, tileIndex);
        metaTile.setPixel(rowIndex, colIndex, tileIndex, intensity);
      }
    }

    emit(metaTile);
  }

  flipVertical(int tileIndex) {
    var metaTile = state.copyWith();

    for (int rowIndex = 0; rowIndex < state.height; rowIndex++) {
      for (int colIndex = 0; colIndex < state.width; colIndex++) {
        int intensity = state.getPixel(state.width - 1 - colIndex, rowIndex, tileIndex);
        metaTile.setPixel(colIndex, rowIndex, tileIndex, intensity);
      }
    }

    emit(metaTile);
  }

  void rotateRight(int tileIndex) {
    var metaTile = state.copyWith();

    for (int rowIndex = 0; rowIndex < state.height; rowIndex++) {
      for (int colIndex = 0; colIndex < state.width; colIndex++) {
        int intensity = state.getPixel(rowIndex, state.width - 1 - colIndex, tileIndex);
        metaTile.setPixel(colIndex, rowIndex, tileIndex, intensity);
      }
    }

    emit(metaTile);
  }

  void rotateLeft(int tileIndex) {
    var metaTile = state.copyWith();

    for (int rowIndex = 0; rowIndex < state.height; rowIndex++) {
      for (int colIndex = 0; colIndex < state.width; colIndex++) {
        int intensity = state.getPixel(state.width - 1 - colIndex, rowIndex, tileIndex);
        metaTile.setPixel(rowIndex, colIndex, tileIndex, intensity);
      }
    }

    emit(metaTile);
  }

  void paste(int tileIndex, tileBuffer) {}

  setData(List<String> values) {
    var data = <int>[];

    for (var index = 0; index < values.length; index += 2) {
      var lo = toBinary(values[index]);
      var hi = toBinary(values[index + 1]);

      var combined = "";
      for (var index = 0; index < 8; index++) {
        combined += hi[index] + lo[index];
      }

      for (var indexBis = 0; indexBis < 8 * 2; indexBis += 2) {
        data.add(int.parse(combined[indexBis] + combined[indexBis + 1], radix: 2));
      }
    }

    emit(state.copyWith(data: data));
  }
}
