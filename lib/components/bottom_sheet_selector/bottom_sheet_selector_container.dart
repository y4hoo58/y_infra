import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/bottom_sheet_selector_cubit.dart';

class BottomSheetSelectorContainer<T> extends StatelessWidget {
  final Widget emptyChild;
  final Widget Function(T) childBuilder;
  final Widget bottomSheet;

  const BottomSheetSelectorContainer({
    super.key,
    required this.emptyChild,
    required this.childBuilder,
    required this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BottomSheetSelectorCubit>();

    return BlocConsumer<BottomSheetSelectorCubit, BottomSheetSelectorState>(
      listener: (context, state) async {
        if (state is BottomSheetSelectorSelecting ||
            state is BottomSheetSelectorSelectingAgain) {
          final selectedItem = await showModalBottomSheet(
            context: context,
            builder: (_) => bottomSheet,
          );

          cubit.emitSelected(selectedItem);
        }
      },
      builder: (context, state) {
        switch (state) {
          case BottomSheetSelectorInitial():
          case BottomSheetSelectorSelecting():
            return emptyChild;

          case BottomSheetSelectorSelected():
            final selectedItem = state.selectedItem;

            if (selectedItem == null) {
              return emptyChild;
            }

            return childBuilder(selectedItem);
        }
      },
    );
  }
}
