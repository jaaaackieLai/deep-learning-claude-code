#!/usr/bin/env python3
"""
Claude Marketplace - 引用完整性測試腳本

驗證所有 agents, commands, 和 skills 的引用是否正確。

使用方法:
    python scripts/test-references.py

    或

    chmod +x scripts/test-references.py
    ./scripts/test-references.py
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Dict, Tuple

# 顏色輸出
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_header(text: str):
    """印出標題"""
    print(f"\n{Colors.BOLD}{Colors.BLUE}{'=' * 80}{Colors.END}")
    print(f"{Colors.BOLD}{text}{Colors.END}")
    print(f"{Colors.BOLD}{Colors.BLUE}{'=' * 80}{Colors.END}\n")

def print_section(text: str):
    """印出區段標題"""
    print(f"\n{Colors.BOLD}{text}{Colors.END}")
    print(f"{Colors.BLUE}{'-' * 80}{Colors.END}")

def test_agents_format() -> Tuple[bool, List[Dict]]:
    """測試 agents 格式是否正確"""
    print_section("📋 測試 1: Agents 格式驗證")

    agents_dir = Path("agents")
    if not agents_dir.exists():
        print(f"{Colors.RED}❌ agents/ 目錄不存在{Colors.END}")
        return False, []

    results = []
    all_pass = True

    for agent_file in sorted(agents_dir.glob("*.md")):
        if agent_file.name == "README.md":
            continue

        with open(agent_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # 檢查 frontmatter
        if not content.startswith("---"):
            print(f"{Colors.RED}❌ {agent_file.name}: 缺少 frontmatter{Colors.END}")
            all_pass = False
            continue

        frontmatter_end = content.find("---", 3)
        frontmatter = content[3:frontmatter_end]

        has_name = "name:" in frontmatter
        has_desc = "description:" in frontmatter
        has_tools = "tools:" in frontmatter
        has_skills = "skills:" in frontmatter
        has_when_to_use = "## When to Use This Agent" in content

        required_pass = all([has_name, has_desc, has_tools])
        optional_pass = has_skills and has_when_to_use

        if required_pass and optional_pass:
            print(f"{Colors.GREEN}✅ {agent_file.name:<25}{Colors.END} | Required: ✓ | Skills: ✓ | When-to-Use: ✓")
        else:
            print(f"{Colors.YELLOW}⚠️  {agent_file.name:<25}{Colors.END} | Required: {'✓' if required_pass else '✗'} | Skills: {'✓' if has_skills else '✗'} | When-to-Use: {'✓' if has_when_to_use else '✗'}")
            all_pass = False

        results.append({
            'file': agent_file.name,
            'required': required_pass,
            'skills': has_skills,
            'when_to_use': has_when_to_use
        })

    print(f"\n總計: {len(results)} 個 agents")
    return all_pass, results

def test_skills_references() -> bool:
    """測試 skills 引用路徑是否存在"""
    print_section("📋 測試 2: Skills 引用路徑驗證")

    agents_dir = Path("agents")
    skills_dir = Path("skills")
    all_valid = True

    if not skills_dir.exists():
        print(f"{Colors.RED}❌ skills/ 目錄不存在{Colors.END}")
        return False

    for agent_file in sorted(agents_dir.glob("*.md")):
        if agent_file.name == "README.md":
            continue

        with open(agent_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # 提取 skills 列表
        skills_match = re.search(r'skills:\s*\n((?:\s+-\s+.*\n?)+)', content)
        if skills_match:
            skills_list = re.findall(r'-\s+(.+)', skills_match.group(1))
            print(f"\n{agent_file.name}:")

            for skill in skills_list:
                skill = skill.strip()
                skill_path = skills_dir / skill / "SKILL.md"

                # 某些 skills 可能是目錄而沒有 SKILL.md
                if skill_path.exists():
                    print(f"   {Colors.GREEN}✅ {skill}{Colors.END}")
                elif (skills_dir / skill).exists():
                    print(f"   {Colors.YELLOW}⚠️  {skill} (目錄存在但無 SKILL.md){Colors.END}")
                    # 對於 python-skills 這類目錄，可能是正常的
                    if "python-skills" not in skill:
                        all_valid = False
                else:
                    print(f"   {Colors.RED}❌ {skill} (路徑不存在){Colors.END}")
                    all_valid = False

    return all_valid

def test_commands_references() -> bool:
    """測試 commands 中的 agent 引用"""
    print_section("📋 測試 3: Commands 引用驗證")

    commands_dir = Path("commands")
    agents_dir = Path("agents")
    all_valid = True

    if not commands_dir.exists():
        print(f"{Colors.RED}❌ commands/ 目錄不存在{Colors.END}")
        return False

    for cmd_file in sorted(commands_dir.glob("*.md")):
        with open(cmd_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # 檢查舊路徑
        has_old_path = "~/.claude/agents/" in content or "~/.claude/skills/" in content

        # 查找 agent 引用
        agent_refs = re.findall(r'`([a-z-]+)`\s+agent', content, re.IGNORECASE)

        # 檢查 agents 是否存在
        agents_exist = True
        for ref in agent_refs:
            agent_path = agents_dir / f"{ref}.md"
            if not agent_path.exists():
                agents_exist = False

        if has_old_path:
            print(f"{Colors.YELLOW}⚠️  {cmd_file.name:<25}{Colors.END} | 包含舊路徑引用")
            all_valid = False
        elif not agents_exist:
            print(f"{Colors.RED}❌ {cmd_file.name:<25}{Colors.END} | Agent 引用無效")
            all_valid = False
        else:
            print(f"{Colors.GREEN}✅ {cmd_file.name:<25}{Colors.END} | 引用: {', '.join(agent_refs) if agent_refs else 'None'}")

    return all_valid

def test_python_examples() -> bool:
    """測試 Python 範例是否正確"""
    print_section("📋 測試 4: Python 語法範例檢查")

    python_files = [
        Path("agents/tdd-guide.md"),
        Path("commands/tdd.md")
    ]

    all_valid = True

    for file_path in python_files:
        if not file_path.exists():
            print(f"{Colors.RED}❌ {file_path} 不存在{Colors.END}")
            all_valid = False
            continue

        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        python_blocks = len(re.findall(r'```python', content))
        typescript_blocks = len(re.findall(r'```typescript', content))

        if python_blocks > 0 and typescript_blocks == 0:
            print(f"{Colors.GREEN}✅ {file_path.name:<25}{Colors.END} | Python: {python_blocks} | TypeScript: {typescript_blocks}")
        else:
            print(f"{Colors.YELLOW}⚠️  {file_path.name:<25}{Colors.END} | Python: {python_blocks} | TypeScript: {typescript_blocks}")
            if typescript_blocks > 0:
                all_valid = False

    return all_valid

def main():
    """主測試函數"""
    print_header("🔍 Claude Marketplace - 引用完整性測試")

    # 切換到專案根目錄
    script_dir = Path(__file__).parent
    project_dir = script_dir.parent
    os.chdir(project_dir)

    # 執行測試
    test_results = []

    # 測試 1: Agents 格式
    agents_pass, _ = test_agents_format()
    test_results.append(("Agents 格式驗證", agents_pass))

    # 測試 2: Skills 引用
    skills_pass = test_skills_references()
    test_results.append(("Skills 路徑驗證", skills_pass))

    # 測試 3: Commands 引用
    commands_pass = test_commands_references()
    test_results.append(("Commands 路徑驗證", commands_pass))

    # 測試 4: Python 範例
    python_pass = test_python_examples()
    test_results.append(("Python 範例驗證", python_pass))

    # 總結
    print_header("📊 測試總結")

    all_pass = all(result[1] for result in test_results)

    for test_name, passed in test_results:
        status = f"{Colors.GREEN}✅ 通過{Colors.END}" if passed else f"{Colors.RED}❌ 失敗{Colors.END}"
        print(f"{status} {test_name}")

    print()

    if all_pass:
        print(f"{Colors.GREEN}{Colors.BOLD}🎉 所有測試通過！系統引用完整且正確。{Colors.END}")
        return 0
    else:
        print(f"{Colors.YELLOW}{Colors.BOLD}⚠️  部分測試未通過，請檢查上述報告。{Colors.END}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
