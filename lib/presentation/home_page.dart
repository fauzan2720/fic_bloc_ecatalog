import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/bloc/update_product/update_product_bloc.dart';
import 'package:flutter_ecatalog/data/datasources/local_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_ecatalog/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  Future<void> showDialogAddProduct() async {
    titleController?.clear();
    priceController?.clear();
    descriptionController?.clear();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 8,
              ),
              BlocConsumer<AddProductBloc, AddProductState>(
                listener: (context, state) {
                  if (state is AddProductLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Product Success')),
                    );
                    context.read<ProductsBloc>().add(GetProductsEvent());
                    titleController!.clear();
                    priceController!.clear();
                    descriptionController!.clear();
                    Navigator.pop(context);
                  }
                  if (state is AddProductError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AddProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                      onPressed: () {
                        final modelRequest = ProductRequestModel(
                          title: titleController!.text,
                          price: int.parse(priceController!.text),
                          description: descriptionController!.text,
                        );

                        context
                            .read<AddProductBloc>()
                            .add(DoAddProductEvent(model: modelRequest));
                      },
                      child: const Text('Add'));
                },
              ),
            ],
          );
        });
  }

  Future<void> showDialogUpdateProduct(ProductResponseModel model) async {
    titleController?.text = model.title!;
    priceController?.text = model.price.toString();
    descriptionController?.text = model.description!;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 8,
              ),
              BlocConsumer<UpdateProductBloc, UpdateProductState>(
                listener: (context, state) {
                  if (state is UpdateProductLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Update Product Success')),
                    );
                    context.read<ProductsBloc>().add(GetProductsEvent());
                    titleController!.clear();
                    priceController!.clear();
                    descriptionController!.clear();
                    Navigator.pop(context);
                  }
                  if (state is UpdateProductError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UpdateProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                      onPressed: () {
                        final modelRequest = ProductRequestModel(
                          title: titleController!.text,
                          price: int.parse(priceController!.text),
                          description: descriptionController!.text,
                        );

                        context.read<UpdateProductBloc>().add(
                            DoUpdateProductEvent(
                                id: model.id!, model: modelRequest));
                      },
                      child: const Text('Update'));
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        context.read<ProductsBloc>().add(LoadMoreProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource().removeToken();
              if (context.mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return const LoginPage();
                }));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Berhasil logout'),
                ));
              }
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          // if (state.status == DataStateStatus.loadMore) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //     content: Text('Loading More...'),
          //     duration: Duration(milliseconds: 1000),
          //   ));
          // }
        },
        builder: (context, state) {
          if (state.status == DataStateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == DataStateStatus.success ||
              state.status == DataStateStatus.loadMore) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () =>
                              showDialogUpdateProduct(state.products![index]),
                          title: Text(state.products![index].title ?? '-'),
                          subtitle: Text('${state.products![index].price}\$'),
                        ),
                      );
                    },
                    itemCount: state.products!.length,
                  ),
                  if (state.status == DataStateStatus.loadMore)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogAddProduct(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
