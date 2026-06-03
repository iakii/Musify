#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

const String upsteamRepo = 'https://github.com/gokadzev/Musify.git';
const String upstreamBranch = 'master';
const String yourBranch = 'harmonyos-port';

/// 颜色输出
class Colors {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String cyan = '\x1B[36m';

  static void info(String msg) => print('$blue[INFO]$reset $msg');
  static void success(String msg) => print('$green[SUCCESS]$reset $msg');
  static void warning(String msg) => print('$yellow[WARNING]$reset $msg');
  static void error(String msg) => print('$red[ERROR]$reset $msg');
  static void title(String msg) => print('\n$cyan=== $msg ===$reset\n');
}

/// 执行命令并返回结果
Future<ProcessResult> runCommand(String cmd, List<String> args,
    {String? workingDirectory}) async {
  return await Process.run(cmd, args,
      workingDirectory: workingDirectory, runInShell: true);
}

/// 检查是否在 Git 仓库中
Future<bool> isGitRepo() async {
  final result = await runCommand('git', ['rev-parse', '--git-dir']);
  return result.exitCode == 0;
}

/// 检查工作区是否干净
Future<bool> isWorkspaceClean() async {
  final result = await runCommand('git', ['diff-index', '--quiet', 'HEAD', '--']);
  return result.exitCode == 0;
}

/// 获取未提交的文件列表
Future<List<String>> getUncommittedFiles() async {
  final result = await runCommand('git', ['status', '--porcelain']);
  if (result.exitCode != 0) return [];
  return (result.stdout as String)
      .split('\n')
      .where((line) => line.trim().isNotEmpty)
      .toList();
}

/// 添加 upstream 远程仓库
Future<void> setupUpstream() async {
  final result = await runCommand('git', ['remote']);
  final remotes = (result.stdout as String).split('\n');

  if (remotes.contains('upstream')) {
    Colors.info('upstream 已存在，更新 URL...');
    await runCommand('git', ['remote', 'set-url', 'upstream', upsteamRepo]);
  } else {
    Colors.info('添加 upstream 远程仓库...');
    await runCommand('git', ['remote', 'add', 'upstream', upsteamRepo]);
  }
  Colors.success('upstream 配置完成');
}

/// 创建备份分支
Future<String> createBackup() async {
  final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
  final backupBranch = 'backup-$timestamp';
  Colors.info('创建备份分支: $backupBranch');
  await runCommand('git', ['branch', backupBranch]);
  Colors.success('备份分支创建成功');
  return backupBranch;
}

/// 获取上游更新日志
Future<void> showUpdateLog() async {
  final result = await runCommand(
      'git', ['log', 'HEAD..upstream/$upstreamBranch', '--oneline', '--no-decorate']);
  if (result.exitCode == 0 && (result.stdout as String).trim().isNotEmpty) {
    Colors.info('即将合并的更新：');
    print(result.stdout);
  } else {
    Colors.info('没有新更新');
  }
}

/// 执行合并
Future<bool> performMerge() async {
  Colors.info('开始合并 upstream/$upstreamBranch ...');

  final mergeResult = await runCommand(
      'git', ['merge', 'upstream/$upstreamBranch', '--no-edit']);

  if (mergeResult.exitCode == 0) {
    Colors.success('合并成功！');
    return true;
  } else {
    Colors.warning('合并出现冲突');
    print(mergeResult.stderr);

    // 获取冲突文件列表
    final conflictResult = await runCommand('git', ['diff', '--name-only', '--diff-filter=U']);
    if (conflictResult.exitCode == 0) {
      final conflicts = (conflictResult.stdout as String)
          .split('\n')
          .where((f) => f.trim().isNotEmpty)
          .toList();

      if (conflicts.isNotEmpty) {
        Colors.info('冲突文件列表：');
        for (final file in conflicts) {
          print('  ⚠️  $file');
        }
      }
    }

    print('\n${Colors.yellow}建议处理方式：');
    print('  1. 查看冲突文件：git status');
    print('  2. 手动编辑冲突文件，删除 <<<<<<< ======= >>>>>>> 标记');
    print('  3. 对于鸿蒙特定文件，保留你的修改版本');
    print('  4. 解决完冲突后执行：git add . && git commit');
    print('\n  或者使用自动解决（谨慎）：');
    print('  git merge --abort && git merge -X ours upstream/$upstreamBranch');

    return false;
  }
}

