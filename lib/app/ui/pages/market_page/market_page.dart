import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import '../../../controllers/market_controller.dart';

class MarketPage extends GetView<MarketController> {
  const MarketPage({required this.type, super.key});
  //1 öne çıkar
  //2 premium
  //3 gold
  final int type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      init: MarketController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: ColorManager.instance.background_gray,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Market',
              style: TextStyle(
                color: ColorManager.instance.mor,
              ),
            ),
            elevation: 1,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  type == 3
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorManager.instance.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: kElevationToShadow[2],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: type == 1 ? c.boostDetails.length : c.premiumDetails.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            "assets/svg/tik.svg",
                                            color: type == 1 ? ColorManager.instance.mor : ColorManager.instance.sari,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            type == 1 ? c.boostDetails[index] : c.premiumDetails[index],
                                            style: TextStyle(
                                              color: ColorManager.instance.softBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                  type == 1
                      ? ListView.builder(
                          itemCount: c.products.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                InAppPurchase.instance.buyNonConsumable(
                                  purchaseParam: PurchaseParam(
                                    productDetails: c.products[index],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorManager.instance.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/startup.png",
                                          height: 32,
                                          width: 32,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              c.products[index].title,
                                              style: TextStyle(
                                                color: ColorManager.instance.mor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          c.products[index].price,
                                          style: TextStyle(
                                            color: ColorManager.instance.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : type == 2
                          ? ListView.builder(
                              itemCount: c.premiums.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    InAppPurchase.instance.buyNonConsumable(
                                      purchaseParam: PurchaseParam(
                                        productDetails: c.premiums[index],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorManager.instance.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/premium.png",
                                              height: 32,
                                              width: 32,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                  c.premiums[index].title,
                                                  style: TextStyle(
                                                    color: ColorManager.instance.sari,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              c.premiums[index].price,
                                              style: TextStyle(
                                                color: ColorManager.instance.sari,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder( 
                              itemCount: c.golds.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    InAppPurchase.instance.buyConsumable(
                                      purchaseParam: PurchaseParam(
                                        productDetails: c.golds[index],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorManager.instance.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/coin.png",
                                              height: 32,
                                              width: 32,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                  c.golds[index].title,
                                                  style: TextStyle(
                                                    color: ColorManager.instance.sari,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              c.golds[index].price,
                                              style: TextStyle(
                                                color: ColorManager.instance.sari,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
