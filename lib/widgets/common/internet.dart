import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key, required this.child});

  final Widget child;

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker.instance;
  StreamSubscription<dynamic>? _connectivitySub;
  StreamSubscription<InternetConnectionStatus>? _internetSub;
  bool? _isOnline;
  bool _listenersAttached = false;

  @override
  void initState() {
    super.initState();
    _bootstrapStatus();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _internetSub?.cancel();
    super.dispose();
  }

  Future<void> _bootstrapStatus() async {
    final initialNetwork = await _connectivity.checkConnectivity();
    if (!_hasConnection(_toList(initialNetwork))) {
      _updateStatus(false);
    } else {
      await _refreshInternetStatus();
    }
    _attachListeners();
  }

  Future<void> _refreshInternetStatus() async {
    final hasInternet = await _connectionChecker.hasConnection;
    _updateStatus(hasInternet);
  }

  void _attachListeners() {
    if (_listenersAttached) return;
    _listenersAttached = true;
    _connectivitySub = _connectivity.onConnectivityChanged.listen((event) {
      final status = _toList(event);
      if (_hasConnection(status)) {
        _refreshInternetStatus();
      } else {
        _updateStatus(false);
      }
    });
    _internetSub = _connectionChecker.onStatusChange.listen((status) {
      _updateStatus(status == InternetConnectionStatus.connected);
    });
  }

  List<ConnectivityResult> _toList(dynamic value) {
    if (value is List<ConnectivityResult>) {
      return value;
    }
    if (value is ConnectivityResult) {
      return [value];
    }
    return const [ConnectivityResult.none];
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  void _updateStatus(bool isOnline) {
    if (!mounted || _isOnline == isOnline) return;
    setState(() => _isOnline = isOnline);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _isOnline != false
                  ? const SizedBox.shrink()
                  : DecoratedBox(
                      key: const ValueKey('offline-banner'),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(blurRadius: 12, color: Colors.black26),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'You are offline',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
