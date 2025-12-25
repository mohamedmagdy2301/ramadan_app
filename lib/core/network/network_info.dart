import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract class for checking network connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();

    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    // Double-check with actual DNS lookup
    try {
      final lookupResult = await InternetAddress.lookup('google.com');
      return lookupResult.isNotEmpty && lookupResult.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((results) async {
      if (results.contains(ConnectivityResult.none)) {
        return false;
      }

      // Verify with DNS lookup
      try {
        final lookupResult = await InternetAddress.lookup('google.com');
        return lookupResult.isNotEmpty && lookupResult.first.rawAddress.isNotEmpty;
      } on SocketException {
        return false;
      }
    });
  }
}
