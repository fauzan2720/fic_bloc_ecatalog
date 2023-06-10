part of 'update_product_bloc.dart';

@immutable
abstract class UpdateProductEvent {}

class DoUpdateProductEvent extends UpdateProductEvent {
  final int id;
  final ProductRequestModel model;
  DoUpdateProductEvent({
    required this.id,
    required this.model,
  });
}
