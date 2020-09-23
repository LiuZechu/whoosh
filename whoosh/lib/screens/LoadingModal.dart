import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/entity/Commons.dart';

class LoadingModal extends StatelessWidget {
  final BuildContext context;

  LoadingModal(this.context);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 380,
        height: 150,
        child: FlareActor(
          Commons.waveFlareActorPath,
          animation: 'scroll',
        ),
      ),
    );
  }

  void dismiss() {
    Navigator.of(context).pop(true);
  }
}