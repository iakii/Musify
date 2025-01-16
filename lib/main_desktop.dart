/*
 *     Copyright (C) 2024 Valeri Gokadze
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

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:musify/main.dart' as m;
// Package imports:
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    title: 'Misify',
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
    backgroundColor: Colors.transparent,
    windowButtonVisibility: false,
    minimumSize: Size(680, 480),
    size: Size(1244, 768),
    center: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    if (Platform.isMacOS) {
      await windowManager.setMovable(true);
      await windowManager.setVisibleOnAllWorkspaces(true, visibleOnFullScreen: true);
    }
    // await windowManager.setAsFrameless();
    await windowManager.setResizable(true);
    if (!Platform.isLinux) await windowManager.setHasShadow(true);
    await windowManager.show();
    await windowManager.setAlwaysOnTop(false);
  });
  m.main();
}
