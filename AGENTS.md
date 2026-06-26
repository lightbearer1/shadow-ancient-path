# 暗影古径 — AGENTS.md

> 本文件为索引目录。详细内容请查阅链接文档。

## 项目概述
像素风 2D 横版动作肉鸽游戏，Godot 4.7 + GDScript。

## 关键文档

| 文档 | 路径 | 用途 |
|------|------|------|
| 目录地图 | [docs/project-map.md](docs/project-map.md) | 仓库结构、路径职责、读写规则 |
| 功能目标 | [docs/project-goal.md](docs/project-goal.md) | 闭环交付物、关键信号流、系统清单 |
| 验收标准 | [docs/development/acceptance-standard.md](docs/development/acceptance-standard.md) | **只读**，不可由 builder 降低 |
| v0.1 范围 | [spec/v0.1-scope.md](spec/v0.1-scope.md) | 已完成范围 |
| v0.2 范围 | [spec/v0.2-scope.md](spec/v0.2-scope.md) | 待实现范围 |
| v0.1 测试用例 | [docs/v0.1-test-cases.md](docs/v0.1-test-cases.md) | 测试覆盖清单 |
| v0.2 测试用例 | [docs/v0.2-test-cases.md](docs/v0.2-test-cases.md) | 测试规划 |
| 资源边界 | [v0.1/assets/README.md](v0.1/assets/README.md) | 资源目录说明 |

## 角色分工

| 角色 | 职责 | 可写范围 |
|------|------|----------|
| **builder** | 实现功能，不得降低验收标准 | `scripts/`, `scenes/`, `assets/`, `resources/`, `spec/` |
| **test-author** | 编写测试用例 | `tests/`, `docs/v0.x-test-cases.md` |
| **acceptance-checker** | 验证每个验收标准有对应测试 | `tests/validate.gd`, `docs/development/acceptance-standard.md` (只读) |
| **reviewer** | 最终审查，只读 | 仅读取，不写入 |

## 运行命令

```bash
# 单元 + 集成测试
godot --headless --script run_tests.gd

# 完整验证套件
godot --headless --script tests/validate.gd
```

## 代码规范
- 脚本文件: snake_case.gd
- 场景文件: snake_case.tscn
- 类名: PascalCase
- 信号: snake_case
- 每个 .tscn 配对一个 .gd
- 新 Resource 文件放入 `resources/` 对应子目录
- 新测试文件命名为 `test_*.gd` 放入 `tests/unit/` 或 `tests/integration/`

## 当前状态
- v0.1 原型已完成，所有测试通过
- v0.2 核心肉鸽循环待实现
