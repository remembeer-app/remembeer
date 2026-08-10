import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:remembeer/common/widget/page_template.dart';

class LocationPage extends StatefulWidget {
  final GeoPoint location;

  const LocationPage({super.key, required this.location});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final point = LatLng(widget.location.latitude, widget.location.longitude);

    return PageTemplate(
      title: const Text('Adjust Location'),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmLocation,
        child: const Icon(Icons.check),
      ),
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: point,
              initialZoom: 16,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                userAgentPackageName: 'com.example.remembeer',
              ),
            ],
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.location_pin, color: Colors.red, size: 48),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLocation() {
    final center = _mapController.camera.center;
    final geoPoint = GeoPoint(center.latitude, center.longitude);
    context.pop(geoPoint);
  }
}
