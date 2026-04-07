import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bottom_sheet_selector_cubit.dart';

class BottomSheetSelectorSelectedContainer<T> extends StatelessWidget {
  final T selectedItem;
  final Widget Function(T) builder;

  const BottomSheetSelectorSelectedContainer({
    super.key,
    required this.builder,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.4);
    final bg = theme.colorScheme.surface;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.read<BottomSheetSelectorCubit>().displayOptions(),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: DefaultTextStyle.merge(
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  child: builder(selectedItem),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 22,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
