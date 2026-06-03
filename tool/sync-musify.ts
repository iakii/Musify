#!/usr/bin/env bun

import { $, spawn } from 'bun';

// 配置
const CONFIG = {
  upstreamRepo: 'https://github.com/gokadzev/Musify.git',
  upstreamBranch: 'master',
  yourBranch: 'harmonyos-port',
};

// 颜色输出
const c = {
  reset: '\x1B[0m',
  red: '\x1B[31m',
  green: '\x1B[32m',
  yellow: '\x1B[33m',
  blue: '\x1B[34m',
  cyan: '\x1B[36m',

  info: (msg: string) => console.log(`${c.blue}[INFO]${c.reset} ${msg}`),
  success: (msg: string) => console.log(`${c.green}[SUCCESS]${c.reset} ${msg}`),
  warning: (msg: string) => console.log(`${c.yellow}[WARNING]${c.reset} ${msg}`),
  error: (msg: string) => console.log(`${c.red}[ERROR]${c.reset} ${msg}`),
  title: (msg: string) => console.log(`\n${c.cyan}=== ${msg} ===${c.reset}\n`),
};

// 执行命令并返回结果
async function run(cmd: string[], options?: { cwd?: string }): Promise<{ success: boolean; stdout: string; stderr: string }> {
  try {
    const result = await $`${cmd}`.cwd(options?.cwd ?? process.cwd()).quiet();
    return { success: true, stdout: result.text(), stderr: '' };
  } catch (error: any) {
    return { success: false, stdout: error.stdout?.toString() ?? '', stderr: error.stderr?.toString() ?? '' };
  }
}

// 检查是否在 Git 仓库中
async function isGitRepo(): Promise<boolean> {
  const result = await run(['git', 'rev-parse', '--git-dir']);
  return result.success;
}

// 检查工作区是否干净
async function isWorkspaceClean(): Promise<boolean> {
  const result = await run(['git', 'diff-index', '--quiet', 'HEAD', '--']);
  return result.success;
}

// 获取未提交的文件
async function getUncommittedFiles(): Promise<string[]> {
  const result = await run(['git', 'status', '--porcelain']);
  if (!result.success) return [];
  return result.stdout.split('\n').filter(l => l.trim().length > 0);
}

// 设置 upstream
async function setupUpstream(): Promise<void> {
  const result = await run(['git', 'remote']);
  const remotes = result.stdout.split('\n');

  if (remotes.includes('upstream')) {
    c.info('upstream 已存在，更新 URL...');
    await run(['git', 'remote', 'set-url', 'upstream', CONFIG.upstreamRepo]);
  } else {
    c.info('添加 upstream 远程仓库...');
    await run(['git', 'remote', 'add', 'upstream', CONFIG.upstreamRepo]);
  }
  c.success('upstream 配置完成');
}

// 创建备份分支
async function createBackup(): Promise<string> {
  const timestamp = new Date().toISOString().replace(/:/g, '-').split('.')[0];
  const backupBranch = `backup-${timestamp}`;
  c.info(`创建备份分支: ${backupBranch}`);
  await run(['git', 'branch', backupBranch]);
  c.success('备份分支创建成功');
  return backupBranch;
}

// 显示更新日志
async function showUpdateLog(): Promise<void> {
  const result = await run(['git', 'log', `HEAD..upstream/${CONFIG.upstreamBranch}`, '--oneline', '--no-decorate']);
  if (result.success && result.stdout.trim()) {
    c.info('即将合并的更新：');
    console.log(result.stdout);
  } else {
    c.info('没有新更新');
  }
}

// 执行合并
async function performMerge(): Promise<boolean> {
  c.info(`开始合并 upstream/${CONFIG.upstreamBranch} ...`);

  const mergeResult = await run(['git', 'merge', `upstream/${CONFIG.upstreamBranch}`, '--no-edit']);

  if (mergeResult.success) {
    c.success('合并成功！');
    return true;
  } else {
    c.warning('合并出现冲突');
    console.log(mergeResult.stderr);

    // 获取冲突文件
    const conflictResult = await run(['git', 'diff', '--name-only', '--diff-filter=U']);
    if (conflictResult.success && conflictResult.stdout.trim()) {
      const conflicts = conflictResult.stdout.split('\n').filter(f => f.trim());
      c.info('冲突文件列表：');
      conflicts.forEach(f => console.log(`  ⚠️  ${f}`));
    }

    console.log(`\n${c.yellow}建议处理方式：${c.reset}`);
    console.log('  1. 查看冲突文件：git status');
    console.log('  2. 手动编辑冲突文件，删除 <<<<<<< ======= >>>>>>> 标记');
    console.log('  3. 对于鸿蒙特定文件，保留你的修改版本');
    console.log('  4. 解决完冲突后执行：git add . && git commit');

    return false;
  }
}

