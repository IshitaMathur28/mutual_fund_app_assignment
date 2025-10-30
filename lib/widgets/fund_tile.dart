import 'package:flutter/material.dart';
import 'package:mutual_fund_app/data/model/scheme_model.dart';
import 'package:mutual_fund_app/module/detail/view/detail_view.dart';
import 'package:get/get.dart';
import 'package:mutual_fund_app/module/favourites/controller/favourite_controller.dart';

class FundTile extends StatelessWidget {
  final Scheme scheme;
  final bool isFav;

  const FundTile({required this.scheme, this.isFav = false, super.key});

  @override
  Widget build(BuildContext context) {
    final favCtrl = Get.find<FavoritesController>();
    //final isFav = favCtrl.contains(scheme);
    return ListTile(
      title: Text(scheme.schemeName),
      subtitle: Text('Code: ${scheme.schemeCode}'),
      trailing: IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : null,
        ),
        onPressed: () => isFav ? favCtrl.remove(scheme) : favCtrl.add(scheme),
      ),
      onTap: () => Get.to(() => DetailsScreen(scheme: scheme)),
    );
  }
}
