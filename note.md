# Linux & Shell 学习笔记

## 环境

- 环境：Windows + Git Bash（MSYS2 提供的 bash 与 coreutils）。
- 说明：本机 WSL 暂不可用，因此使用 Git Bash 完成全部命令行任务；所用命令均为标准 POSIX 工具，可在任意 Linux 发行版 / WSL2 中复现。

## 做题过程与命令

### Task 01 — Project Hunt

`workspace/` 里藏着一个隐藏目录 `.project/`，用 `ls -la workspace/` 才能看到它。

```bash
cat workspace/.project/metadata
# PROJECT_NAME=linux-shell-recruit
# PROJECT_ID=LSR-2026-0831

printf 'LSR-2026-0831\n' > output/01_project_id.txt
printf '../../.project/metadata\n' > output/01_relative_path.txt
```

相对路径的理解：从 `workspace/src/utils/` 出发，`../..` 回到 `workspace/`，再进入 `.project/metadata`，所以是 `../../.project/metadata`。

### Task 02 — Missing Command

`ls -l tools/recruit-info` 能看到它没有执行权限（没有 `x`），所以 `chmod +x tools/recruit-info` 修复。PATH 的详细解释见 `answers/02.md`。让当前会话直接运行：

```bash
export PATH="$PWD/tools:$PATH"
recruit-info
```

### Task 03 — Code Search

```bash
grep -rlE 'TODO|FIXME' workspace/project/ | sort > output/03_code_search.txt
```

`-r` 递归、`-l` 只输出文件名、`-E` 用扩展正则匹配 `TODO` 或 `FIXME`，再用 `sort` 按字典序排列。

### Task 04 — Log Statistics

```bash
grep -c 'ERROR' logs/server.log > output/04_error_count.txt
grep 'ERROR' logs/server.log | sed -E 's/.*user=([^ ]+).*/\1/' | sort -u > output/04_error_users.txt
grep 'ERROR' logs/server.log | sed -E 's/.*code=([0-9]+).*/\1/' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}' > output/04_top_code.txt
```

用 `grep` 筛选、`sed` 提取字段、`sort -u` 去重排序、`uniq -c` 计数、`sort -rn` 逆序、`head -1` 取最高频。

### Task 05 — Pipeline Challenge

```bash
cut -d' ' -f1 logs/access.log | sort | uniq -c | sort -rn | head -1 | awk '{print $2}' > output/05_top_ip.txt
```

整条流水线没有创建任何中间文件，多个程序通过管道直接串联。

### Task 06 — Streams & Redirection

```bash
./tools/check-project > output/06_stdout.txt 2> output/06_stderr.txt
./tools/check-project | tee output/06_tee.txt
```

`>` 重定向 stdout，`2>` 重定向 stderr，`tee` 把 stdout 同时写进文件并显示到终端。

### Task 07 — Analyze Script

补全 `scripts/analyze.sh`：用 `$#` 校验参数数量，用 `[[ ! -f "$file" ]]` 校验文件是否存在，失败时输出提示并 `exit 1`；正常时统计 `ERROR` 数量与出现次数最多的 `code`。

### Task 08 — Script Debug

原脚本的 `$destination`、`$@`、`$file` 都没加引号，遇到带空格的文件名（`My Report.txt`）会被拆成多个参数而复制失败。改为 `"$destination"`、`"$@"`、`"$file"` 后即可正确处理。详细解释见 `answers/08.md`。

### Task 09 — Process Hunter（附加题）

```bash
./scripts/start-workers.sh
kill "$(cat .runtime/worker-beta.pid)"
./check.sh 09
```

通过 `.runtime/worker-beta.pid` 找到 worker-beta 的 PID，用 `kill` 正常终止它，并确认 worker-alpha、worker-gamma 仍在运行。

## 自检结果

```text
[PASS] 01 Project Hunt
[PASS] 02 Missing Command
[REVIEW] Task 02 文字答案待人工检查
[PASS] 03 Code Search
[PASS] 04 Log Statistics
[PASS] 05 Pipeline Challenge
[PASS] 06 Streams & Redirection
[PASS] 07 Analyze Script
[PASS] 08 Script Debug
[REVIEW] Task 08 文字答案待人工检查

Main progress: 8 / 8
Extra task 09 is not included in the main progress.
[PASS] 09 Process Hunter (Extra)
```

## 心得

- Shell 的核心是把「读文件、过滤、统计」这类小工具用管道和重定向连接起来解决问题。
- 涉及变量和文件名时，引号非常关键：`$var` 会被拆分和通配符展开，`"$var"` 才安全。
- 执行前先理解命令，尤其是 `rm`、`kill`、通配符这类有副作用的操作。
- AI 使用说明：本部分使用 Codex 协助梳理命令与排查问题，最终每条命令和脚本都经过本人逐条核对并理解其含义。
