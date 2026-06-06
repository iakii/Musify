/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     Musify is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Musify is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *
 *     For more information about Musify, including how to contribute,
 *     please visit: https://github.com/gokadzev/Musify
 */

// Package imports:
import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// Project imports:
import 'package:musify/extensions/l10n.dart';
import 'package:musify/main.dart';
import 'package:musify/services/settings_manager.dart';
import 'package:musify/utilities/flutter_bottom_sheet.dart'
    show closeCurrentBottomSheet;
import 'package:musify/widgets/mini_player.dart';
// import 'package:window_manager/window_manager.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({required this.child, super.key});

  final StatefulNavigationShell child;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  bool? _previousOfflineMode;

  /// Track the previously selected tab index to detect double-taps on the same tab.
  int? _previousTabIndex;

  @override
  Widget build(BuildContext context) {
    final navs = !offlineMode.value
        ? [
            NavigationDestination(
              icon: const Icon(FluentIcons.home_24_regular),
              selectedIcon: const Icon(FluentIcons.home_24_filled),
              label: context.l10n?.home ?? 'Home',
            ),
            NavigationDestination(
              icon: const Icon(FluentIcons.search_24_regular),
              selectedIcon: const Icon(FluentIcons.search_24_filled),
              label: context.l10n?.search ?? 'Search',
            ),
            NavigationDestination(
              icon: const Icon(FluentIcons.book_24_regular),
              selectedIcon: const Icon(FluentIcons.book_24_filled),
              label: context.l10n?.library ?? 'Library',
            ),
            NavigationDestination(
              icon: const Icon(FluentIcons.settings_24_regular),
              selectedIcon: const Icon(FluentIcons.settings_24_filled),
              label: context.l10n?.settings ?? 'Settings',
            ),
          ]
        : [
            NavigationDestination(
              icon: const Icon(FluentIcons.home_24_regular),
              selectedIcon: const Icon(FluentIcons.home_24_filled),
              label: context.l10n?.home ?? 'Home',
            ),
            NavigationDestination(
              icon: const Icon(FluentIcons.settings_24_regular),
              selectedIcon: const Icon(FluentIcons.settings_24_filled),
              label: context.l10n?.settings ?? 'Settings',
            ),
          ];

    final songBar = StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          logger.log(
            'Error in mini player bar',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }
        final metadata = snapshot.data;
        if (metadata == null) {
          return const SizedBox.shrink();
        } else {
          return MiniPlayer(metadata: metadata);
        }
      },
    );
    return Scaffold(
      body: context.isDesktop
          ? Row(
              children: [
                SizedBox(
                  width: 64,
                  child: NavigationRail(
                    elevation: 10,
                    leading: Column(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/ic_launcher_foreground.png',
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const Text(
                          'Musify',
                          style: TextStyle(
                            color: Color(0xff6BA1FF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    selectedIndex: _selectedIndex.value,
                    onDestinationSelected: (int index) {
                      widget.child.goBranch(
                        index,
                        initialLocation: index == widget.child.currentIndex,
                      );
                      setState(() {
                        _selectedIndex.value = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: navs
                        .map(
                          (nav) => NavigationRailDestination(
                            icon: nav.icon,
                            label: Text(nav.label),
                            selectedIcon: nav.selectedIcon,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: kWindowCaptionHeight,
                      //   child: WindowCaption(
                      //     brightness: Theme.of(context).brightness,
                      //   ),
                      // ),
                      Expanded(child: widget.child),
                      songBar,
                    ],
                  ),
                ),
              ],
            )
          : widget.child,
      bottomNavigationBar: context.isDesktop
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if ()
                songBar,
                NavigationBar(
                  selectedIndex: _selectedIndex.value,
                  labelBehavior:
                      ['en', 'zh'].contains(languageSetting.languageCode)
                      ? NavigationDestinationLabelBehavior.onlyShowSelected
                      : NavigationDestinationLabelBehavior.alwaysHide,
                  onDestinationSelected: (index) {
                    widget.child.goBranch(
                      index,
                      initialLocation: index == widget.child.currentIndex,
                    );
                    setState(() {
                      _selectedIndex.value = index;
                    });
                  },
                  destinations: navs,
                ),
              ],
            ),
    );
  }

  List<_NavigationItem> _getNavigationItems(bool isOfflineMode) {
    final items = <_NavigationItem>[
      _NavigationItem(
        icon: FluentIcons.home_24_regular,
        selectedIcon: FluentIcons.home_24_filled,
        label: context.l10n?.home ?? 'Home',
        route: '/home',
        shellIndex: 0,
      ),
    ];

    // Only add search tab in online mode
    if (!isOfflineMode) {
      items.add(
        _NavigationItem(
          icon: FluentIcons.search_24_regular,
          selectedIcon: FluentIcons.search_24_filled,
          label: context.l10n?.search ?? 'Search',
          route: '/search',
          shellIndex: 1,
        ),
      );
    }

    items.addAll([
      _NavigationItem(
        icon: FluentIcons.book_24_regular,
        selectedIcon: FluentIcons.book_24_filled,
        label: context.l10n?.library ?? 'Library',
        route: '/library',
        shellIndex: 2,
      ),
      _NavigationItem(
        icon: FluentIcons.settings_24_regular,
        selectedIcon: FluentIcons.settings_24_filled,
        label: context.l10n?.settings ?? 'Settings',
        route: '/settings',
        shellIndex: 3,
      ),
    ]);

    return items;
  }

  void _handleOfflineModeChange(bool isOfflineMode) {
    if (!mounted) return;

    final currentRoute = GoRouterState.of(context).matchedLocation;

    // If we're switching to offline mode and currently on search tab
    if (isOfflineMode && currentRoute.startsWith('/search')) {
      // Navigate to home
      widget.child.goBranch(0);
    }
  }

  void _onTabTapped(int index, List<_NavigationItem> items) {
    if (index < items.length) {
      final item = items[index];
      final isReselect = _previousTabIndex == index;

      // Close any open bottom sheet before switching tabs
      closeCurrentBottomSheet();

      // If user taps the same tab again, reset it to initial state.
      // Otherwise, preserve the branch state.
      if (isReselect) {
        widget.child.goBranch(item.shellIndex, initialLocation: true);
      } else {
        widget.child.goBranch(item.shellIndex);
      }

      _previousTabIndex = index;
    }
  }

  int _getCurrentIndex(List<_NavigationItem> items, bool isOfflineMode) {
    final currentShellIndex = widget.child.currentIndex;

    if (items.isEmpty) return 0;

    // Try to find the current shell index in the available items
    final matchedIndex = items.indexWhere(
      (item) => item.shellIndex == currentShellIndex,
    );
    if (matchedIndex != -1) return matchedIndex;

    // If the Search branch (1) is active but Search is hidden in offline mode,
    // fall back to the Home tab.
    if (isOfflineMode && currentShellIndex == 1) return 0;

    // Final fallback: return the first tab to keep UI in a valid state.
    return 0;
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    required this.shellIndex,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final int shellIndex;
}
