# 暗影古径 (Shadow Ancient Path)

> 像素风 2D 横版动作肉鸽游戏 | Godot 4.7 + GDScript

![Version](https://img.shields.io/badge/version-v0.1-blue)
![Engine](https://img.shields.io/badge/engine-Godot%204.7-478cbf)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 简介

暗影古径是一款暗黑像素风格的 2D 横版动作 Roguelike 游戏。玩家扮演一名忍者，在古老的暗影路径上战斗，击败敌人，逐步解锁更强大的能力。

**v0.1** 为可玩原型，包含完整的移动、战斗、敌人 AI 和三房间关卡。

## 快速开始

1. 下载 [Godot 4.7](https://godotengine.org/)
2. 克隆仓库:
   ```bash
   git clone https://github.com/lightbearer1/shadow-ancient-path.git
   ```
3. 用 Godot 打开 `project.godot`
4. 按 `F5` 运行

## 操作方式

| 动作 | 按键 |
|------|------|
| 移动 | W/A/S/D 或 方向键 |
| 跳跃 / 二段跳 | W / 空格 |
| 冲刺 | Shift |
| 攻击 | J / 鼠标左键 |
| 暂停 | Esc |

## 当前功能 (v0.1)

- **玩家系统**: 8 状态 FSM，移动、二段跳、冲刺（无敌帧）、三段连击
- **敌人系统**: Shadow Crawler（地面近战）+ Wraith（浮空远程），6 状态 AI
- **战斗系统**: HitBox/HurtBox 碰撞检测，友军过滤，击退，伤害计算
- **关卡系统**: 3 房间手建关卡，双向房间过渡，敌人生成器
- **UI 系统**: 主菜单、HUD（HP/分数/Combo）、暂停菜单、游戏结束
- **视觉效果**: 程序化像素精灵、攻击斩击特效、相机震动

## 项目结构

```
├── scripts/        # GDScript 游戏逻辑
│   ├── systems/    # EventBus, GameManager, CameraController
│   ├── player/     # PlayerController (8状态FSM), PlayerStats
│   ├── enemy/      # BaseEnemy, ShadowCrawler, Wraith, EnemySpawner
│   ├── combat/     # HitBox, HurtBox
│   └── ui/         # HUD, HealthBar, MainMenu, PauseMenu, GameOver
├── scenes/         # Godot 场景文件 (.tscn)
│   ├── levels/     # Level 01
│   ├── player/     # Player 场景
│   ├── enemy/      # Enemy 场景
│   └── ui/         # UI 场景
├── resources/      # Godot 资源文件 (.tres)
├── tests/          # 单元测试 + 集成测试
├── docs/           # 项目文档
└── spec/           # 版本范围定义
```

## 运行测试

```bash
# 单元 + 集成测试
godot --headless --script run_tests.gd

# 验收验证套件
godot --headless --script tests/validate.gd
```

## 路线图

| 版本 | 内容 | 状态 |
|------|------|------|
| v0.1 | 原型：移动、战斗、敌人AI、3房间关卡 | ✅ 完成 |
| v0.2 | Roguelike 循环：RunManager、能力系统、程序化生成、Boss、元进度 | 📋 计划中 |

详见 [docs/PROGRESS.md](docs/PROGRESS.md)

## 技术栈

- **引擎**: Godot 4.7
- **语言**: GDScript
- **架构**: Autoload 信号总线 + FSM 角色控制
- **物理**: CharacterBody2D
- **碰撞**: Area2D (HitBox/HurtBox)
- **UI**: CanvasLayer + Control

## 开发文档

| 文档 | 说明 |
|------|------|
| [AGENTS.md](AGENTS.md) | 项目总索引 & 角色分工 |
| [docs/PROGRESS.md](docs/PROGRESS.md) | 开发进度总览 |
| [docs/project-map.md](docs/project-map.md) | 目录地图 & 读写规则 |
| [docs/project-goal.md](docs/project-goal.md) | 功能目标 & 系统清单 |
| [docs/development/acceptance-standard.md](docs/development/acceptance-standard.md) | 验收标准 |
| [spec/v0.1-scope.md](spec/v0.1-scope.md) | v0.1 范围 |
| [spec/v0.2-scope.md](spec/v0.2-scope.md) | v0.2 范围 |

## License

MIT
