import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import '../../../controllers/market_controller.dart';

class MarketPage extends GetView<MarketController> {
  const MarketPage({super.key});

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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CupertinoSlidingSegmentedControl(
                      groupValue: c.groupValue,
                      children: {
                        0: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Öne Çıkar",
                            style: TextStyle(
                              color: ColorManager.instance.mor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        1: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Premium Ol",
                            style: TextStyle(
                              color: ColorManager.instance.sari,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      },
                      onValueChanged: (i) {
                        c.groupValue = i!;
                        c.pageController.jumpToPage(i);

                        c.update();
                      },
                    ),
                  ),
                  Padding(
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
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: c.groupValue == 0 ? c.boostDetails.length : c.premiumDetails.length,
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
                                      color: c.groupValue == 0 ? ColorManager.instance.mor : ColorManager.instance.sari,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      c.groupValue == 0 ? c.boostDetails[index] : c.premiumDetails[index],
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
                  ExpandablePageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: c.pageController,
                    children: [
                      ListView.builder(
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
                      ),
                      ListView.builder(
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
                      ),
                    ],
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
