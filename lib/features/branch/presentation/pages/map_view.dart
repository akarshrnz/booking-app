import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/core/app_image.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:latlong2/latlong.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';

/// Screen to display coworking spaces on a map with markers
class MapScreen extends StatefulWidget {
  final List<Branch> branches;
  static const routeName = '/map';

  const MapScreen({
    Key? key,
    required this.branches,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition; // User's current location
  bool _loading = true; // Loading state for current location
  final MapController _mapController = MapController();
  List<Marker> _markers = []; // Markers for branches
  Branch? _selectedBranch; // Currently selected branch

  @override
  void initState() {
    super.initState();
    // Get user location and then load branch markers
    _getCurrentLocation().then((_) => _loadBranchMarkers());
  }

  /// Get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Default location if location services are disabled
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setDefaultLocation();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } catch (e) {
      _setDefaultLocation();
    }
  }

  /// Sets a default location (Kochi) when location cannot be fetched
  void _setDefaultLocation() {
    setState(() {
      _currentPosition = const LatLng(9.9312, 76.2673);
      _loading = false;
    });
  }

  /// Load markers for all branches on the map
  void _loadBranchMarkers() {
    setState(() {
      _markers = widget.branches.map((branch) {
        return Marker(
          width: 60,
          height: 60,
          point: LatLng(branch.latitude.toDouble(), branch.longitude.toDouble()),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedBranch = branch;
              });
              _showBranchDetails(branch);
            },
            child: AnimatedScale(
              scale: _selectedBranch == branch ? 1.3 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.location_pin,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
          ),
        );
      }).toList();
    });
  }

  /// Show bottom sheet with branch details
  void _showBranchDetails(Branch branch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Branch name
            Row(
              children: [
                Image.asset(AppImage.shopColor),
                const SizedBox(width: 8),
                Text(
                  branch.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Branch address
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(branch.address)),
              ],
            ),
            const SizedBox(height: 12),
            // Price per hour
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text('₹${branch.pricePerHour} per hour', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            // View details button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    AppConstants.branchDetailRoute,
                    arguments: branch.id,
                  );
                },
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Find Coworking Spaces',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _selectedBranch = null);
              _loadBranchMarkers();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Finding your location...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : Stack(
              children: [
                // Flutter map with markers
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition ?? const LatLng(9.9312, 76.2673),
                    initialZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(markers: _markers),
                    // User's current location
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition!,
                            child: const Icon(
                              Icons.person_pin_circle,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Selected branch info overlay
                if (_selectedBranch != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => _showBranchDetails(_selectedBranch!),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 30),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedBranch!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    _selectedBranch!.address,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      // Floating action buttons for centering location and zooming to all markers
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Center on current location
          FloatingActionButton(
            heroTag: 'center_location',
            onPressed: () {
              if (_currentPosition != null) _mapController.move(_currentPosition!, 14);
            },
            backgroundColor: Colors.white,
            child:  Icon(Icons.my_location, color: primaryColor),
          ),
          const SizedBox(height: 16),
          // Zoom to fit all markers
          FloatingActionButton(
            heroTag: 'view_all',
            onPressed: _zoomToFitMarkers,
            backgroundColor: Colors.white,
            child:  Icon(Icons.zoom_out_map, color: primaryColor),
          ),
        ],
      ),
    );
  }

  /// Zooms the map to fit all branch markers
  void _zoomToFitMarkers() {
    if (_markers.isEmpty) return;

    double minLat = _markers.first.point.latitude;
    double maxLat = _markers.first.point.latitude;
    double minLng = _markers.first.point.longitude;
    double maxLng = _markers.first.point.longitude;

    for (var marker in _markers) {
      minLat = marker.point.latitude < minLat ? marker.point.latitude : minLat;
      maxLat = marker.point.latitude > maxLat ? marker.point.latitude : maxLat;
      minLng = marker.point.longitude < minLng ? marker.point.longitude : minLng;
      maxLng = marker.point.longitude > maxLng ? marker.point.longitude : maxLng;
    }

    final bounds = LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
    _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
  }
}
