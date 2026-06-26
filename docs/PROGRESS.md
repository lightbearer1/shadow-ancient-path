# 暗影古径 — 开发进度总览

**更新日期:** 2026-06-26
**当前版本:** v0.1 (可玩原型)
**总提交数:** 28
**总文件数:** 77

---

## 一、v0.1 已完成功能

### 核心系统
| 系统 | 文件 | 状态 |
|------|------|------|
| EventBus 信号总线 | `scripts/systems/event_bus.gd` | ✅ 8个信号，完整类型标注 |
| GameManager 状态机 | `scripts/systems/game_manager.gd` | ✅ 4状态 (MENU/PLAYING/PAUSED/GAMEOVER) |
| CameraController | `scripts/systems/camera_controller.gd` | ✅ 玩家跟随 + 房间边界 + 瞬切 |

### 玩家系统
| 功能 | 状态 |
|------|------|
| 左右移动 (WASD/方向键) | ✅ |
| 跳跃 + 二段跳 (W/空格) | ✅ jump_velocity=-600 |
| 冲刺 (Shift, 无敌帧) | ✅ |
| 三段连击 (J/鼠标左键) | ✅ 第三击 1.8x 伤害 |
| 8状态 FSM | ✅ IDLE/RUN/JUMP/FALL/DASH/ATTACK/HURT/DEAD |
| PlayerStats 资源配置 | ✅ 11属性，预留 upgrade 系统 |
| 程序化像素精灵 | ✅ PixelSpriteGenerator 6帧动画 |
| 攻击特效 | ✅ 命中框匹配的斩击视觉效果 |
| 相机震动 | ✅ 攻击时 0.08s 微震 |

### 敌人系统
| 敌人 | 状态 |
|------|------|
| BaseEnemy (6状态FSM) | ✅ IDLE/PATROL/CHASE/ATTACK/HURT/DEAD |
| Shadow Crawler (地面近战) | ✅ 30HP, 80speed, 检测200px |
| Wraith (浮空远程) | ✅ 20HP, 60speed, 悬浮动画, 投射物 |
| EnemySpawner (波次) | ✅ Wave资源 + spawn_delay |
| 方向翻转 | ✅ 巡逻/追击/通用 三级修正 |

### 战斗系统
| 功能 | 状态 |
|------|------|
| HitBox/HurtBox 碰撞 | ✅ Area2D + get_overlapping_areas() |
| 友军伤害过滤 | ✅ team 属性检查 |
| 击退 | ✅ knockback_direction + knockback_resistance |
| 伤害计算 | ✅ damage - resistance (最低1) |
| 敌人死亡 | ✅ queue_free + EventBus信号 |

### 关卡系统
| 功能 | 状态 |
|------|------|
| Level 01 (3房间) | ✅ Room0起始/Room1战斗/Room2终点 |
| 平台/墙壁/地面 | ✅ ColorRect 视觉 + StaticBody2D 碰撞 |
| 房间过渡 | ✅ 双向传送 (玩家+相机同步) |
| 敌人生成配置 | ✅ Room1: 2 Crawler / Room2: 1C+1W |

### UI 系统
| 界面 | 状态 |
|------|------|
| 主菜单 | ✅ 暗色背景 + 标题 + 开始/退出 |
| HUD | ✅ HP条 + 分数 + Combo计数器 |
| 暂停菜单 | ✅ 半透明遮罩 + 继续/返回主菜单 |
| 游戏结束 | ✅ 暗红背景 + 分数 + 重新开始/返回 |

### 测试
| 类型 | 数量 |
|------|------|
| 单元测试 | 14 cases (PlayerStats/PlayerController/BaseEnemy/Combat) |
| 集成测试 | 3 cases (GameFlow) |
| 验收套件 | `tests/validate.gd` |
| 测试运行器 | `run_tests.gd` |

---

## 二、操作方式速查

| 动作 | 按键 |
|------|------|
| 移动 | W/A/S/D 或 方向键 |
| 跳跃 | W / 空格 (空中再按=二段跳) |
| 冲刺 | Shift |
| 攻击 | J / 鼠标左键 |
| 暂停 | Esc |

---

## 三、已知限制 (v0.1)

| 项目 | 优先级 | 说明 |
|------|--------|------|
| 精灵图为程序化生成 | P2 | 待替换为实际像素美术资源 |
| 关卡使用 StaticBody2D | P2 | 待迁移到 TileMap (v0.2 前置) |
| 无音效/音乐 | P2 | |
| 暂停菜单无设置选项 | P3 | |

---

## 四、v0.2 规划

### 新增系统

```
v0.2: Roguelike 核心循环
├── RunManager (Autoload)      运行生命周期 + 房间推进
├── AbilitySystem               6+ 能力, 3选1, 堆叠
├── ProceduralGeneration        5+ 房间模板, 程序化布局
├── Bone Archer                 远程弓箭手
├── Slime                       分裂史莱姆
├── Shadow Lord Boss            2阶段 Boss 战
├── MetaProgression             灵魂货币 + 永久解锁
└── RunStats                    运行统计 + 摘要界面
```

### 预估工作量: ~13 人天

| 阶段 | 内容 | 预估 |
|------|------|------|
| A | RunManager + 运行结构 | 1天 |
| B | AbilitySystem (6+能力) | 2天 |
| C | 程序化房间生成 (5模板) | 3天 |
| D | Bone Archer + Slime | 1.5天 |
| E | Shadow Lord Boss (2阶段) | 2天 |
| F | MetaProgression | 1.5天 |
| G | RunStats + 摘要界面 | 1天 |
| H | 测试 + 验收 | 1天 |

### 新增文件预估: ~25 文件

```
scripts/
├── systems/run_manager.gd
├── abilities/ (8 files)
├── enemy/bone_archer.gd, slime.gd
├── boss/shadow_lord.gd, boss_health_bar.gd
├── generation/ (3 files)
├── meta/meta_progression.gd
├── stats/run_stats.gd
└── ui/ (4 new files)
```

---

## 五、文档索引

| 文档 | 路径 |
|------|------|
| 项目总索引 | `AGENTS.md` |
| 开发进度 (本文) | `docs/PROGRESS.md` |
| 目录地图 | `docs/project-map.md` |
| 功能目标 | `docs/project-goal.md` |
| 验收标准 | `docs/development/acceptance-standard.md` |
| v0.1 范围 | `spec/v0.1-scope.md` |
| v0.2 范围 | `spec/v0.2-scope.md` |
| 完整项目计划 | `docs/superpowers/plans/2026-06-26-shadow-ancient-path.md` |
| P0 修复计划 | `docs/superpowers/plans/v0.1-p0-fixes.md` |
| P1 完善计划 | `docs/superpowers/plans/v0.1-polish.md` |
| SDD 进度账本 | `.superpowers/sdd/progress.md` |
