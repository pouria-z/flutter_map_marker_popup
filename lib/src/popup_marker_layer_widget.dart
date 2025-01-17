import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart' as flutter_map;
import 'package:flutter_map_marker_popup/src/popup_layer.dart';
import 'package:flutter_map_marker_popup/src/popup_state_wrapper.dart';

import '../flutter_map_marker_popup.dart';
import 'marker_layer.dart';
import 'popup_controller_impl.dart';

class PopupMarkerLayerWidget extends StatefulWidget {
  final PopupMarkerLayerOptions options;

  PopupMarkerLayerWidget({required this.options}) : super(key: options.key);

  @override
  State<PopupMarkerLayerWidget> createState() => _PopupMarkerLayerWidgetState();
}

class _PopupMarkerLayerWidgetState extends State<PopupMarkerLayerWidget> {
  late final PopupController _popupController;

  @override
  void initState() {
    super.initState();
    _popupController = widget.options.popupController == null
        ? PopupControllerImpl()
        : widget.options.popupController as PopupControllerImpl;
  }

  @override
  Widget build(BuildContext context) {
    return PopupStateWrapper(
      builder: (context, popupState) => _layers(
        mapState: flutter_map.MapState.maybeOf(context)!,
        popupState: popupState,
      ),
    );
  }

  Widget _layers({
    required flutter_map.MapState mapState,
    required PopupState popupState,
  }) {
    return Stack(children: [
      MarkerLayer(
        layerOptions: widget.options,
        map: mapState,
        stream: mapState.onMoved,
        popupState: popupState,
        popupController: _popupController,
      ),
      PopupLayer(
        mapState: mapState,
        popupState: popupState,
        stream: mapState.onMoved,
        popupSnap: widget.options.popupSnap,
        popupBuilder: widget.options.popupBuilder,
        popupController: _popupController,
        popupAnimation: widget.options.popupAnimation,
        markerRotate: widget.options.rotate ?? false,
        onPopupEvent: widget.options.onPopupEvent,
      ),
    ]);
  }
}
