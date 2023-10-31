import "package:app_vida_longa/core/helpers/we_exception_helper.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/shared/widgets/custom_hover_icon_button.dart";
import "package:app_vida_longa/src/bloc/app_wrap_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:tuple/tuple.dart";

class CustomAppSnackBarModal extends StatefulWidget {
  const CustomAppSnackBarModal({super.key});

  @override
  State<CustomAppSnackBarModal> createState() => _CustomAppSnackBarModalState();
}

class _CustomAppSnackBarModalState extends State<CustomAppSnackBarModal> {
  OverlayEntry? entry;
  late List<Tuple2<ResponseStatusModel, bool>> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppWrapBloc, AppWrapState>(
        buildWhen: (previous, current) {
      return previous.snackBarResponse != current.snackBarResponse;
    }, builder: (context, state) {
      handleNewNotification(
          state.snackBarResponse, state.duration, state.canClose);
      return const SizedBox.shrink();
    });
  }

  void handleNewNotification(
    ResponseStatusModel? response,
    int duration,
    bool canClose,
  ) {
    Future.delayed(Duration.zero, () {
      if (response == null) {
        return;
      }

      if (notifications
          .any((element) => element.item1.hashCode == response.hashCode)) {
        return;
      }

      final Tuple2<ResponseStatusModel, bool> notification =
          Tuple2(response, canClose);

      notifications.insert(0, notification);
      showOverlay();
      notificationExpired(
        notification,
        duration,
      );
    });
  }

  void showOverlay() {
    if (!mounted) {
      return;
    }

    final OverlayState overlayState = Overlay.of(context);

    removeOverlay();

    if (!hasNotifications()) {
      return;
    }

    entry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.only(top: 56),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: DefaultTextStyle(
                    // style: AppTextStyles.black16w500,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_handleNotifications()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(entry!);
  }

  Widget _handleNotifications() {
    final List<Widget> widgets = [];

    for (final notification in notifications) {
      widgets.add(_buildNotification(notification));
    }

    return Column(
      children: widgets,
    );
  }

  Widget _buildNotification(Tuple2<ResponseStatusModel, bool> data) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Align(
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  WeExceptionHelper.getStatusColorFromStatus(data.item1.status),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    WeExceptionHelper.getSnackBarIconDataFromStatus(
                        data.item1.status),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      WeExceptionHelper.getMessage(data.item1),
                      // style: AppTextStyles.black16w500,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  data.item2
                      ? CustomHoverIconButton(
                          image: "close",
                          onTap: () {
                            handleRemoveNotification(data);
                          },
                          forceSize: 24,
                          iconPadding: const EdgeInsets.all(8),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void notificationExpired(
    Tuple2<ResponseStatusModel, bool> notification,
    int duration,
  ) {
    Future.delayed(Duration(seconds: duration), () {
      notifications.remove(notification);
      showOverlay();
    });
  }

  void handleRemoveNotification(
    Tuple2<ResponseStatusModel, bool> notification,
  ) {
    if (!hasNotifications()) {
      removeOverlay();
      return;
    }
    notifications.remove(notification);
    showOverlay();
  }

  bool hasNotifications() {
    return notifications.isNotEmpty;
  }

  void handleOverlay() {
    if (!hasNotifications()) {
      removeOverlay();
    }
  }

  void removeOverlay() {
    if (entry != null) {
      entry!.remove();
    }
    entry = null;
  }
}