/// 运行 Flutter 依赖更新
Future<void> runFlutterPubGet() async {
  final flutterResult = await runCommand('flutter', ['--version']);
  if (flutterResult.exitCode == 0) {
    Colors.info('运行 flutter pub get 更新依赖...');
    await runCommand('flutter', ['pub', 'get']);
    Colors.success('依赖更新完成');
  } else {
    Colors.warning('Flutter 未找到，请手动运行 flutter pub get');
  }
}

/// 检查并切换到鸿蒙分支
Future<bool> ensureHarmonyBranch() async {
  // 获取当前分支
  final branchResult = await runCommand('git', ['branch', '--show-current']);
  final currentBranch = (branchResult.stdout as String).trim();

  if (currentBranch == yourBranch) {
    Colors.info('已在 $yourBranch 分支');
    return true;
  }

  // 检查分支是否存在
  final branchList = await runCommand('git', ['branch']);
  final branches = branchList.stdout as String;

  if (branches.contains(yourBranch)) {
    Colors.info('切换到分支: $yourBranch');
    await runCommand('git', ['checkout', yourBranch]);
    return true;
  } else {
    Colors.error('分支 $yourBranch 不存在');
    Colors.info('可用分支：');
    print(branches);
    return false;
  }
}

/// 主同步流程
Future<void> syncMain() async {
  Colors.title('开始同步 Musify 更新');

  // 1. 拉取上游代码
  Colors.info('拉取 upstream 最新代码...');
  final fetchResult = await runCommand('git', ['fetch', 'upstream']);
  if (fetchResult.exitCode != 0) {
    Colors.error('拉取失败');
    print(fetchResult.stderr);
    exit(1);
  }

  // 2. 显示更新日志
  await showUpdateLog();

  // 3. 询问是否继续
  stdout.write('\n是否继续合并？(y/N) ');
  final input = await stdin.first;
  if (input.toString().toLowerCase() != 'y\n') {
    Colors.warning('用户取消同步');
    return;
  }

  // 4. 执行合并
  final success = await performMerge();
  if (!success) {
    exit(1);
  }

  // 5. 更新依赖
  await runFlutterPubGet();

  Colors.title('同步完成');
}

/// 主函数
Future<void> main(List<String> args) async {
  // 解析命令行参数
  if (args.contains('-h') || args.contains('--help')) {
    print('''
Musify 鸿蒙版本同步脚本 (Dart)

用法: dart tool/sync_musify.dart [选项]

选项:
    -h, --help      显示此帮助信息
    -c, --check     仅检查仓库状态，不同步
    -b, --backup    创建备份分支后退出

示例:
    dart tool/sync_musify.dart           执行同步
    dart tool/sync_musify.dart --check   检查状态
    dart tool/sync_musify.dart --backup  创建备份
''');
    return;
  }

  if (args.contains('-c') || args.contains('--check')) {
    if (!await isGitRepo()) {
      Colors.error('当前目录不是 Git 仓库');
      exit(1);
    }
    Colors.info('当前仓库状态：');
    await runCommand('git', ['remote', '-v']);
    print('');
    await runCommand('git', ['branch', '-a']);
    print('');
    await runCommand('git', ['status']);
    return;
  }

  if (args.contains('-b') || args.contains('--backup')) {
    if (!await isGitRepo()) {
      Colors.error('当前目录不是 Git 仓库');
      exit(1);
    }
    await createBackup();
    Colors.success('备份创建完成');
    return;
  }

  // 主流程
  if (!await isGitRepo()) {
    Colors.error('当前目录不是 Git 仓库');
    exit(1);
  }

  if (!await isWorkspaceClean()) {
    final files = await getUncommittedFiles();
    Colors.warning('工作区有未提交的修改：');
    for (final file in files) {
      print('  📝 $file');
    }
    stdout.write('\n是否继续？(y/N) ');
    final input = await stdin.first;
    if (input.toString().toLowerCase() != 'y\n') {
      Colors.info('请先提交或暂存你的修改');
      exit(1);
    }
  }

  await setupUpstream();
  await createBackup();

  if (!await ensureHarmonyBranch()) {
    exit(1);
  }

  await syncMain();
}