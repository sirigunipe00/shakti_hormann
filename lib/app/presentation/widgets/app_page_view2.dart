import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/inputs/simple_search_bar.dart';

enum PageMode2 {
  gateentry('Gate Entry'),
  gateexit('Gate Exit'),
  logisticRequest('Logistic Request'),
  transportConfirmation('Transport Confirmation'),
  vehicleReporting('Vehicle Reporting Entry'),
  loadingConfirmation('Laoding Confirmation');

  final String name;
  const PageMode2(this.name);
}

class AppPageView2<T extends PageViewFiltersCubit> extends StatefulWidget {
  const AppPageView2({
    super.key,
    required this.child,
    required this.mode,
    required this.onNew,
    required this.backgroundColor,
    required this.scaffoldBg,
  });

  final Widget child;
  final PageMode2 mode;
  final VoidCallback onNew;
  final Color backgroundColor;
  final String scaffoldBg;

  @override
  State<AppPageView2<T>> createState() => _AppPageView2State<T>();
}

class _AppPageView2State<T extends PageViewFiltersCubit>
    extends State<AppPageView2<T>> {
  bool isTodaySelected = true;

  String get hintText => switch (widget.mode) {
        PageMode2.gateentry => 'Search GI / PO',
        PageMode2.gateexit => 'Search GO / SINV',
        PageMode2.logisticRequest => 'Search LR / SO ID',
        PageMode2.transportConfirmation => 'Search LR / TC',
        PageMode2.vehicleReporting => 'Search VRE / TC',
        PageMode2.loadingConfirmation => 'Search LC / TC',
      };

  Color get bgColor => switch (widget.mode) {
        PageMode2.gateentry => Colors.white,
        PageMode2.gateexit => AppColors.white,
        PageMode2.logisticRequest => const Color(0xFF808080),
        PageMode2.transportConfirmation => AppColors.white,
        PageMode2.vehicleReporting => AppColors.white,
        PageMode2.loadingConfirmation => AppColors.white,
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
                color: const Color(0xFFFFB800),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isTodaySelected = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isTodaySelected
                              ? AppColors.darkBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Urbanist',
                            color: isTodaySelected
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isTodaySelected = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: !isTodaySelected
                              ? AppColors.darkBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Tomorrow',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Urbanist',
                            color: !isTodaySelected
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}
