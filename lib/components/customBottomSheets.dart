import 'package:flutter/material.dart';

class CustomBottomSheets {
  Future showCustomBottomSheet(Size size, Widget child, BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            maxChildSize: 1.0,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter insideState) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: child,
                );
              });
            },
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  Future showDynamicCustomBottomSheet(
      Size size, Widget child, BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter insideState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: child,
          );
        });
      },
    );
  }
}
