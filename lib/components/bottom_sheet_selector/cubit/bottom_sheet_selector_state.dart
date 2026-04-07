part of 'bottom_sheet_selector_cubit.dart';

sealed class BottomSheetSelectorState extends Equatable {
  const BottomSheetSelectorState();

  @override
  List<Object> get props => [];
}

final class BottomSheetSelectorInitial extends BottomSheetSelectorState {
  const BottomSheetSelectorInitial();
}

final class BottomSheetSelectorSelecting extends BottomSheetSelectorState {
  const BottomSheetSelectorSelecting();
}

final class BottomSheetSelectorSelected<T> extends BottomSheetSelectorState {
  final T selectedItem;

  const BottomSheetSelectorSelected(this.selectedItem);

  @override
  List<Object> get props => [selectedItem.hashCode];
}

final class BottomSheetSelectorSelectingAgain<T>
    extends BottomSheetSelectorSelected<T> {
  const BottomSheetSelectorSelectingAgain(super.selectedItem);
}
