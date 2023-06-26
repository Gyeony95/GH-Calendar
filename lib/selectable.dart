import 'package:flutter/widgets.dart';

typedef ElementUpdateCallback = void Function(SelectableElement);

class Selectable extends ProxyWidget {
  const Selectable({
    Key? key,
    required this.dateTime,
    required this.onMountElement,
    required this.onUnmountElement,
    required Widget child,
  }) : super(key: key, child: child);

  final DateTime dateTime;

  final ElementUpdateCallback onMountElement;

  final ElementUpdateCallback onUnmountElement;

  @override
  SelectableElement createElement() => SelectableElement(this);
}

class SelectableElement extends ProxyElement {
  SelectableElement(Selectable widget) : super(widget);

  @override
  Selectable get widget => super.widget as Selectable;

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    widget.onMountElement.call(this);
  }

  @override
  void unmount() {
    widget.onUnmountElement.call(this);
    super.unmount();
  }

  bool containsOffset(RenderObject? ancestor, Offset offset) {
    final box = renderObject as RenderBox;
    final rect = box.localToGlobal(Offset.zero, ancestor: ancestor) & box.size;
    return rect.contains(offset);
  }

  @override
  void notifyClients(ProxyWidget oldWidget) {}
}
