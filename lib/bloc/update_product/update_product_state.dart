part of 'update_product_bloc.dart';

@immutable
abstract class UpdateProductState {}

class UpdateProductInitial extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductLoaded extends UpdateProductState {
  final ProductResponseModel model;
  UpdateProductLoaded({
    required this.model,
  });
}

class UpdateProductError extends UpdateProductState {
  final String message;
  UpdateProductError({
    required this.message,
  });
}
