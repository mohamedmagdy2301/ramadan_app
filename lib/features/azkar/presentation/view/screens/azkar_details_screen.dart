import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';

import '../../../data/azkar_data.dart';
import '../../../data/azkar_screen_body_item_model_data.dart';
import '../../view_model/notification_manager/azkar_notification_cubit.dart';
import '../../view_model/view_azkar/azkar_details_cubit.dart';
import '../../view_model/view_azkar/azkar_details_state.dart';
import '../widgets/azkar_details_liseview_item_card.dart';
import '../widgets/clear_count_azkar.dart';
import '../widgets/custom_icon_bell.dart';
import '../widgets/custom_notification_settings.dart';

class AzkarDetailsScreen extends StatefulWidget {
  const AzkarDetailsScreen({
    super.key,
    this.selectedTime,
    required this.azkarScreenBodyItemModel,
  });
  final AzkarScreenBodyItemModel azkarScreenBodyItemModel;

  static const String routeName = '/azkarDetailsScreen';
  final TimeOfDay? selectedTime;

  @override
  State<AzkarDetailsScreen> createState() => _AzkarDetailsScreenState();
}

class _AzkarDetailsScreenState extends State<AzkarDetailsScreen> {
  Color colorAppbar = Colors.white;

  @override
  Widget build(BuildContext context) {
    var dataList = azkarData[widget.azkarScreenBodyItemModel.title];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AzkarDetailsCubit(dataList)),
        BlocProvider(
          create:
              (context) =>
                  AzkarNotificationCubit(widget.azkarScreenBodyItemModel),
        ),
      ],
      child: BlocBuilder<AzkarNotificationCubit, AzkarNotificationState>(
        builder: (context, notificationState) {
          final azkarNotificationCubit = context.read<AzkarNotificationCubit>();

          return BlocBuilder<AzkarDetailsCubit, AzkarDetailsState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.azkarScreenBodyItemModel.title,
                    style: StyleText.bold22().copyWith(
                      color: context.onPrimaryColor,
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: context.primaryColor.withAlpha(60),
                  surfaceTintColor: Colors.transparent,
                  actions: [
                    ClearCountAzkarWidget(state: state),
                    IconButton(
                      onPressed: () {
                        azkarNotificationCubit.viewSettingsNotification(
                          context,
                        );
                      },
                      icon: CustomIconBell(
                        azkarNotificationCubit: azkarNotificationCubit,
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    if (azkarNotificationCubit.isViewNotification)
                      CustomNotificationSettings(
                        azkarNotificationCubit: azkarNotificationCubit,
                      ),
                    10.hSpace,
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.dataList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return AzkarDetailsLiseviewItemCard(
                            dataList: state.dataList,
                            index: index,
                            counter: state.counters[index],
                            onCounterChanged: () {
                              context
                                  .read<AzkarDetailsCubit>()
                                  .incrementCounter(index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
