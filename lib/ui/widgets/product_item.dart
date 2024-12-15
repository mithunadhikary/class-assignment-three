import 'package:flutter/material.dart';
import 'package:class_assignment_three/models/product.dart';
import 'package:class_assignment_three/ui/screens/update_product_screen.dart';
import 'package:http/http.dart';

import '../screens/product_list_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

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
          IconButton(
            onPressed: () {
              // TODO: implement delete product api
              _deleteProduct(context, product.id);
            },
            icon: const Icon(Icons.delete),
          ),
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

  Future<void> _deleteProduct(BuildContext context, id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // User confirmed
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Proceed with delete API call if user confirmed
      Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$id');

      Response response = await get(
        uri,
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context)=>ProductListScreen(),),
              (Route route) => false,
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete product.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete action canceled.'),
        ),
      );
    }
  }

}
