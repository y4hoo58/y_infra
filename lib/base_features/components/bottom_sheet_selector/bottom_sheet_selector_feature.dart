import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/bottom_sheet_selector_cubit.dart';

class BottomSheetSelectorFeature<T> extends StatelessWidget {
  final Widget child;
  final T? initialValue;

  const BottomSheetSelectorFeature({
    super.key,
    required this.child,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomSheetSelectorCubit>(
      create: (_) {
        final cubit = BottomSheetSelectorCubit();
        if (initialValue != null) {
          cubit.emitSelected(initialValue);
        }
        return cubit;
      },
      child: child,
    );
  }
}
