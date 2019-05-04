import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PhotoImage extends StatelessWidget {
  final Key key;
  final BaseCacheManager cacheManager;
  final String imageUrl;
  final ImageWidgetBuilder imageBuilder;
  final Duration fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double width;
  final double height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final Map<String, String> httpHeaders;
  final bool useOldImageOnUrlChange;
  final Color color;
  final BlendMode colorBlendMode;
  final bool circular;
  final bool withBorder;

  PhotoImage({
    this.key,
    @required this.imageUrl,
    this.imageBuilder,
    this.fadeOutDuration: const Duration(milliseconds: 300),
    this.fadeOutCurve: Curves.easeOut,
    this.fadeInDuration: const Duration(milliseconds: 700),
    this.fadeInCurve: Curves.easeIn,
    this.width,
    this.height,
    this.fit,
    this.alignment: Alignment.center,
    this.repeat: ImageRepeat.noRepeat,
    this.matchTextDirection: false,
    this.httpHeaders,
    this.cacheManager,
    this.useOldImageOnUrlChange: false,
    this.color,
    this.colorBlendMode,
    this.circular = true,
    this.withBorder = true,
  }) : super();

  Widget _placeholderBuilder(BuildContext context, String url) {
    return Container(
      child: Icon(Icons.person, color: Color.lerp(Colors.blue, Colors.black, 0.5)),
      width: width,
      height: height,
      padding: EdgeInsets.all(4.0),
    );
  }

  Widget _errorWidgetBuilder(BuildContext context, String url, Object error) {
    return Container(
      child: Icon(Icons.person, color: Color.lerp(Colors.red, Colors.black, 0.5)),
      width: width,
      height: height,
      padding: EdgeInsets.all(4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        child: CachedNetworkImage(
          key: key,
          imageUrl: imageUrl ?? "",
          imageBuilder: imageBuilder,
          placeholder: _placeholderBuilder,
          errorWidget: _errorWidgetBuilder,
          fadeOutDuration: fadeOutDuration,
          fadeOutCurve: fadeOutCurve,
          fadeInDuration: fadeInDuration,
          fadeInCurve: fadeInCurve,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          httpHeaders: httpHeaders,
          cacheManager: cacheManager,
          useOldImageOnUrlChange: useOldImageOnUrlChange,
          color: color,
          colorBlendMode: colorBlendMode,
        ),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.white, Colors.grey, 0.2),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
