# 暗影古径 — 目录地图

## 仓库结构

| 目录 | 职责 | 可写角色 |
|------|------|----------|
| `scripts/` | 游戏逻辑脚本 (GDScript) | builder |
| `scenes/` | Godot 场景文件 (.tscn) | builder |
| `assets/` | 美术资源 (精灵、音效、字体) | builder |
| `resources/` | Godot 资源文件 (.tres) | builder |
| `spec/` | 版本范围定义 | builder |
| `docs/` | 项目文档 | builder, test-author |
| `tests/` | 测试代码 | test-author |
| `v0.1/assets/` | v0.1 资源参考 | builder (只读参考) |

## 路径规则

- 脚本: `scripts/<system>/<name>.gd`
- 场景: `scenes/<system>/<name>.tscn`
- 资源: `resources/<type>/<name>.tres`
- 测试: `tests/<unit|integration>/test_<subject>.gd`
- 规范: `spec/v<version>-scope.md`
- 文档: `docs/<category>/<name>.md`

## 读写规则

- `docs/development/acceptance-standard.md` — 只读，不可降低标准
- `spec/` — builder 可写
- `AGENTS.md` — 仅 reviewer 可修改
