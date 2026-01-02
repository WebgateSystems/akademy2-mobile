import 'dart:async';
import 'dart:math';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_provider.dart';
import '../shared/parental_gate_dialog.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;
  bool _logoTapped = false;
  bool _navigated = false;
  bool _scatterStarted = false;
  bool _splashCloseVisible = false;
  final GlobalKey _stackKey = GlobalKey();
  late final Map<String, _PartnerLogoConfig> _logoConfigs;
  List<_LogoSnapshot> _logoSnapshots = [];
  Map<String, Rect> _logoTargets = {};
  _PartnerLogoConfig? _activeLogoConfig;
  _PartnerLogoInfo? _activeLogoInfo;
  Size _stackSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _logoConfigs = _buildLogoConfigs();
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goNext() {
    if (_navigated) return;
    _navigated = true;
    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (auth.isAuthenticated) {
      if (!auth.isUnlocked) {
        context.go('/unlock');
        return;
      }
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  Future<void> _onLogoTap(_PartnerLogoConfig config) async {
    final l10n = AppLocalizations.of(context);
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (!mounted || l10n == null || stackBox == null) return;

    final infoMap = _localizedPartnerInfo(l10n);
    final info = infoMap[config.id] ?? _defaultLogoInfo(l10n);
    if (info.isDefault) return;

    _timer?.cancel();

    final snapshots = _captureLogoSnapshots(stackBox);
    if (snapshots.isEmpty) return;

    final targets = _buildTargetRects(
      snapshots: snapshots,
      canvasSize: stackBox.size,
      selectedId: config.id,
      padding: MediaQuery.of(context).padding,
    );

    setState(() {
      _logoTapped = true;
      _scatterStarted = false;
      _logoSnapshots = snapshots;
      _logoTargets = targets;
      _activeLogoConfig = config;
      _activeLogoInfo = info;
      _stackSize = stackBox.size;
      _splashCloseVisible = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _scatterStarted = true);
    });
  }

  Future<void> _onLinkTap(String url) async {
    final approved = await ParentalGateDialog.show(context);
    if (!mounted || !approved) return;

    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.splashLinkOpenError ?? 'Could not open link',
          ),
        ),
      );
    }
  }

  void _closeDetails() {
    _timer?.cancel();
    setState(() {
      _logoTapped = false;
      _scatterStarted = false;
      _logoSnapshots = [];
      _logoTargets = {};
      _activeLogoConfig = null;
      _activeLogoInfo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isTablet = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      backgroundColor: AppColors.blue05,
      body: Stack(
        key: _stackKey,
        children: [
          IgnorePointer(
            ignoring: _logoTapped,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _logoTapped ? 0.0 : 1.0,
              child: _buildMainContent(isTablet),
            ),
          ),
          if (!_logoTapped && _splashCloseVisible)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 48.h, right: 20.w),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/ic_close.png',
                      color: theme.textTheme.bodyMedium?.color,
                      width: 16.r,
                      height: 16.r,
                    ),
                    onPressed: _goNext,
                  ),
                ),
              ),
            ),
          if (_logoTapped && l10n != null && _activeLogoConfig != null)
            _buildLogoOverlay(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              SizedBox(
                height: 24.h,
              ),
              _logoTile(
                _LogoIds.main,
                width: 265.r,
                height: 120.r,
              ),
              const Spacer(),
              isTablet ? _getLogosForTablet() : _getLogosForPhone(),
              SizedBox(
                height: 12.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoOverlay(ThemeData theme, AppLocalizations l10n) {
    final selected = _activeLogoConfig;
    if (selected == null || _activeLogoInfo == null) {
      return const SizedBox.shrink();
    }

    final selectedRect = _logoTargets[selected.id] ??
        _logoSnapshots
            .firstWhere(
              (snap) => snap.config.id == selected.id,
              orElse: () => _LogoSnapshot(config: selected, rect: Rect.zero),
            )
            .rect;

    final safeTop = MediaQuery.of(context).padding.top + 120.h;
    final maxWidth = min(
      _stackSize.width == 0
          ? MediaQuery.sizeOf(context).width
          : _stackSize.width,
      720.w,
    );

    return Stack(
      children: [
        ..._logoSnapshots.map(_buildAnimatedLogo),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_scatterStarted,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              opacity: _scatterStarted ? 1 : 0,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, safeTop, 16.w, 16.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 350),
                      opacity: _scatterStarted ? 1 : 0,
                      child: Center(
                        child: Builder(builder: (context) {
                          final ratio = (selectedRect.width == 0 ||
                                  selectedRect.height == 0)
                              ? 3.0
                              : selectedRect.width / selectedRect.height;
                          final displayWidth = selectedRect.width == 0
                              ? 140.w
                              : min(selectedRect.width, 220.w);
                          final displayHeight =
                              displayWidth / max(ratio, 0.1); // avoid zero

                          return SizedBox(
                            width: displayWidth,
                            height: displayHeight,
                            child: _logoImage(
                              selected.asset,
                              fit: BoxFit.contain,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                          minWidth: 220.w,
                        ),
                        child: _buildPartnerInfoCard(l10n),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 48.h, right: 20.w),
              child: IconButton(
                icon: Image.asset(
                  'assets/images/ic_close.png',
                  color: theme.textTheme.bodyMedium?.color,
                  width: 16.r,
                  height: 16.r,
                ),
                onPressed: _closeDetails,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedLogo(_LogoSnapshot snapshot) {
    final target = _logoTargets[snapshot.config.id] ?? snapshot.rect;
    final destination = _scatterStarted ? target : snapshot.rect;
    final isSelected = _activeLogoConfig?.id == snapshot.config.id;
    final opacity = _scatterStarted ? (isSelected ? 0.0 : 1.0) : 1.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      left: destination.left,
      top: destination.top,
      width: destination.width,
      height: destination.height,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutQuad,
        opacity: opacity,
        child: _logoImage(
          snapshot.config.asset,
          width: destination.width,
          height: destination.height,
        ),
      ),
    );
  }

  Widget _buildPartnerInfoCard(AppLocalizations l10n) {
    final info = _activeLogoInfo!;
    final links = info.links;

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              textAlign: TextAlign.center,
              info.title,
              style: AppTextStyles.h2(context),
            ),
          ),
          SizedBox(height: 24.h),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.description,
                    style: AppTextStyles.b2(context).copyWith(
                      color: AppColors.contentSecondary(context),
                      height: 1.35,
                    ),
                  ),
                  if (links.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    ...links.map(
                      (link) => Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: ActionTextButtonWidget(
                          text: _linkButtonText(link, l10n),
                          onPressed: () => _onLinkTap(link.url),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        l10n.splashLinkGuardHint,
                        style: AppTextStyles.b3(context).copyWith(
                          color: AppColors.contentSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoTile(String id,
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    final config = _logo(id);
    return GestureDetector(
      onTap: () => _onLogoTap(config),
      child: SizedBox(
        key: config.key,
        width: width,
        height: height,
        child: _logoImage(
          config.asset,
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }

  Widget _logoImage(String asset,
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => SizedBox(
        width: width ?? height ?? 80.r,
        height: height ?? 40.r,
      ),
    );
  }

  Column _getLogosForPhone() {
    return Column(
      children: [
        _logoTile(
          _LogoIds.min,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _logoTile(
                _LogoIds.enhanced,
                width: 90.r,
                height: 90.r,
              ),
              const Spacer(),
              _logoTile(
                _LogoIds.logo4,
                width: 110.r,
                height: 110.r,
              ),
              const Spacer(),
              _logoTile(
                _LogoIds.logo8,
                width: 90.r,
                height: 90.r,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _logoTile(
                _LogoIds.ws,
                width: 118.r,
                height: 22.r,
              ),
              const Spacer(),
              _logoTile(
                _LogoIds.logo6,
                width: 90.r,
                height: 90.r,
              ),
              const Spacer(),
              _logoTile(
                _LogoIds.securhub,
                width: 118.r,
                height: 72.r,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logoTile(
                _LogoIds.valldal,
                width: 160.r,
                height: 80.r,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getLogosForTablet() {
    Widget logo(String id, {double? width, double? height}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        child: _logoTile(id, width: width, height: height),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo(_LogoIds.min, height: 90.r),
            SizedBox(width: 16.w),
            logo(_LogoIds.logo4, width: 110.r, height: 110.r),
          ],
        ),
        SizedBox(height: 12.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(_LogoIds.enhanced, width: 80.r, height: 80.r),
              SizedBox(width: 12.w),
              logo(_LogoIds.logo8, width: 80.r, height: 80.r),
              SizedBox(width: 12.w),
              logo(_LogoIds.ws, width: 110.r, height: 20.r),
              SizedBox(width: 12.w),
              logo(_LogoIds.logo6, width: 80.r, height: 80.r),
              SizedBox(width: 12.w),
              logo(_LogoIds.securhub, width: 110.r, height: 66.r),
              SizedBox(width: 12.w),
              logo(_LogoIds.valldal, width: 140.r, height: 70.r),
            ],
          ),
        ),
      ],
    );
  }

  _PartnerLogoConfig _logo(String id) => _logoConfigs[id]!;

  Map<String, _PartnerLogoConfig> _buildLogoConfigs() {
    return {
      _LogoIds.main: _PartnerLogoConfig(
          id: _LogoIds.main, asset: 'assets/images/logo_full.png'),
      _LogoIds.min: _PartnerLogoConfig(
          id: _LogoIds.min, asset: 'assets/images/min_logo.png'),
      _LogoIds.enhanced: _PartnerLogoConfig(
          id: _LogoIds.enhanced, asset: 'assets/images/logo_enchanced.png'),
      _LogoIds.logo4: _PartnerLogoConfig(
          id: _LogoIds.logo4, asset: 'assets/images/logo4.png'),
      _LogoIds.logo8: _PartnerLogoConfig(
          id: _LogoIds.logo8, asset: 'assets/images/logo8.png'),
      _LogoIds.ws: _PartnerLogoConfig(
          id: _LogoIds.ws, asset: 'assets/images/ws_logo.png'),
      _LogoIds.logo6: _PartnerLogoConfig(
          id: _LogoIds.logo6, asset: 'assets/images/logo6.png'),
      _LogoIds.securhub: _PartnerLogoConfig(
          id: _LogoIds.securhub, asset: 'assets/images/securhub.png'),
      _LogoIds.valldal: _PartnerLogoConfig(
          id: _LogoIds.valldal, asset: 'assets/images/valldall.png'),
    };
  }

  List<_LogoSnapshot> _captureLogoSnapshots(RenderBox stackBox) {
    final snapshots = <_LogoSnapshot>[];
    for (final config in _logoConfigs.values) {
      final keyContext = config.key.currentContext;
      final renderBox = keyContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached || !renderBox.hasSize) {
        continue;
      }

      final offset = renderBox.localToGlobal(Offset.zero, ancestor: stackBox);
      snapshots.add(
        _LogoSnapshot(
          config: config,
          rect: offset & renderBox.size,
        ),
      );
    }
    return snapshots;
  }

  Map<String, Rect> _buildTargetRects({
    required List<_LogoSnapshot> snapshots,
    required Size canvasSize,
    required String selectedId,
    required EdgeInsets padding,
  }) {
    final targets = <String, Rect>{};

    for (final snapshot in snapshots) {
      if (snapshot.config.id == selectedId) {
        final left = (canvasSize.width - snapshot.rect.width) / 2.0;
        final clampedLeft = left.clamp(
          8.0,
          canvasSize.width - snapshot.rect.width - 8.0,
        );
        final top = max(padding.top + 64.h, 16.h);
        targets[snapshot.config.id] = Rect.fromLTWH(
          clampedLeft.toDouble(),
          top,
          snapshot.rect.width,
          snapshot.rect.height,
        );
        continue;
      }

      final random = Random(snapshot.config.id.hashCode ^ selectedId.hashCode);
      final direction = random.nextInt(4);
      final travel = 80 + random.nextInt(120);
      double left;
      double top;

      switch (direction) {
        case 0:
          left = -snapshot.rect.width - travel;
          top =
              random.nextDouble() * (canvasSize.height - snapshot.rect.height);
          break;
        case 1:
          left = canvasSize.width + travel.toDouble();
          top =
              random.nextDouble() * (canvasSize.height - snapshot.rect.height);
          break;
        case 2:
          left = random.nextDouble() *
              max(1, canvasSize.width - snapshot.rect.width);
          top = -snapshot.rect.height - travel;
          break;
        default:
          left = random.nextDouble() *
              max(1, canvasSize.width - snapshot.rect.width);
          top = canvasSize.height + travel.toDouble();
      }

      targets[snapshot.config.id] = Rect.fromLTWH(
        left,
        top,
        snapshot.rect.width,
        snapshot.rect.height,
      );
    }

    return targets;
  }

  Map<String, _PartnerLogoInfo> _localizedPartnerInfo(AppLocalizations l10n) {
    final defaultInfo = _defaultLogoInfo(l10n);
    return {
      _LogoIds.main: _PartnerLogoInfo(
        title: l10n.splashPartnerMainTitle,
        description: l10n.splashPartnerMainDescription,
        links: [
          _PartnerLink(
            url: 'https://akademy.edu.pl/',
            label: l10n.splashPartnerMainLinkLabel,
          ),
        ],
      ),
      _LogoIds.ws: _PartnerLogoInfo(
        title: l10n.splashPartnerWsTitle,
        description: l10n.splashPartnerWsDescription,
        links: [
          _PartnerLink(
            url: 'https://webgate.pro',
            label: l10n.splashPartnerWsLinkLabel,
          ),
        ],
      ),
      _LogoIds.securhub: _PartnerLogoInfo(
        title: l10n.splashPartnerSecurhubTitle,
        description: l10n.splashPartnerSecurhubDescription,
        links: [
          _PartnerLink(
            url: 'https://www.securhub.pl/',
            label: l10n.splashPartnerSecurhubLinkLabel,
          ),
        ],
      ),
      _LogoIds.logo4: _PartnerLogoInfo(
        title: l10n.splashPartnerFsoTitle,
        description: l10n.splashPartnerFsoDescription,
        links: [
          _PartnerLink(
            url: 'https://www.facebook.com/share/1CHRFB4HEC/',
            label: l10n.splashPartnerFsoLinkLabel,
          ),
        ],
      ),
      _LogoIds.logo8: _PartnerLogoInfo(
        title: l10n.splashPartnerOspTitle,
        description: l10n.splashPartnerOspDescription,
        links: [
          _PartnerLink(
            url: 'https://www.ospwitomino.pl/',
            label: l10n.splashPartnerOspLink1Label,
          ),
          _PartnerLink(
            url: 'https://www.facebook.com/ospwitomino',
            label: l10n.splashPartnerOspLink2Label,
          ),
        ],
      ),
      _LogoIds.logo6: _PartnerLogoInfo(
        title: l10n.splashPartnerPonTitle,
        description: l10n.splashPartnerPonDescription,
        links: [
          _PartnerLink(
            url: 'https://pomorskaon.pl/',
            label: l10n.splashPartnerPonLinkLabel,
          ),
        ],
      ),
      _LogoIds.enhanced: _PartnerLogoInfo(
        title: l10n.splashPartnerPoprTitle,
        description: l10n.splashPartnerPoprDescription,
        links: [
          _PartnerLink(
            url: 'https://www.popr.com.pl/',
            label: l10n.splashPartnerPoprLinkLabel,
          ),
        ],
      ),
      _LogoIds.min: _PartnerLogoInfo(
        title: l10n.splashPartnerMenTitle,
        description: l10n.splashPartnerMenDescription,
        links: [
          _PartnerLink(
            url: 'https://www.gov.pl/web/edukacja',
            label: l10n.splashPartnerMenLinkLabel,
          ),
        ],
      ),
      _LogoIds.valldal: _PartnerLogoInfo(
        title: l10n.splashPartnerValldalTitle,
        description: l10n.splashPartnerValldalDescription,
        links: [
          _PartnerLink(
            url: 'https://www.valldal.pl',
            label: l10n.splashPartnerValldalLinkLabel,
          ),
        ],
      ),
    };
  }

  _PartnerLogoInfo _defaultLogoInfo(AppLocalizations l10n) => _PartnerLogoInfo(
        title: l10n.splashPartnerDefaultTitle,
        description: l10n.splashPartnerDefaultDescription,
        isDefault: true,
      );

  String _linkButtonText(_PartnerLink link, AppLocalizations l10n) {
    final label = link.label?.toLowerCase() ?? '';
    final url = link.url.toLowerCase();
    final isFacebook =
        url.contains('facebook.com') || label.contains('facebook');
    return isFacebook ? l10n.splashGoToFacebook : l10n.splashGoToWebsite;
  }
}

class _PartnerLogoConfig {
  _PartnerLogoConfig({required this.id, required this.asset})
      : key = GlobalKey();

  final String id;
  final String asset;
  final GlobalKey key;
}

class _LogoSnapshot {
  _LogoSnapshot({required this.config, required this.rect});

  final _PartnerLogoConfig config;
  final Rect rect;
}

class _PartnerLogoInfo {
  const _PartnerLogoInfo({
    required this.title,
    required this.description,
    this.links = const [],
    this.isDefault = false,
  });

  final String title;
  final String description;
  final List<_PartnerLink> links;
  final bool isDefault;
}

class _PartnerLink {
  const _PartnerLink({required this.url, this.label});

  final String url;
  final String? label;
}

class _LogoIds {
  static const String main = 'main';
  static const String min = 'min';
  static const String enhanced = 'enhanced';
  static const String logo4 = 'logo4';
  static const String logo8 = 'logo8';
  static const String ws = 'ws';
  static const String logo6 = 'logo6';
  static const String securhub = 'securhub';
  static const String valldal = 'valldal';
}
