import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutual_fund_app/module/favourites/controller/favourite_controller.dart';
import 'package:mutual_fund_app/widgets/fund_tile.dart';
import 'package:mutual_fund_app/constant/constant.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Get.find<FavoritesController>();
    return Scaffold(
      appBar: buildAppBar('Favourites'),
      body: Obx(() {
        final list = fav.favs;
        if (list.isEmpty)
          return const Center(child: Text(constantMessage.NoFavs));
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, idx) {
            //builds each row
            final s = list[idx];
            return FundTile(scheme: s);
          },
        );
      }),
    );
  }
}
