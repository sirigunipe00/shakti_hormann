import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const PageMode2(this.name);

  final String name;
}

class AppPageView2<T extends PageViewFiltersCubit> extends StatefulWidget {
  const AppPageView2({
    super.key,
    required this.child,
    required this.mode,
    required this.onNew,
    required this.backgroundColor,
    required this.scaffoldBg, this.onSearch,
  });

  final Widget child;
  final PageMode2 mode;
  final VoidCallback onNew;
  final Color backgroundColor;
  final String scaffoldBg;
  final VoidCallback? onSearch;

  @override
  State<AppPageView2<T>> createState() => _AppPageView2State<T>();
}

class _AppPageView2State<T extends PageViewFiltersCubit>
    extends State<AppPageView2<T>>
    {
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
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: widget.onSearch
                  
                  
                  
                ),
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
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromARGB(255, 255, 183, 0),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.mode.name,
                    style: AppTextStyles.titleLarge(context).copyWith(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
            padding: const EdgeInsets.all(6.0),
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
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 45,
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
                          color:
                              isTodaySelected
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
                            color: isTodaySelected ? Colors.white : Colors.grey,
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
                          color:
                              !isTodaySelected
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
                            color:
                                !isTodaySelected ? Colors.white : Colors.grey,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: widget.child,
            ),
          ),
        ],
      ),
      floatingActionButton:
          widget.mode != PageMode2.transportConfirmation
              ? FloatingActionButton.extended(
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
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

 
}
