import 'package:flutter/material.dart';
import '../../data/services/edge_function_service.dart';
import '../../core/extensions/state_extensions.dart';

/// A button widget that calls a Supabase Edge Function
///
/// This widget provides a convenient way to invoke Edge Functions
/// with loading states and error handling.
///
/// Example:
/// ```dart
/// EdgeFunctionButton(
///   functionName: 'send-email',
///   body: {'to': 'user@example.com', 'subject': 'Hello'},
///   onSuccess: (result) => print('Success: $result'),
///   onError: (error) => print('Error: $error'),
///   child: Text('Send Email'),
/// )
/// ```
class EdgeFunctionButton extends StatefulWidget {
  /// The name of the Edge Function to invoke
  final String functionName;

  /// Optional request body
  final Map<String, dynamic>? body;

  /// Optional custom headers
  final Map<String, String>? headers;

  /// HTTP method (default: POST)
  final String method;

  /// The child widget to display (typically a Text or Icon)
  final Widget child;

  /// Callback when the function call succeeds
  final void Function(Map<String, dynamic> result)? onSuccess;

  /// Callback when the function call fails
  final void Function(String error)? onError;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Whether to show a loading indicator
  final bool showLoading;

  /// Button style
  final ButtonStyle? style;

  /// Whether the button is enabled
  final bool enabled;

  const EdgeFunctionButton({
    super.key,
    required this.functionName,
    required this.child,
    this.body,
    this.headers,
    this.method = 'POST',
    this.onSuccess,
    this.onError,
    this.loadingWidget,
    this.showLoading = true,
    this.style,
    this.enabled = true,
  });

  @override
  State<EdgeFunctionButton> createState() => _EdgeFunctionButtonState();
}

class _EdgeFunctionButtonState extends State<EdgeFunctionButton>
    with SafeStateMixin {
  bool _isLoading = false;

  Future<void> _invokeFunction() async {
    if (!widget.enabled || _isLoading) return;

    safeSetState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result;

      switch (widget.method.toUpperCase()) {
        case 'GET':
          result = await EdgeFunctionService.get(
            widget.functionName,
            queryParams: widget.body,
            headers: widget.headers,
          );
          break;
        case 'PUT':
          result = await EdgeFunctionService.put(
            widget.functionName,
            body: widget.body ?? {},
            headers: widget.headers,
          );
          break;
        case 'DELETE':
          result = await EdgeFunctionService.delete(
            widget.functionName,
            body: widget.body,
            headers: widget.headers,
          );
          break;
        case 'POST':
        default:
          result = await EdgeFunctionService.post(
            widget.functionName,
            body: widget.body ?? {},
            headers: widget.headers,
          );
          break;
      }

      if (mounted) {
        widget.onSuccess?.call(result);
      }
    } catch (e) {
      if (mounted) {
        widget.onError?.call(e.toString());
      }
    } finally {
      safeSetState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.enabled && !_isLoading ? _invokeFunction : null,
      style: widget.style,
      child: _isLoading && widget.showLoading
          ? (widget.loadingWidget ??
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ))
          : widget.child,
    );
  }
}

/// A widget that displays the result of an Edge Function call
///
/// Example:
/// ```dart
/// EdgeFunctionResult(
///   functionName: 'get-data',
///   body: {'id': 123},
///   builder: (context, result, isLoading, error) {
///     if (isLoading) return CircularProgressIndicator();
///     if (error != null) return Text('Error: $error');
///     return Text('Result: ${result['data']}');
///   },
/// )
/// ```
class EdgeFunctionResult extends StatefulWidget {
  /// The name of the Edge Function to invoke
  final String functionName;

  /// Optional request body
  final Map<String, dynamic>? body;

  /// Optional custom headers
  final Map<String, String>? headers;

  /// HTTP method (default: POST)
  final String method;

  /// Builder function for the result
  final Widget Function(
    BuildContext context,
    Map<String, dynamic>? result,
    bool isLoading,
    String? error,
  )
  builder;

  /// Whether to auto-invoke on init
  final bool autoInvoke;

  const EdgeFunctionResult({
    super.key,
    required this.functionName,
    required this.builder,
    this.body,
    this.headers,
    this.method = 'POST',
    this.autoInvoke = true,
  });

  @override
  State<EdgeFunctionResult> createState() => _EdgeFunctionResultState();
}

class _EdgeFunctionResultState extends State<EdgeFunctionResult>
    with SafeStateMixin {
  Map<String, dynamic>? _result;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.autoInvoke) {
      _invokeFunction();
    }
  }

  Future<void> _invokeFunction() async {
    safeSetState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      Map<String, dynamic> result;

      switch (widget.method.toUpperCase()) {
        case 'GET':
          result = await EdgeFunctionService.get(
            widget.functionName,
            queryParams: widget.body,
            headers: widget.headers,
          );
          break;
        case 'PUT':
          result = await EdgeFunctionService.put(
            widget.functionName,
            body: widget.body ?? {},
            headers: widget.headers,
          );
          break;
        case 'DELETE':
          result = await EdgeFunctionService.delete(
            widget.functionName,
            body: widget.body,
            headers: widget.headers,
          );
          break;
        case 'POST':
        default:
          result = await EdgeFunctionService.post(
            widget.functionName,
            body: widget.body ?? {},
            headers: widget.headers,
          );
          break;
      }

      safeSetState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      safeSetState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _result, _isLoading, _error);
  }
}
