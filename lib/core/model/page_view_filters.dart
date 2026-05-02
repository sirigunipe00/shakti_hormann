import 'package:equatable/equatable.dart';

class PageViewFilters extends Equatable {

  factory PageViewFilters.initial() => const PageViewFilters(status: 'Draft');
  const PageViewFilters({required this.status, this.query,this.salesOrder});

  final String status;
  final String? query;
  final String? salesOrder;
  
  @override
  List<Object?> get props => [status, query,salesOrder];
  

  PageViewFilters copyWith({
    String? status,
    String? query,
    bool clearSalesOrder = false, 
    String? salesOrder,
  }) => PageViewFilters(status: status ?? this.status, query: query ?? this.query,salesOrder: clearSalesOrder ? null : (salesOrder ?? this.salesOrder));
}