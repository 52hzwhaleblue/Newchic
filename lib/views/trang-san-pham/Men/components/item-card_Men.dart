import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onboarding_demo/models/MODEL_productMen.dart';
import 'package:onboarding_demo/models/api-product/productMen.dart';
import 'package:onboarding_demo/models/cart_api.dart';
import 'package:onboarding_demo/network/network_request.dart';
import 'package:onboarding_demo/views/constants.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_demo/views/trang-san-pham-chi-tiet/product_details_constants.dart';
import 'package:onboarding_demo/views/trang-san-pham-chi-tiet/product_detail_men.dart';

// ignore: camel_case_types
class item_card_Men extends StatefulWidget {
  const item_card_Men({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<item_card_Men> createState() => _item_cardState();
}

class _item_cardState extends State<item_card_Men> {
  Future<Cart_API> _futurecart;
  Future<api_productMen> _futureProductMen;

  List<api_productMen> productMenData = [];
  @override
  void initState() {
    super.initState();
    NetworkRequest.fetchProductMen().then((dataFromServe) {
      setState(() {
        productMenData = dataFromServe;
      });
    });
  }

  var listStatusIcons = List.filled(productMen.length, false);
  List favoriteProducts_List = [];

  bool isRemoved = false;

  // set statsu icon
  void setStatusIcon(int index) {
    for (int i = 0; i < listStatusIcons.length; i++) {
      if (i == index) {
        // kiểm tra xem icon bấy giờ đang ở trạng thái nào true hay false
        if (listStatusIcons[i]) {
          // gán icon = false, icon true thì remove icon đi,
          listStatusIcons[i] = false;
          // favoriteProducts_List.removeAt(i);
        } else {
          // nếu trạng thái icon false -> add vào yêu thích
          listStatusIcons[i] = true;
          favoriteProducts_List.add(listStatusIcons[index]);
        }
        break;
      }
    }
  }

  // trả về trạng thái icon true hay false
  getStatusIcon(var index) {
    for (var i = 0; i < listStatusIcons.length; i++) {
      if (i == index) {
        return listStatusIcons[i];
      }
    }

    for (var i = 0; i < favoriteProducts_List.length; i++) {
      if (i == index) {
        return favoriteProducts_List[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FutureBuilder<Cart_API>(
      future: _futurecart,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.productName);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );

    Future<Cart_API> createCart(
      int productID,
      String productName,
      int price,
      int quantity,
      String image,
      int sub_total,
      bool isAdd,
    ) async {
      final response = await http.post(
        Uri.parse('http://192.168.1.220:3000/cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Product ID': productID,
          'Product Name': productName,
          'Price': price,
          'Image': image,
          'Quantity': quantity,
          'Sub Total': sub_total,
          'isAdd': isAdd,
        }),
      );
      if (response.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return Cart_API.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to create cart.');
      }
    }

    // Future<api_productMen> updateProductMen(int id, String name, int price,
    //     String image, int quantity, String type, bool status) async {
    //   var index = int.parse('$id');
    //   final response = await http.post(
    //     Uri.parse("http://192.168.1.220:3000/productsMen/'$index' "),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(<String, dynamic>{
    //       'id': id,
    //       'name': name,
    //       'price': price,
    //       'quantity': quantity,
    //       'image': image,
    //       'type': type,
    //       'status': status,
    //     }),
    //   );

    //   if (response.statusCode == 200) {
    //     // If the server did return a 200 OK response,
    //     // then parse the JSON.
    //     return api_productMen.fromJson(jsonDecode(response.body));
    //   } else {
    //     // If the server did not return a 200 OK response,
    //     // then throw an exception.
    //     throw Exception('Failed to update product.');
    //   }
    // }

    return Container(
      padding: EdgeInsets.only(right: 5),
      height: size.height * productMen.length / 4.5,
      width: size.width,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: productMenData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // bề ngang
            childAspectRatio: 0.75,
            mainAxisSpacing: 30, // khoảng cách trên dưới
            crossAxisSpacing: 1,
          ),
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: widget.size.width * 0.45,
                height: widget.size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 6),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      productID = productMenData[index].id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailMen(),
                        ),
                      );
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: widget.size.width * 0.45,
                        height: 180,
                        child: Image.network(
                          '${productMenData[index].image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    ' ${productMenData[index].name}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    setStatusIcon(index);

                                    productIDCart = productMenData[index].id;
                                    productNameCart =
                                        '${productMenData[index].name}';

                                    productPriceCart =
                                        '${productMenData[index].price}';

                                    productImageCart =
                                        '${productMenData[index].image}';

                                    int.parse(productPriceCart);

                                    quantityCart = 1;

                                    subTotalCart = productPriceCart;

                                    isAdd = true;

                                    if (productMenData[index].status == true) {
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Sản phẩm đã có trong giỏ hàng",
                                            ),
                                            action: SnackBarAction(
                                              label: "Checkout",
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                    } else {
                                      _futurecart = createCart(
                                        productIDCart,
                                        productNameCart,
                                        int.parse(productPriceCart),
                                        quantityCart,
                                        productImageCart,
                                        int.parse(subTotalCart),
                                        isAdd,
                                      );

                                      // sau khi thêm sản phẩm vài giỏ hàng,
                                      //cập nhật lại trạng thái cho sản phẩm đó
                                      // cập nhật lại số lượng sản phẩm sau khi user mua hàng
                                      // quantity_product = int.parse(
                                      //         '${productMenData[index].quantity}') -
                                      //     1;
                                      // i1 = productMenData[index].id;
                                      // i2 = productMenData[index].name;
                                      // i3 = productMenData[index].price;
                                      // i4 = productMenData[index].image;
                                      // i5 = quantity_product;
                                      // i6 = productMenData[index].type;
                                      // i7 = productMenData[index].status;
                                      // _futureProductMen = updateProductMen(
                                      //   i1,
                                      //   i2,
                                      //   i3,
                                      //   i4,
                                      //   i5,
                                      //   i6,
                                      //   i7,
                                      // );
                                    }
                                  });
                                },
                                icon: (getStatusIcon(index))
                                    ? Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.add_shopping_cart),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '\$${productMenData[index].price}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.pinkAccent[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
