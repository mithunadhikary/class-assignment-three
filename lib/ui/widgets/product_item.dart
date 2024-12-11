import 'package:flutter/material.dart';
import 'package:class_assignment_three/models/product.dart';
import 'package:class_assignment_three/ui/screens/update_product_screen.dart';
import 'package:http/http.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.image ?? '',
        width: 40,
      ),
      title: Text(product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${product.quantity ?? 'Unknown'}'),
          Text('Price: ${product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${product.totalPrice ?? 'Unknown'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(onPressed: () {
            // TODO: implement delete product api
            _deleteProduct(product.id);
          }, icon: const Icon(Icons.delete)),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: product,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(id) async {
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/${id}');

    Response response = await get(
      uri,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("Delete");
    } else {
      print("Not delete");
    }
  }
}