import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/inputs/simple_search_bar.dart';

enum PageMode3 {
  gateentry('Gate Entry'),
  gateexit('Gate Exit'),
  logisticRequest('Logistic Request'),
  transportConfirmation('Transport Confirmation'),
  vehicleReporting('Vehicle Reporting Entry'),
  loadingConfirmation('Laoding Confirmation');

  const PageMode3(this.name);
  final String name;
}

class AppPageView3<T extends PageViewFiltersCubit> extends StatefulWidget {
  const AppPageView3({
    super.key,
    required this.child,
    required this.mode,
    required this.onNew,
    required this.backgroundColor,
    required this.scaffoldBg,
  });

  final Widget child;
  final PageMode3 mode;
  final VoidCallback onNew;
  final Color backgroundColor;
  final String scaffoldBg;

  @override
  State<AppPageView3<T>> createState() => _AppPageView3State<T>();
}

class _AppPageView3State<T extends PageViewFiltersCubit>
    extends State<AppPageView3<T>> {
  bool isTodaySelected = true;

  String get hintText => switch (widget.mode) {
    PageMode3.gateentry => 'Search GI / PO',
    PageMode3.gateexit => 'Search GO / SINV',
    PageMode3.logisticRequest => 'Search LR / SO ID',
    PageMode3.transportConfirmation => 'Search LR / TC',
    PageMode3.vehicleReporting => 'Search VRE / TC',
    PageMode3.loadingConfirmation => 'Search LC / TC',
  };

  Color get bgColor => switch (widget.mode) {
    PageMode3.gateentry => Colors.white,
    PageMode3.gateexit => AppColors.white,
    PageMode3.logisticRequest => const Color(0xFF808080),
    PageMode3.transportConfirmation => AppColors.white,
    PageMode3.vehicleReporting => AppColors.white,
    PageMode3.loadingConfirmation => AppColors.white,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: SvgPicture.asset(
                'assets/images/filter.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFB800),
                  BlendMode.srcIn,
                ),
                fit: BoxFit.contain,
                width: 35,
              ),
            ),
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: context.pop,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.liteyellow,
                      size: 22,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.mode.name,
                      style: AppTextStyles.titleLarge(context).copyWith(
                        color: AppColors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SimpleSearchBar(
                    initial: context.read<T>().state.query,
                    hintText: hintText,
                    onCancel: context.cubit<T>().onSearch,
                    onSearch: context.cubit<T>().onSearch,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
                border: Border.all(color: AppColors.white),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.symmetric(horizontal: 28),
        onPressed: widget.onNew,
        backgroundColor: AppColors.darkBlue,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          'New',
          style: AppTextStyles.titleLarge(
            context,
          ).copyWith(color: AppColors.white, fontSize: 22),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
