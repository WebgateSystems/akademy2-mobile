import 'package:academy_2_app/features/modules/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_provider.dart';
import '../features/auth/auth_flow_models.dart';
import '../features/auth/create_account_page.dart';
import '../features/auth/enable_biometric_page.dart';
import '../features/auth/join_group_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/pin_pages.dart';
import '../features/auth/tech_login_page.dart';
import '../features/auth/unlock_page.dart';
import '../features/auth/verify_email_page.dart';
import '../features/auth/verify_phone_page.dart';
import '../features/auth/wait_approval_page.dart';
import '../features/home/home_shell.dart';
import '../features/join/join_page.dart';
import '../features/modules/content_pages.dart';
import '../features/modules/module_page.dart';
import '../features/modules/modules_page.dart';
import '../features/profile/profile_page.dart';
import '../features/splash/splash_page.dart';
import '../features/videos/add_video_page.dart';

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthChangeNotifier(ref);

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          redirect: state.uri.queryParameters['redirect'],
        ),
      ),
      GoRoute(
        path: '/tech-login',
        builder: (context, state) => const TechLoginPage(),
      ),
      GoRoute(
        path: '/login-pin',
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is LoginPinArgs
              ? extra
              : LoginPinArgs(
                  phone: state.uri.queryParameters['phone'] ?? '',
                  redirect: state.uri.queryParameters['redirect'],
                );
          return LoginPinPage(args: args);
        },
      ),
      GoRoute(
        path: '/unlock',
        builder: (context, state) => UnlockPage(
          redirect: state.uri.queryParameters['redirect'],
        ),
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => const CreateAccountPage(),
      ),
      GoRoute(
        path: '/verify-phone',
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is VerifyPhoneArgs
              ? extra
              : const VerifyPhoneArgs(
                  phone: '+000000000',
                  email: 'user@example.com',
                  flowId: '',
                );
          return VerifyPhonePage(args: args);
        },
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is VerifyEmailArgs
              ? extra
              : const VerifyEmailArgs(email: 'user@example.com', flowId: '');
          return VerifyEmailPage(args: args);
        },
      ),
      GoRoute(
        path: '/join-group',
        builder: (context, state) => const JoinGroupPage(),
      ),
      GoRoute(
        path: '/wait-approval',
        builder: (context, state) => const WaitApprovalPage(),
      ),
      GoRoute(
        path: '/create-pin',
        builder: (context, state) {
          final flowId = state.extra is String ? state.extra as String : '';
          return CreatePinPage(flowId: flowId);
        },
      ),
      GoRoute(
        path: '/confirm-pin',
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is ConfirmPinArgs
              ? extra
              : const ConfirmPinArgs(pin: '0000', flowId: '');
          return ConfirmPinPage(args: args);
        },
      ),
      GoRoute(
        path: '/enable-biometric',
        builder: (context, state) => const EnableBiometricPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeShell()),
      GoRoute(
        path: '/join/:token',
        builder: (context, state) =>
            JoinPage(token: state.pathParameters['token'] ?? ''),
      ),
      GoRoute(
        path: '/subject/:id',
        builder: (context, state) =>
            ModulesPage(subjectId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/module/:id',
        builder: (context, state) =>
            ModulePage(moduleId: state.pathParameters['id'] ?? ''),
        routes: [
          GoRoute(
            path: 'video',
            builder: (context, state) =>
                VideoPage(moduleId: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(
            path: 'infographic',
            builder: (context, state) =>
                InfographicPage(moduleId: state.pathParameters['id'] ?? ''),
          ),
          GoRoute(
            path: 'quiz',
            builder: (context, state) =>
                QuizPage(moduleId: state.pathParameters['id'] ?? ''),
          ),
        ],
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (context, state) {
          final extra = state.extra;
          final args = extra is QuizResultArgs
              ? extra
              : const QuizResultArgs(score: 0, totalPoints: 0);
          return ResultPage(args: args);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/videos/add',
        builder: (context, state) => const AddVideoPage(),
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;
      final loggingIn = loc == '/login';
      final onLoginPin = loc == '/login-pin';
      final onUnlock = loc == '/unlock';
      final onTechLogin = loc == '/tech-login';
      final onSplash = loc == '/splash';
      final onCreateAccount = loc == '/create-account';
      final onVerifyPhone = loc == '/verify-phone';
      final onVerifyEmail = loc == '/verify-email';
      final onJoinGroup = loc == '/join-group';
      final onWaitApproval = loc == '/wait-approval';
      final onCreatePin = loc == '/create-pin';
      final onConfirmPin = loc == '/confirm-pin';
      final onEnableBiometric = loc == '/enable-biometric';
      final finishingOnboarding =
          onCreatePin || onConfirmPin || onEnableBiometric;
      final isJoinDeepLink = loc.startsWith('/join');
      if (auth.isLoading) return null;

      final onboarding = {
        onSplash,
        loggingIn,
        onLoginPin,
        onUnlock,
        onTechLogin,
        onCreateAccount,
        onVerifyPhone,
        onVerifyEmail,
        onJoinGroup,
        onWaitApproval,
        onCreatePin,
        onConfirmPin,
        onEnableBiometric,
      }.contains(true);

      if (!auth.isAuthenticated) {
        if (isJoinDeepLink) return '/join-group';
        if (onUnlock) return '/login';
        if (!onboarding) return '/login';
        return null;
      }

      final needsUnlock = auth.isAuthenticated && !auth.isUnlocked;
      if (needsUnlock && !onUnlock) {
        final redirectTo = loc == '/splash' ? '/home' : state.uri.toString();
        return Uri(
          path: '/unlock',
          queryParameters: {'redirect': redirectTo},
        ).toString();
      }

      if (auth.needsSchoolBinding &&
          !onJoinGroup &&
          !onWaitApproval &&
          !finishingOnboarding) {
        return '/join-group';
      }

      if (auth.isAuthenticated &&
          onboarding &&
          !onUnlock &&
          !onJoinGroup &&
          !onWaitApproval &&
          !finishingOnboarding) {
        return '/home';
      }

      if (isJoinDeepLink && !auth.isAuthenticated) {
        return '/join-group';
      }

      return null;
    },
  );

  ref.onDispose(() => refresh.dispose());
  return router;
});
