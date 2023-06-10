part of 'products_bloc.dart';

enum DataStateStatus { initial, loading, loadMore, success, error }

@immutable
class ProductsState {
  final DataStateStatus status;
  final List<ProductResponseModel>? products;
  final String errorMessage;
  final int size;
  final int page;

  const ProductsState({
    this.status = DataStateStatus.initial,
    this.products,
    this.errorMessage = "",
    this.size = 15,
    this.page = 1,
  });

  ProductsState copyWith({
    DataStateStatus? status,
    List<ProductResponseModel>? products,
    String? errorMessage,
    int? size,
    int? page,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      size: size ?? this.size,
      page: page ?? this.page,
    );
  }
}