// 更新 Flutter 依赖
async function runFlutterPubGet(): Promise<void> {
  const flutterCheck = await run(['flutter', '--version']);
  if (flutterCheck.success) {
    c.info('运行 flutter pub get 更新依赖...');
    await run(['flutter', 'pub', 'get']);
    c.success('依赖更新完成');
  } else {
    c.warning('Flutter 未找到，请手动运行 flutter pub get');
  }
}

// 切换到鸿蒙分支
async function ensureHarmonyBranch(): Promise<boolean> {
  const branchResult = await run(['git', 'branch', '--show-current']);
  const currentBranch = branchResult.stdout.trim();

  if (currentBranch === CONFIG.yourBranch) {
    c.info(`已在 ${CONFIG.yourBranch} 分支`);
    return true;
  }

  const branchList = await run(['git', 'branch']);
  if (branchList.stdout.includes(CONFIG.yourBranch)) {
    c.info(`切换到分支: ${CONFIG.yourBranch}`);
    await run(['git', 'checkout', CONFIG.yourBranch]);
    return true;
  } else {
    c.error(`分支 ${CONFIG.yourBranch} 不存在`);
    console.log(branchList.stdout);
    return false;
  }
}

// 主同步流程
async function syncMain(): Promise<void> {
  c.title('开始同步 Musify 更新');

  // 拉取上游
  c.info('拉取 upstream 最新代码...');
  const fetchResult = await run(['git', 'fetch', 'upstream']);
  if (!fetchResult.success) {
    c.error('拉取失败');
    console.log(fetchResult.stderr);
    process.exit(1);
  }

  // 显示更新
  await showUpdateLog();

  // 询问确认
  const encoder = new TextEncoder();
  const input = await (async () => {
    process.stdout.write('\n是否继续合并？(y/N) ');
    const buffer = new Uint8Array(1);
    await Bun.stdin.read(buffer);
    return String.fromCharCode(buffer[0]);
  })();

  if (input.toLowerCase() !== 'y') {
    c.warning('用户取消同步');
    return;
  }

  // 执行合并
  const success = await performMerge();
  if (!success) process.exit(1);

  // 更新依赖
  await runFlutterPubGet();

  c.title('同步完成');
}

// 显示帮助
function showHelp(): void {
  console.log(`
Musify 鸿蒙版本同步脚本 (Bun)

用法: bun run sync-musify.ts [选项]

选项:
    -h, --help      显示此帮助信息
    -c, --check     仅检查仓库状态，不同步
    -b, --backup    创建备份分支后退出

示例:
    bun run sync-musify.ts           执行同步
    bun run sync-musify.ts --check   检查状态
    bun run sync-musify.ts --backup  创建备份
`);
}

// 主函数
async function main() {
  const args = process.argv.slice(2);

  if (args.includes('-h') || args.includes('--help')) {
    showHelp();
    return;
  }

  if (args.includes('-c') || args.includes('--check')) {
    if (!await isGitRepo()) {
      c.error('当前目录不是 Git 仓库');
      process.exit(1);
    }
    c.info('当前仓库状态：');
    await run(['git', 'remote', '-v']);
    console.log('');
    await run(['git', 'branch', '-a']);
    console.log('');
    await run(['git', 'status']);
    return;
  }

  if (args.includes('-b') || args.includes('--backup')) {
    if (!await isGitRepo()) {
      c.error('当前目录不是 Git 仓库');
      process.exit(1);
    }
    await createBackup();
    c.success('备份创建完成');
    return;
  }

  // 主流程
  if (!await isGitRepo()) {
    c.error('当前目录不是 Git 仓库');
    process.exit(1);
  }

  if (!await isWorkspaceClean()) {
    const files = await getUncommittedFiles();
    c.warning(`工作区有 ${files.length} 个未提交的修改`);
    files.forEach(f => console.log(`  📝 ${f}`));

    process.stdout.write('\n是否继续？(y/N) ');
    const encoder = new TextEncoder();
    const buffer = new Uint8Array(1);
    await Bun.stdin.read(buffer);
    const input = String.fromCharCode(buffer[0]);

    if (input.toLowerCase() !== 'y') {
      c.info('请先提交或暂存你的修改');
      process.exit(1);
    }
  }

  await setupUpstream();
  await createBackup();

  if (!await ensureHarmonyBranch()) process.exit(1);

  await syncMain();
}

// 运行
main().catch(console.error);