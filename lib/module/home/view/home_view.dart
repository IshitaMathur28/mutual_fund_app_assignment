import 'package:flutter/material.dart';
import 'package:mutual_fund_app/module/favourites/controller/favourite_controller.dart';
import 'package:mutual_fund_app/module/scheme/controller/scheme_controller.dart';
import 'package:mutual_fund_app/widgets/fund_tile.dart';
import 'package:mutual_fund_app/module/favourites/view/favourite_view.dart';
import 'package:get/get.dart';
import 'package:mutual_fund_app/theme/app_colors.dart';
import 'package:mutual_fund_app/constant/constant.dart';
import 'package:mutual_fund_app/theme/app_text.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //calling controllers
    final ctrl = Get.find<SchemeController>();
    final favCtrl = Get.find<FavoritesController>();
    final searchCtrl = TextEditingController();

    return Scaffold(
      appBar: buildAppBar('Mutual Funds'),
      //drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Text('Menu', style: appStyle.heading),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favourites'),
              onTap: () {
                Navigator.pop(context);
                //switching to fav screen
                Get.to(() => const FavoritesScreen());
              },
            ),
          ],
        ),
      ),
      //for searchbox
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchCtrl,
              onChanged: ctrl.search, //search method in scheme
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name or scheme code',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.loading.value) {
                return ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      title: Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
              //   return const Center(child: CircularProgressIndicator());
              if (ctrl.error.value != null)
                return Center(child: Text('Error: ${ctrl.error.value}'));
              final list = ctrl.filtered;
              if (list.isEmpty)
                return const Center(child: Text(constantMessage.NoSchemeFound));

              return ListView.separated(
                //scrolling list
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final s = list[idx];
                  final isFav = favCtrl.favs.any(
                    (e) => e.schemeCode == s.schemeCode,
                  );
                  return FundTile(scheme: s, isFav: isFav);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
