# 暗影古径 — 项目目标

## 概述

《暗影古径》是一款2D黑暗奇幻动作平台游戏，融合Roguelike元素。玩家将穿越古老的黑暗路径，与敌人战斗，获得能力，并在每次尝试中变得更加致命。

---

## v0.1 — 原型 (已完成)

### 交付物

| 系统 | 交付物 |
|------|--------|
| Player | 移动、跳跃、冲刺、3连击组合 |
| Enemy | Shadow Crawler (巡逻/追击/攻击/死亡), Wraith (巡逻/追击/攻击/死亡) |
| Level | 第01关 (3个房间串联) |
| Combat | 命中检测、伤害计算、连击计时器、敌人击杀 |
| UI | 主菜单、HUD (生命值/连击计数)、游戏结束画面 |

### 信号流图

```
PlayerController --信号(hit, dash_started, dash_ended)--> EventBus
EventBus --信号(player_hit)--> CombatSystem
CombatSystem --信号(enemy_damaged, enemy_killed)--> EventBus
EventBus --信号(health_changed, combo_updated)--> GameUI
BaseEnemy --信号(state_changed, enemy_attacked, enemy_died)--> EventBus
EventBus --信号(player_damaged)--> GameManager
GameManager --信号(game_over, room_cleared)--> EventBus
EventBus --信号(game_state_changed)--> GameUI
```

### 系统清单

- [x] PlayerController (移动、跳跃、冲刺、组合攻击)
- [x] PlayerStats (生命值、耐力值、状态)
- [x] BaseEnemy / ShadowCrawler / Wraith (AI状态机)
- [x] CombatSystem (命中检测、伤害计算、连击)
- [x] EventBus (全局信号总线)
- [x] GameManager (游戏状态管理)
- [x] GameUI (主菜单、HUD、游戏结束)
- [x] Level01 (3个房间串联)

---

## v0.2 — Roguelike循环 (计划中)

### 交付物

| 系统 | 交付物 |
|------|--------|
| Run Manager | 运行生命周期管理、房间推进 |
| Ability System | 通关后3选1能力、能力堆叠 |
| Procedural Generation | 程序化房间生成器 |
| New Enemies | Bone Archer, Slime |
| Boss | Shadow Lord (2阶段战斗) |
| Meta-progression | 灵魂货币、解锁加成 |
| Run Statistics | 统计追踪、运行结束摘要 |

### 系统清单

- [ ] RunManager (运行生命周期)
- [ ] AbilitySystem (能力选择与堆叠)
- [ ] ProceduralRoomGenerator (房间布局)
- [ ] RoomRegistry (房间模板库)
- [ ] BoneArcher (远程敌人)
- [ ] Slime (分裂敌人)
- [ ] ShadowLordBoss (2阶段AI)
- [ ] MetaProgression (灵魂货币)
- [ ] RunStats (运行统计)
- [ ] AbilityUI (能力选择界面)

---

## 技术栈

| 项目 | 版本 |
|------|------|
| Godot | 4.7 |
| 语言 | GDScript |
| 物理 | CharacterBody2D |
| UI | CanvasLayer + Control |
| 信号 | EventBus 单例 |
| 关卡 | 手工艺编辑 (v0.1) / 程序生成 (v0.2) |

## 开发原则

1. 先用原型验证核心玩法 (v0.1)
2. 再实现Roguelike循环 (v0.2)
3. 最后进行内容扩展与润色 (v0.3+)
4. 测试覆盖率始终 >= 80%
5. 所有状态转换必须有测试覆盖
