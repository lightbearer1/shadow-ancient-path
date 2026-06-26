# 资产目录约定

## 目录结构

```
assets/
├── sprites/          # 精灵图 (PNG)
│   ├── player/       # 玩家精灵
│   ├── enemies/      # 敌人精灵
│   ├── environment/  # 环境/装饰精灵
│   └── ui/           # UI 元素精灵
├── fonts/            # 字体文件 (TTF/OTF)
├── sounds/           # 音效 (OGG/WAV)
│   ├── sfx/          # 音效
│   └── music/        # 背景音乐
└── tilesets/         # TileSet 资源
```

## 命名规则

| 类型 | 格式 | 示例 |
|------|------|------|
| 精灵 | `<entity>_<action>_<frame>.png` | `player_run_01.png` |
| 精灵表 | `<entity>_<action>_spritesheet.png` | `player_run_spritesheet.png` |
| TileSet | `<theme>_tileset.png` | `dungeon_tileset.png` |
| 音效 | `<source>_<action>.ogg` | `player_attack.ogg` |
| 音乐 | `<theme>_<mood>.ogg` | `temple_ambient.ogg` |
| 字体 | `<name>-<style>.ttf` | `MedievalSharp-Regular.ttf` |

## v0.1 占位符规范

v0.1 使用 Godot 内置 `ColorRect` 和 `CollisionShape2D` 节点作为占位符，不使用外部图片资源。

### 占位符颜色

| 元素 | 颜色 | 十六进制 |
|------|------|----------|
| 玩家 | 青色 | `#00FFFF` |
| Shadow Crawler | 深红色 | `#8B0000` |
| Wraith | 紫色 | `#800080` |
| 地面/平台 | 深灰色 | `#333333` |
| 墙壁 | 深灰色 | `#222222` |
| 攻击命中框 | 黄色 (半透明) | `#FFFF0080` |
| 敌人追击范围 | 红色 (半透明) | `#FF000040` |
| UI 背景 | 半透明黑色 | `#000000CC` |
| 按钮 | 深灰色 | `#444444` |

### 占位符尺寸限制

| 元素 | 尺寸 |
|------|------|
| 玩家 | 16x24 px |
| Shadow Crawler | 20x16 px |
| Wraith | 24x20 px |
| 攻击框 | 24x16 px |
| Tile | 16x16 px |

## v0.1 临时资产

v0.1 所有视觉资产通过 `v0.1/assets/` 中的 Godot 场景/脚本实现。
引擎外资产 (PNG/OGG) 将在 v0.2+ 引入。

## 将来迁移 (v0.2+)

- 占位符被实际精灵替换
- 精灵表导入 Godot 并使用 SpriteFrames
- 添加音效和音乐
- 添加字体文件
- 像素艺术风格保持一致: 16x16 基础网格
