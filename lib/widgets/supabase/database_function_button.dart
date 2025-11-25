import 'package:flutter/material.dart';
import '../../data/services/database_function_service.dart';
import '../../core/extensions/state_extensions.dart';

/// A button widget that calls a PostgreSQL database function (RPC)
///
/// This widget provides a convenient way to invoke database functions
/// with loading states and error handling.
///
/// Example:
/// ```dart
/// DatabaseFunctionButton(
///   functionName: 'get_user_tasks',
///   params: {'user_id': 123},
///   onSuccess: (result) => print('Success: $result'),
///   onError: (error) => print('Error: $error'),
///   child: Text('Get Tasks'),
/// )
/// ```
class DatabaseFunctionButton extends StatefulWidget {
  /// The name of the database function to call
  final String functionName;

  /// Optional parameters to pass to the function
  final Map<String, dynamic>? params;

  /// The child widget to display (typically a Text or Icon)
  final Widget child;

  /// Callback when the function call succeeds
  final void Function(dynamic result)? onSuccess;

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

  /// Return type: 'auto', 'list', 'map', or 'value'
  final String returnType;

  const DatabaseFunctionButton({
    super.key,
    required this.functionName,
    required this.child,
    this.params,
    this.onSuccess,
    this.onError,
    this.loadingWidget,
    this.showLoading = true,
    this.style,
    this.enabled = true,
    this.returnType = 'auto',
  });

  @override
  State<DatabaseFunctionButton> createState() => _DatabaseFunctionButtonState();
}

class _DatabaseFunctionButtonState extends State<DatabaseFunctionButton>
    with SafeStateMixin {
  bool _isLoading = false;

  Future<void> _invokeFunction() async {
    if (!widget.enabled || _isLoading) return;

    safeSetState(() {
      _isLoading = true;
    });

    try {
      dynamic result;

      switch (widget.returnType) {
        case 'list':
          result = await DatabaseFunctionService.callAsList(
            widget.functionName,
            params: widget.params,
          );
          break;
        case 'map':
          result = await DatabaseFunctionService.callAsMap(
            widget.functionName,
            params: widget.params,
          );
          break;
        case 'value':
          result = await DatabaseFunctionService.callAsValue(
            widget.functionName,
            params: widget.params,
          );
          break;
        case 'auto':
        default:
          result = await DatabaseFunctionService.call(
            widget.functionName,
            params: widget.params,
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

/// A widget that displays the result of a database function call
///
/// Example:
/// ```dart
/// DatabaseFunctionResult(
///   functionName: 'get_user_tasks',
///   params: {'user_id': 123},
///   returnType: 'list',
///   builder: (context, result, isLoading, error) {
///     if (isLoading) return CircularProgressIndicator();
///     if (error != null) return Text('Error: $error');
///     return ListView.builder(
///       itemCount: (result as List).length,
///       itemBuilder: (context, index) => Text(result[index]['title']),
///     );
///   },
/// )
/// ```
class DatabaseFunctionResult extends StatefulWidget {
  /// The name of the database function to call
  final String functionName;

  /// Optional parameters to pass to the function
  final Map<String, dynamic>? params;

  /// Return type: 'auto', 'list', 'map', or 'value'
  final String returnType;

  /// Builder function for the result
  final Widget Function(
    BuildContext context,
    dynamic result,
    bool isLoading,
    String? error,
  )
  builder;

  /// Whether to auto-invoke on init
  final bool autoInvoke;

  const DatabaseFunctionResult({
    super.key,
    required this.functionName,
    required this.builder,
    this.params,
    this.returnType = 'auto',
    this.autoInvoke = true,
  });

  @override
  State<DatabaseFunctionResult> createState() => _DatabaseFunctionResultState();
}

class _DatabaseFunctionResultState extends State<DatabaseFunctionResult>
    with SafeStateMixin {
  dynamic _result;
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
      dynamic result;

      switch (widget.returnType) {
        case 'list':
          result = await DatabaseFunctionService.callAsList(
            widget.functionName,
            params: widget.params,
          );
          break;
        case 'map':
          result = await DatabaseFunctionService.callAsMap(
            widget.functionName,
            params: widget.params,
          );
          break;
        case 'value':
          result = await DatabaseFunctionService.callAsValue(
            widget.functionName,
            params: widget.params,
          );
          break;
        case 'auto':
        default:
          result = await DatabaseFunctionService.call(
            widget.functionName,
            params: widget.params,
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
