import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_sheet_selector_state.dart';

/// Cubit that manages the selection flow for a bottom sheet selector.
class BottomSheetSelectorCubit<T> extends Cubit<BottomSheetSelectorState> {
  BottomSheetSelectorCubit() : super(const BottomSheetSelectorInitial());

  void displayOptions() {
    final state = this.state;
    if (state is BottomSheetSelectorSelecting) return;
    if (state is BottomSheetSelectorSelectingAgain) return;

    if (state is BottomSheetSelectorSelected<T>) {
      return emit(BottomSheetSelectorSelectingAgain<T>(state.selectedItem));
    }

    emit(const BottomSheetSelectorSelecting());
  }

  void emitSelected(T? selectedItem) {
    final state = this.state;

    if (selectedItem != null) {
      return emit(BottomSheetSelectorSelected<T>(selectedItem));
    }

    if (state is BottomSheetSelectorSelecting) {
      return emit(const BottomSheetSelectorInitial());
    }

    if (state is BottomSheetSelectorSelectingAgain) {
      return emit(BottomSheetSelectorSelected<T>(state.selectedItem));
    }
  }
}
