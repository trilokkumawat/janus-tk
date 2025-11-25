// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:janus/core/constants/routes.dart';
// import 'package:janus/core/constants/appcolor.dart';
// import 'package:janus/data/controller/login_controller.dart';
// import 'package:janus/data/controller/auth_state_provider.dart';

// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthAndRedirect();
//   }

//   void _checkAuthAndRedirect() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       final authState = ref.read(authStateProvider);
//       if (authState.isAuthenticated) {
//         context.go(AppRoutes.appState);
//       }
//     });
//   }

//   Future<void> _handleRegister() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final success = await ref.read(loginControllerProvider.notifier).signUp();

//     if (mounted && success) {
//       context.go(AppRoutes.appState);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authStateProvider);
//     final registerState = ref.watch(loginControllerProvider);
//     final registerController = ref.read(loginControllerProvider.notifier);

//     if (authState.isAuthenticated) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           context.go(AppRoutes.appState);
//         }
//       });
//     }

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 40),
//                 Text(
//                   'Create Account',
//                   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.purple,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Sign up to get started',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: AppColors.secondaryText,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 48),

//                 TextFormField(
//                   controller: registerState.emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   textInputAction: TextInputAction.next,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     hintText: 'Enter your email',
//                     prefixIcon: const Icon(Icons.email_outlined),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Theme.of(context).brightness == Brightness.dark
//                         ? AppColors.darkCard
//                         : AppColors.lightCard,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: registerState.passwordController,
//                   obscureText: registerState.obscurePassword,
//                   textInputAction: TextInputAction.next,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     hintText: 'Enter your password',
//                     prefixIcon: const Icon(Icons.lock_outlined),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         registerState.obscurePassword
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off_outlined,
//                       ),
//                       onPressed: registerController.togglePasswordVisibility,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Theme.of(context).brightness == Brightness.dark
//                         ? AppColors.darkCard
//                         : AppColors.lightCard,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 TextFormField(
//                   controller: registerState.passwordController,
//                   obscureText: registerState.obscurePassword,
//                   textInputAction: TextInputAction.done,
//                   decoration: InputDecoration(
//                     labelText: 'Confirm Password',
//                     hintText: 'Re-enter your password',
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         registerState.obscurePassword
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off_outlined,
//                       ),
//                       onPressed: registerController.togglePasswordVisibility,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Theme.of(context).brightness == Brightness.dark
//                         ? AppColors.darkCard
//                         : AppColors.lightCard,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != registerState.passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),

//                 if (registerState.errorMessage != null)
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: AppColors.highPriority.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: AppColors.highPriority.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.error_outline,
//                           color: AppColors.highPriority,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             registerState.errorMessage!,
//                             style: const TextStyle(
//                               color: AppColors.highPriority,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: AppColors.primaryGradient,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: registerState.isLoading ? null : _handleRegister,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: registerState.isLoading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         : const Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already have an account? ",
//                       style: TextStyle(color: AppColors.secondaryText),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.push(AppRoutes.login);
//                       },
//                       child: Text(
//                         'Sign In',
//                         style: TextStyle(
//                           color: AppColors.purple,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
