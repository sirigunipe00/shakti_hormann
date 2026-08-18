import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/hardware_packing/data/hardware_repo.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing_item.dart';

part 'hardware_items_cubit.freezed.dart';

@injectable
class HardwarePackingItemsCubit
    extends AppBaseCubit<HardwarePackingItemsState> {
  HardwarePackingItemsCubit(this.repo)
    : super(HardwarePackingItemsState.initial());

  final HardWareRepo repo;

  Future<void> fetchHardwareItems(File imageFile) async {
    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 40,
      );

      if (compressedBytes == null) {
        emitSafeState(
          state.copyWith(
            isLoading: false,
            error: const Failure(
              title: 'Error',
              error: 'Unable to compress image',
            ),
          ),
        );
        return;
      }

      final base64Image = base64Encode(compressedBytes);
      final ext = imageFile.path.split('.').last.toLowerCase();

      String mimeType;

      switch (ext) {
        case 'png':
          mimeType = 'image/png';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'jpg':
        case 'jpeg':
        default:
          mimeType = 'image/jpeg';
      }

      final imageData = 'data:$mimeType;base64,$base64Image';

      final response = await repo.fetchHardwareItems(imageData);

      response.fold(
        (failure) {
          emitSafeState(state.copyWith(isLoading: false, error: failure));
        },
        (response) {
          emitSafeState(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              response: response.copyWith(mesStickerImage: imageFile),
            ),
          );
        },
      );
    } catch (e) {
      emitSafeState(
        state.copyWith(
          isLoading: false,
          error: Failure(title: 'Error', error: e.toString()),
        ),
      );
    }
  }

  void clear() {
    emitSafeState(HardwarePackingItemsState.initial());
  }

  void errorHandled() {
    emitSafeState(
      state.copyWith(error: null, isLoading: false, isSuccess: false),
    );
  }
}

@freezed
class HardwarePackingItemsState with _$HardwarePackingItemsState {
  const factory HardwarePackingItemsState({
    HardwarePackingItem? response,
    required bool isLoading,
    required bool isSuccess,
    Failure? error,
  }) = _HardwarePackingItemsState;

  factory HardwarePackingItemsState.initial() {
    return const HardwarePackingItemsState(
      response: null,
      isLoading: false,
      isSuccess: false,
    );
  }
}
