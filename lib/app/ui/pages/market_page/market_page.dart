import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  ListView.builder(
                    itemCount: c.subItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          c.purchase(c.subItems[index]);
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        c.subItems[index].title ?? "",
                                        style: TextStyle(
                                          color: ColorManager.instance.mor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    c.subItems[index].localizedPrice ?? "",
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
                    itemCount: c.items.length,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          c.purchase(c.items[index]);
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
                                        c.items[index].title ?? "",
                                        style: TextStyle(
                                          color: ColorManager.instance.mor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    c.items[index].introductoryPrice ?? "",
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
