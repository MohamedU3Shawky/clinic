import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../../utils/price_widget.dart';
import '../../home/model/dashboard_res_model.dart';

class AppliedTaxListBottomSheet extends StatelessWidget {
  final List<TaxPercentage> taxes;
  final num subTotal;

  const AppliedTaxListBottomSheet({super.key, required this.taxes, required this.subTotal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(locale.value.appliedTaxes, style: boldTextStyle(size: 14)).paddingSymmetric(horizontal: 16),
          8.height,
          AnimatedListView(
            itemCount: taxes.length,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            listAnimationType: ListAnimationType.FadeIn,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              TaxPercentage data = taxes[index];

              if (data.type == TaxType.PERCENT) {
                data.totalCalculatedValue = subTotal * data.value.validate() / 100;
              } else {
                data.totalCalculatedValue = data.value.validate();
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    data.type == TaxType.PERCENT
                        ? Row(
                            children: [
                              Text(data.title.validate(), style: primaryTextStyle()),
                              4.width,
                              Text("(${data.value.validate()}%)", style: primaryTextStyle(color: context.primaryColor)),
                            ],
                          ).expand()
                        : Text(data.title.validate(), style: primaryTextStyle()).expand(),
                    PriceWidget(price: data.totalCalculatedValue.validate()),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
