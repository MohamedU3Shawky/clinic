import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../../utils/price_widget.dart';
import '../../home/model/dashboard_res_model.dart';

class AppoitmentDetailAppliedTaxListBottomSheet extends StatelessWidget {
  final List<TaxPercentage> taxes;

  const AppoitmentDetailAppliedTaxListBottomSheet({super.key, required this.taxes});

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
                              Text("(${data.value}%)", style: primaryTextStyle(color: context.primaryColor)),
                            ],
                          ).expand()
                        : Text(data.title.validate(), style: primaryTextStyle()).expand(),
                    PriceWidget(price: data.amount),
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
