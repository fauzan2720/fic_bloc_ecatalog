import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductDataSource dataSource;
  UpdateProductBloc(
    this.dataSource,
  ) : super(UpdateProductInitial()) {
    on<DoUpdateProductEvent>((event, emit) async {
      emit(UpdateProductLoading());
      final result = await dataSource.updateProduct(event.id, event.model);
      result.fold(
        (error) => emit(UpdateProductError(message: error)),
        (data) => emit(UpdateProductLoaded(model: data)),
      );
    });
  }
}
