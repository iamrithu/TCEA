import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcea_app/provider/provider.dart';

import '../../widgets/customCategoryCard.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height * 0.3,
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('Assets/images/categories.jpg'),
              ),
              Positioned(
                  left: 15.0,
                  bottom: 30.0,
                  child: Text(
                    " Category(${ref.watch(categoryList).length})",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ]),
          ),
          Flexible(
            child: Container(
                child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      for (var i = 0; i < ref.watch(categoryList).length; i++)
                        CustomCategoryCard(
                          img: ref.watch(categoryList)[i]["image"] ?? null,
                          lable: "${ref.watch(categoryList)[i]["name"]}",
                        ),
                    ],
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
