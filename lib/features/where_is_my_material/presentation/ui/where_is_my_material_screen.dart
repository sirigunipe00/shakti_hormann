import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/logger/app_logger.dart';
import 'package:shakti_hormann/core/utils/frappe_session.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';
import 'package:shakti_hormann/widgets/hormann_loading_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WhereIsMyMaterialScreen extends StatefulWidget {
  const WhereIsMyMaterialScreen({super.key});

  @override
  State<WhereIsMyMaterialScreen> createState() =>
      _WhereIsMyMaterialScreenState();
}

class _WhereIsMyMaterialScreenState extends State<WhereIsMyMaterialScreen> {
  WebViewController? _controller;
  final HormannLoadingController _loadingProgress = HormannLoadingController();
  var _loading = true;
  var _bootstrapping = false;
  var _revealed = false;
  var _finishing = false;
  String? _error;
  Timer? _loadingTimeout;
  Timer? _urlPoller;

  static const _deskChromeHideJs = r'''
(function () {
  var css = `
    html, body {
      margin: 0 !important;
      padding: 0 !important;
      background: #f1f5f9 !important;
    }
    /* Desk top chrome — hide fully so no empty white strip remains */
    header.navbar, .navbar, .navbar-default, nav.navbar,
    .awesomebar, #navbar-search, .search-bar,
    .navbar-home, .app-logo,
    .dropdown-notifications, .dropdown-navbar-user,
    .sidebar-toggle-btn,
    .layout-side-section, .desk-sidebar, .list-sidebar,
    .page-head, .page-head-content, .page-title,
    .breadcrumb, .breadcrumb-container, .page-breadcrumbs,
    .sticky-top, .navbar.sticky-top,
    .frappe-chat, .chat-app, .open-chat,
    #chat-app, .chat-window, .chat-toggle,
    .btn-chat, [class*="chat-fab"], [id*="chat"],
    .widget.chat, .raven-chat, #raven-chat {
      display: none !important;
      height: 0 !important;
      min-height: 0 !important;
      max-height: 0 !important;
      margin: 0 !important;
      padding: 0 !important;
      overflow: hidden !important;
      opacity: 0 !important;
      pointer-events: none !important;
    }
    .main-section, .page-container, .container.page-body,
    .layout-main, .layout-main-section-wrapper, .layout-main-section,
    .page-content, .page-body, .page-wrapper, .content, #body,
    .page-card-head, .report-wrapper, .frappe-list, .result {
      margin-top: 0 !important;
      padding-top: 0 !important;
      top: 0 !important;
      max-width: 100% !important;
      width: 100% !important;
    }
    /* Frappe often leaves spacer for fixed navbar */
    body.full-width .main-section,
    body[data-route] .main-section,
    .main-section.with-sidebar {
      padding-top: 0 !important;
      margin-top: 0 !important;
    }
  `;
  var style = document.getElementById('shakti-wimm-crop');
  if (!style) {
    style = document.createElement('style');
    style.id = 'shakti-wimm-crop';
    (document.head || document.documentElement).appendChild(style);
  }
  style.textContent = css;

  // Collapse any leftover fixed/sticky top bars that still paint a blank band.
  document.querySelectorAll('body *').forEach(function (el) {
    try {
      var s = window.getComputedStyle(el);
      var top = parseInt(s.top, 10);
      var height = el.offsetHeight || 0;
      if ((s.position === 'fixed' || s.position === 'sticky') &&
          !isNaN(top) && top <= 8 && height > 24 && height <= 120 &&
          el.getBoundingClientRect().top <= 8) {
        var text = (el.innerText || '').trim();
        // Keep real content blocks; hide empty / chrome-only bands.
        if (text.length < 40 || /Where Is My Material|Home|Search/i.test(text)) {
          el.style.setProperty('display', 'none', 'important');
          el.style.setProperty('height', '0', 'important');
        }
      }
      // Hide floating chat / helper bubbles pinned to bottom-right.
      if (s.position !== 'fixed' && s.position !== 'sticky') return;
      var bottom = parseInt(s.bottom, 10);
      var right = parseInt(s.right, 10);
      if (isNaN(bottom) || isNaN(right)) return;
      if (bottom <= 120 && right <= 120 && el.offsetWidth <= 90 && el.offsetHeight <= 90) {
        el.style.setProperty('display', 'none', 'important');
      }
    } catch (e) {}
  });
  true;
})();
''';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    _urlPoller?.cancel();
    _loadingProgress.dispose();
    super.dispose();
  }

  bool _isTargetUrl(String? url) {
    if (url == null) return false;
    return url.toLowerCase().contains('where-is-my-material');
  }

  void _armWatchdogs(WebViewController controller) {
    _loadingTimeout?.cancel();
    _urlPoller?.cancel();

    _loadingTimeout = Timer(const Duration(seconds: 45), () {
      if (!mounted || _revealed || _finishing) return;
      _failAndReveal(
        'Taking too long to open the report. Pull refresh or try again.',
      );
    });

    // Backup: some Android WebView builds skip onPageFinished for SPA routes.
    _urlPoller = Timer.periodic(const Duration(milliseconds: 600), (timer) async {
      if (!mounted || _revealed || _finishing) {
        timer.cancel();
        return;
      }
      try {
        final url = await controller.currentUrl();
        if (_isTargetUrl(url)) {
          $logger.devLog('[WIMM] poll hit target url=$url');
          await _onArrivedAtReport(controller);
        }
      } catch (_) {}
    });
  }

  void _cancelWatchdogs() {
    _loadingTimeout?.cancel();
    _urlPoller?.cancel();
  }

  void _revealPage({String? error}) {
    if (!mounted || _revealed) return;
    _revealed = true;
    _finishing = false;
    _cancelWatchdogs();
    _loadingProgress.stopIdleCreep();
    setState(() {
      _loading = false;
      _error = error;
    });
  }

  Future<void> _failAndReveal(String message) async {
    if (_revealed || _finishing) return;
    _loadingProgress.stopIdleCreep();
    _revealPage(error: message);
  }

  Future<void> _finishSuccessfully(WebViewController controller) async {
    if (_revealed || _finishing) return;
    _finishing = true;
    _cancelWatchdogs();
    $logger.devLog('[WIMM] cropping desk chrome then revealing');
    try {
      // Crop before reveal so the empty navbar/page-head band never flashes.
      await controller.runJavaScript(_deskChromeHideJs);
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await controller.runJavaScript(_deskChromeHideJs);
    } catch (e) {
      $logger.devLog('[WIMM] crop js error: $e');
    }
    await _loadingProgress.complete();
    if (!mounted) return;
    _revealPage();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await controller.runJavaScript(_deskChromeHideJs);
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      await controller.runJavaScript(_deskChromeHideJs);
    } catch (e) {
      $logger.devLog('[WIMM] crop js error: $e');
    }
  }

  Future<void> _onArrivedAtReport(WebViewController controller) async {
    if (_revealed || _finishing) return;
    $logger.devLog('[WIMM] arrived at report');
    _loadingProgress.setStage(0.92, label: 'Almost ready');
    await _finishSuccessfully(controller);
  }

  Future<void> _applyCookies(FrappeSessionResult session) async {
    final cookieManager = WebViewCookieManager();
    for (final entry in session.cookies.entries) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: entry.key,
          value: entry.value,
          domain: session.host,
          path: '/',
        ),
      );
    }
    // Ensure sid is present even if cookie map was sparse.
    await cookieManager.setCookie(
      WebViewCookie(
        name: 'sid',
        value: session.sid,
        domain: session.host,
        path: '/',
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  Future<WebViewController> _createController() async {
    final controller = WebViewController();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setBackgroundColor(Colors.white);

    await controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.prevent;
          if (uri.host.isEmpty) return NavigationDecision.navigate;
          if (uri.host.toLowerCase() !=
              FrappeSession.reportUri.host.toLowerCase()) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (url) {
          $logger.devLog('[WIMM] page started: $url');
          if (_revealed || _finishing) return;
          _loadingProgress.setStage(0.62, label: 'Opening the door');
        },
        onPageFinished: (url) async {
          $logger.devLog('[WIMM] page finished: $url');
          if (_isTargetUrl(url)) {
            await _onArrivedAtReport(controller);
            return;
          }

          // Intermediate desk pages — advance staged progress only.
          if (!_revealed && !_finishing) {
            _loadingProgress.setStage(0.78, label: 'Closing up');
          }

          // If desk bounced to login, surface a clear error.
          if (url.toLowerCase().contains('/login') &&
              !_revealed &&
              !_finishing) {
            await _failAndReveal(
              'ERPNext session expired. Please log out/in of the app and try again.',
            );
          }
        },
        onWebResourceError: (error) {
          $logger.devLog(
            '[WIMM] resource error main=${error.isForMainFrame} desc=${error.description}',
          );
          if (error.isForMainFrame != true) return;
          if (_revealed || _finishing) return;
          unawaited(
            _failAndReveal(
              error.description.isNotEmpty
                  ? error.description
                  : 'Could not load the page. Please try again.',
            ),
          );
        },
      ),
    );

    return controller;
  }

  Future<void> _bootstrap() async {
    if (_bootstrapping) return;
    _bootstrapping = true;
    _revealed = false;
    _finishing = false;
    _cancelWatchdogs();
    _loadingProgress.reset();
    _loadingProgress.setStage(0.08, label: 'Fitting the frame');
    _loadingProgress.startIdleCreep(ceiling: 0.88);

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      $logger.devLog('[WIMM] creating desk session…');
      final session = await FrappeSession.createDeskSession();
      if (!mounted) return;
      _loadingProgress.setStage(0.32, label: 'Hanging the door');
      $logger.devLog('[WIMM] sid acquired host=${session.host}');

      final controller = _controller ?? await _createController();
      if (!mounted) return;
      setState(() => _controller = controller);

      await _applyCookies(session);
      if (!mounted) return;
      _loadingProgress.setStage(0.48, label: 'Checking the finish');
      _armWatchdogs(controller);

      $logger.devLog('[WIMM] loading ${session.reportUrl}');
      await controller.loadRequest(session.reportUrl);
      if (!mounted || _revealed || _finishing) return;
      _loadingProgress.setStage(0.58, label: 'Opening the door');
    } catch (e, st) {
      $logger.error('[WIMM] bootstrap failed', e, st);
      await _failAndReveal(e.toString().replaceFirst('Bad state: ', ''));
    } finally {
      _bootstrapping = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'Where Is My Material?',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Force show page',
              onPressed: () => _revealPage(),
              icon: const Icon(Icons.visibility_outlined),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: ElevatedButton(
                onPressed:
                    _bootstrapping || _finishing || _loading ? null : _bootstrap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  disabledBackgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller != null)
            WebViewWidget(controller: _controller!),
          if (_loading)
            ColoredBox(
              color: Colors.white,
              child: DoorLoadingLoop(
                expand: true,
                width: 220,
                progressController: _loadingProgress,
              ),
            ),
          if (_error != null && !_loading)
            ColoredBox(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _bootstrap,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                        ),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
