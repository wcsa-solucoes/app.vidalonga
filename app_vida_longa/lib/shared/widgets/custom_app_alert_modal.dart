// import "package:app_vida_longa/core/helpers/icon_helper.dart";
import "package:app_vida_longa/core/helpers/we_exception_helper.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/shared/widgets/custom_hover_icon_button.dart";
import "package:app_vida_longa/src/bloc/app_wrap_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class CustomAppAlertModal extends StatefulWidget {
  const CustomAppAlertModal({super.key});

  @override
  State<CustomAppAlertModal> createState() => _CustomAppAlertModalState();
}

class _CustomAppAlertModalState extends State<CustomAppAlertModal> {
  OverlayEntry? entry;
  late List<ResponseStatusModel> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppWrapBloc, AppWrapState>(
      buildWhen: (previous, current) {
        return previous.alertResponse != current.alertResponse;
      },
      builder: (context, state) {
        handleNewNotification(state.alertResponse, state.duration);
        return const SizedBox.shrink();
      },
    );
  }

  void handleNewNotification(ResponseStatusModel? response, int duration) {
    Future.delayed(Duration.zero, () {
      if (response == null) {
        return;
      }
      if (notifications
          .any((element) => element.hashCode == response.hashCode)) {
        return;
      }

      notifications.insert(0, response);
      showOverlay();
      notificationExpired(response, duration);
    });
  }

  void showOverlay() {
    final OverlayState overlayState = Overlay.of(context);

    removeOverlay();

    if (!hasNotifications()) {
      return;
    }

    entry = OverlayEntry(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 450),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [_handleNotifications()],
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

  Widget _buildNotification(ResponseStatusModel response) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 48,
          width: 350,
          decoration: BoxDecoration(
            color: WeExceptionHelper.getStatusColorFromStatus(response.status),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _buildIcon(response.status),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    WeExceptionHelper.getMessage(response),
                    // style: AppTextStyles.white14w400,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                  ),
                ),
                CustomHoverIconButton(
                  image: "close",
                  iconColor: Colors.white,
                  onTap: () {
                    handleRemoveNotification(response);
                  },
                  forceSize: 16,
                  iconPadding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildIcon(ResponseStatusEnum status) {
  //   return const Icon(Icons.close);
  // }

  void notificationExpired(ResponseStatusModel response, int duration) {
    Future.delayed(Duration(seconds: duration), () {
      notifications.remove(response);
      showOverlay();
    });
  }

  void handleRemoveNotification(ResponseStatusModel response) {
    if (!hasNotifications()) {
      removeOverlay();
      return;
    }
    notifications.remove(response);
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
