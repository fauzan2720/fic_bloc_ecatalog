import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource dataSource;
  ProductsBloc(
    this.dataSource,
  ) : super(const ProductsState()) {
    on<GetProductsEvent>((event, emit) async {
      emit(state.copyWith(status: DataStateStatus.loading));
      final result = await dataSource.getAllProduct(
        size: state.size,
        page: state.page,
      );
      result.fold(
        (error) => emit(state.copyWith(
          status: DataStateStatus.error,
          errorMessage: error,
        )),
        (result) => emit(state.copyWith(
          status: DataStateStatus.success,
          products: result,
        )),
      );
    });

    on<LoadMoreProductsEvent>((event, emit) async {
      emit(state.copyWith(status: DataStateStatus.loadMore));
      final result = await dataSource.getAllProduct(
        size: state.size,
        page: state.page,
      );
      result.fold(
        (error) => emit(state.copyWith(
          status: DataStateStatus.error,
          errorMessage: error,
        )),
        (result) => emit(state.copyWith(
          status: DataStateStatus.success,
          products: state.products! + result,
          page: state.page + 1,
        )),
      );
    });
  }
}
