# v0.1 资产边界

## 概述

v0.1 不使用任何外部图像资源。所有视觉元素通过 Godot 内置节点实现：

- `ColorRect` — 实体占位符
- `CollisionShape2D` — 碰撞体
- `Area2D` — 检测范围/攻击框
- `Label` — UI 文本

## 占位符实现

### 玩家 (Player)

```
Player (CharacterBody2D)
├── Sprite (ColorRect)     # 16x24, #00FFFF
├── CollisionShape2D        # 14x22
├── AttackHitbox (Area2D)
│   └── CollisionShape2D    # 24x16
└── Hurtbox (Area2D)
    └── CollisionShape2D    # 14x22
```

### Shadow Crawler

```
ShadowCrawler (CharacterBody2D)
├── Sprite (ColorRect)      # 20x16, #8B0000
├── CollisionShape2D        # 18x14
├── DetectionRange (Area2D) # 120x120, #FF000040
│   └── CollisionShape2D    # 120x120
├── AttackHitbox (Area2D)
│   └── CollisionShape2D    # 24x16
└── Hurtbox (Area2D)
    └── CollisionShape2D    # 18x14
```

### Wraith

```
Wraith (CharacterBody2D)
├── Sprite (ColorRect)      # 24x20, #800080
├── CollisionShape2D        # 22x18
├── DetectionRange (Area2D) # 160x160, #FF000040
│   └── CollisionShape2D    # 160x160
├── AttackHitbox (Area2D)
│   └── CollisionShape2D    # 20x20
└── Hurtbox (Area2D)
    └── CollisionShape2D    # 22x18
```

## 颜色参考

| 元素 | 十六进制 | RGB |
|------|----------|-----|
| 玩家 | `#00FFFF` | (0, 255, 255) |
| Shadow Crawler | `#8B0000` | (139, 0, 0) |
| Wraith | `#800080` | (128, 0, 128) |
| 地面 Tile | `#333333` | (51, 51, 51) |
| 墙壁 Tile | `#222222` | (34, 34, 34) |
| 攻击框 | `#FFFF0080` | (255, 255, 0, 128) |
| 检测范围 | `#FF000040` | (255, 0, 0, 64) |
| 奖励物品 | `#FFD700` | (255, 215, 0) |

## 迁移计划 (v0.2+)

| 版本 | 资产策略 |
|------|----------|
| v0.1 | ColorRect 占位符 |
| v0.2 | 导入精灵表 (PNG), 替换玩家和敌人 |
| v0.3 | 添加音效/音乐、UI 图标、粒子效果 |
| v1.0 | 完整像素艺术资产、特效、动画 |

### 迁移步骤

1. 创建精灵表 PNG 文件 (16x16 网格)
2. 导入 Godot: 设置 SpriteFrames
3. 创建 AnimationPlayer 动画 (idle, run, jump, attack, hurt, death)
4. 替换 ColorRect 为 AnimatedSprite2D
5. 调整碰撞体以匹配新精灵
6. 删除占位符 ColorRect 节点

## 性能说明

- ColorRect 是轻量级节点，适合原型阶段
- v0.1 不限制节点数量，但保持合理的节点层次
- 每个 < 10 个实体的房间应保持 < 500 节点
- 迁移到精灵表后，注意 atlasing 以减少绘制调用
