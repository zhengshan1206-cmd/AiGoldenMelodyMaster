import 'dart:async';
import 'dart:io';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import '../../app_common/by_common_utils.dart';
import '../../app_common/event/common_event.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

///ios 支付工具
class IosBuyEngin {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late InAppPurchase _inAppPurchase;
  List<ProductDetails> _products = [];

  int type = 1;

  ///内购的商品对象集合

  late StreamSubscription _iosBuyStreamSubscription;

  bool buyIosProductSuccess = false;

  //初始化购买组件
  void initializeInAppPurchase() {
    /// 初始化in_app_purchase插件
    _inAppPurchase = InAppPurchase.instance;

    ///监听购买的事件
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(
        purchaseDetailsList,
      );
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      error.printError();
      byDebugPrint("===购买失败了");
    });

    _iosBuyStreamSubscription =
        eventBus.on<IosProductBuySuccessEvent>().listen((e) {
      buyIosProductSuccess = true;
    });
  }

  void resumePurchase() {
    _inAppPurchase.restorePurchases();
  }

  /// 加载全部的商品
  Future loadProductDataAndBuy(
    String productId,
    String orderId, {
    int changeType = 1,
  }) async {
    type = changeType;
    EasyLoading.show();
    byDebugPrint("===请求商品id $productId");
    List<String> outProducts = [productId];
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      byDebugPrint("===无法连接到商店");
      return;
    }

    ///开始购买
    byDebugPrint("===连接成功-开始查询全部商品");
    List<String> kIds = outProducts;
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(kIds.toSet());
    byDebugPrint("===商品获取结果${response.productDetails}");
    if (response.notFoundIDs.isNotEmpty) {
      byDebugPrint("===无法找到指定的商品");
      return;
    }

    /// 处理查询到的商品列表
    List<ProductDetails> products = response.productDetails;
    byDebugPrint("====products  ${products.length}");
    if (products.isNotEmpty) {
      ///赋值内购商品集合
      _products = products;
    }
    byDebugPrint("===全部商品加载完成了，可以启动购买了,总共商品数量为：${products.first.title}");
    startPurchase(productId, orderId);
  }

  ///调用此函数以启动购买过程
  void startPurchase(
    String productId,
    String orderId,
  ) async {
    byDebugPrint("===购买的商品id为$productId");
    if (_products.isNotEmpty) {
      try {
        ProductDetails productDetails = _getProduct(productId);
        byDebugPrint("===一切正常，开始购买,信息如下："
            "id:${productDetails.id}"
            "title: ${productDetails.title}  desc:${productDetails.description} "
            "price:${productDetails.price}  currencyCode:${productDetails.currencyCode}  currencySymbol:${productDetails.currencySymbol}");

        await clearPendingPurchases();
        await _inAppPurchase.buyNonConsumable(
            purchaseParam: PurchaseParam(
          productDetails: productDetails,
          // applicationUserName: orderId,
        ));
      } catch (e) {
        Get.log("异常==== ${e.toString()}");
        EasyLoading.dismiss();
        EasyLoading.showToast("购买失败，请重新购买～");
        byDebugPrint("===购买失败了");
      }
    } else {
      EasyLoading.dismiss();
      EasyLoading.showToast("购买失败，请重新购买～");
      byDebugPrint("===当前没有商品无法调用购买逻辑");
    }
  }

  ///根据产品ID获取产品信息
  ProductDetails _getProduct(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  /// 内购的购买更新监听
  void _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (PurchaseDetails purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        /// 等待支付完成
        _handlePending();
      } else if (purchase.status == PurchaseStatus.canceled) {
        /// 取消支付
        _handleCancel(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        /// 购买失败
        _handleError(purchase.error);
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        ///todo 完成购买, 到服务器验证
        if (Platform.isAndroid) {
          // var googleDetail = purchase as GooglePlayPurchaseDetails;
          // checkAndroidPayInfo(googleDetail);
        } else if (Platform.isIOS) {
          var appstoreDetail = purchase as AppStorePurchaseDetails;
          if (purchase.status == PurchaseStatus.purchased) {
            await _inAppPurchase.completePurchase(appstoreDetail);

            Get.log(
                "当前的支付状态=>${purchase.status}  支付交易凭证==> ${appstoreDetail.verificationData.serverVerificationData}");
            eventBus.fire(QueryIosOrderEvent(
                type: type,
                serverVerificationData:
                    appstoreDetail.verificationData.serverVerificationData));
            return;
          }
          EasyLoading.dismiss();
          await checkApplePayInfo(appstoreDetail);
        }
      }
    }
  }

  /// 购买失败
  void _handleError(IAPError? iapError) {
    EasyLoading.dismiss();
    byDebugPrint("===购买失败");
  }

  /// 等待支付
  void _handlePending() {
    EasyLoading.show();
    byDebugPrint("===等待支付===");
  }

  /// 取消支付
  void _handleCancel(PurchaseDetails purchase) {
    EasyLoading.dismiss();
    byDebugPrint("===取消支付===");
    _inAppPurchase.completePurchase(purchase);
  }

  /// Android支付成功的校验
  // void checkAndroidPayInfo(GooglePlayPurchaseDetails googleDetail) async {
  //   _inAppPurchase.completePurchase(googleDetail);
  //    print("安卓支付交易ID为" + googleDetail.purchaseID);
  //    print("安卓支付验证收据为" + googleDetail.verificationData.serverVerificationData);
  // }

  /// Apple支付成功的校验
  checkApplePayInfo(AppStorePurchaseDetails appstoreDetail) async {
    byDebugPrint(
        "serverVerificationData===> ${appstoreDetail.verificationData.serverVerificationData}"
        "source===>${appstoreDetail.verificationData.source}"
        "localVerificationData====>${appstoreDetail.verificationData.localVerificationData}"
        "");
    SpUtil.putString("ios_last_server_verification",
        appstoreDetail.verificationData.serverVerificationData);
    if (buyIosProductSuccess) {
      await _inAppPurchase.completePurchase(appstoreDetail);
    }
    byDebugPrint("===Apple支付交易ID为${appstoreDetail.purchaseID}");
    byDebugPrint(
        "===Apple支付验证收据为${appstoreDetail.verificationData.serverVerificationData}");
  }

  void onClose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }

  ///清除其他交易记录
  Future<void> clearPendingPurchases() async {
    try {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final transaction in transactions) {
        try {
          await SKPaymentQueueWrapper().finishTransaction(transaction);
        } catch (e) {
          debugPrint("Error clearing pending purchases::in::loop");
          debugPrint(e.toString());
          rethrow;
        }
      }
    } catch (e) {
      debugPrint("Error clearing pending purchases");
      debugPrint(e.toString());
      rethrow;
    }
  }
}

///查询苹果订单状态事件
class QueryIosOrderEvent {
  final String serverVerificationData;

  ///1 订阅 2音符值
  final int type;
  const QueryIosOrderEvent({
    required this.serverVerificationData,
    this.type = 1,
  });
}

class IosProductBuySuccessEvent {
  const IosProductBuySuccessEvent();
}
