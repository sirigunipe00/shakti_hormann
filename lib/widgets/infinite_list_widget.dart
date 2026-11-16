import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/cubit/infinite_list/infinite_list_cubit.dart';
import 'package:shakti_hormann/core/model/failure.dart';
import 'package:shakti_hormann/core/utils/responsive.dart';
import 'package:shakti_hormann/widgets/app_failure_widget.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/empty_data_widget.dart';

typedef ChildWidgetBuilder<T> = Widget Function(BuildContext context, T data);

class InfiniteListViewWidget<T extends StateStreamable<InfiniteListState<D>>, D>
    extends StatelessWidget {
  const InfiniteListViewWidget({
    required this.childBuilder,
    required this.fetchInitial,
    required this.fetchMore,
    required this.emptyListText,
    this.dense = false,
    this.indexedChildBuilder,
    super.key,
  });

  final ChildWidgetBuilder<D> childBuilder;
  final Widget Function(BuildContext context, D data, int index)?
      indexedChildBuilder;
  final VoidCallback fetchInitial;
  final VoidCallback fetchMore;
  final String emptyListText;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, InfiniteListState<D>>(
      builder: (_, InfiniteListState<D> state) {
        return state.when(
          initial:
              () => const Center(child: CircularProgressIndicator()),
          loading:
              () => const Center(child: CircularProgressIndicator()),
          success: (
            List<D> data,
            bool hasReachedMax,
            bool isloadingMore,
            Failure? failure,
          ) {
            log('data----:${data.length}');
            if (data.isEmpty) {
              return EmptyDataWidget(
                emptyText: emptyListText,
                onRefresh: fetchInitial,
              );
            }

            return _InfiniteListView<D>(
              data: data,
              childBuilder: childBuilder,
              indexedChildBuilder: indexedChildBuilder,
              fetchInitial: fetchInitial,
              fetchMore: fetchMore,
              hasReachedMax: hasReachedMax,
              failure: failure,
              dense: dense,
            );
          },
          failed:
              (Failure f) => AppFailureWidget(
                message: f.error,
                onPress: fetchInitial,
              ),
        );
      },
    );
  }
}

class _InfiniteListView<T> extends StatefulWidget {
  const _InfiniteListView({
    required this.data,
    required this.childBuilder,
    required this.fetchInitial,
    required this.fetchMore,
    required this.hasReachedMax,
    this.indexedChildBuilder,
    this.failure,
    this.dense = false,
    super.key,
  });

  final ChildWidgetBuilder<T> childBuilder;
  final Widget Function(BuildContext context, T data, int index)?
      indexedChildBuilder;
  final List<T> data;
  final bool hasReachedMax;
  final VoidCallback fetchInitial;
  final VoidCallback fetchMore;
  final Failure? failure;
  final bool dense;

  @override
  State<_InfiniteListView<T>> createState() => _InfiniteListViewState<T>();
}

class _InfiniteListViewState<T> extends State<_InfiniteListView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final bool hasScrolledToBottom =
          _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      if (hasScrolledToBottom &&
          !_scrollController.position.outOfRange &&
          !widget.hasReachedMax) {
        widget.fetchMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<T> data = widget.data;
    final bool hasReachedMax = widget.hasReachedMax;
    final int listLen =
        widget.failure != null || !hasReachedMax
            ? widget.data.length + 1
            : widget.data.length;

    return Material(
      type: MaterialType.transparency,
      child: ListView.separated(
        separatorBuilder: (_, __) =>
            widget.dense ? const SizedBox.shrink() : AppSpacer.p2(),
        physics: const AlwaysScrollableScrollPhysics(),
        // Clear floating bottom nav + "New" FAB (extendBody overlay).
        padding: EdgeInsets.only(
          bottom: Responsive.listBottomClearance(context),
        ),
        itemCount: listLen,
        controller: _scrollController,
        itemBuilder: (BuildContext ctx, int idx) {
          if (idx >= data.length) {
            if (widget.failure != null) {
              return AppFailureWidget(
                message: widget.failure!.error,
                onPress: hasReachedMax ? widget.fetchInitial : widget.fetchMore,
              );
            }

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final indexed = widget.indexedChildBuilder;
          if (indexed != null) {
            return indexed(context, data[idx], idx);
          }
          return widget.childBuilder(context, data[idx]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
