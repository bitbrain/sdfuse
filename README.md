![logo](docs/assets/logo.svg)

[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Godot Engine](https://img.shields.io/badge/Godot-4.x-blue.svg)](https://godotengine.org/) [![](https://img.shields.io/badge/%20%F0%9F%94%A6%20addon-sdfuse-blueviolet)](https://github.com/bitbrain/sdfuse)

---

**SDFuse is a powerful addon for Godot Engine that enables infinite 2D lighting with realistic shadows using Signed Distance Fields (SDF).** Create stunning lighting effects with soft and hard shadows, directional light fans, and camera-aware rendering that scales beautifully with your game world.

Using advanced SDF-based ray marching techniques, SDFuse delivers high-quality lighting that responds dynamically to your scene geometry, making it perfect for atmospheric 2D games, top-down adventures, and any project requiring sophisticated lighting effects.

# 🔦 Features

### 🎯 Node-based lighting system - seamlessly integrate lights into your scene tree

Add lights anywhere in your scene hierarchy with the `SDFLight` node. Each light automatically registers with the lighting manager and contributes to the global illumination.

### 🌟 Advanced SDF rendering - realistic shadows with soft and hard edges

Leverages Signed Distance Fields for accurate shadow casting with configurable soft and hard shadow transitions based on light-to-occluder distance.

### 🎨 Flexible light types - omnidirectional and directional lighting

Support for both full-circle lights and directional light fans with configurable angles, perfect for flashlights, spotlights, and area lighting.

### 📷 Camera-aware rendering - lighting that follows your viewport

Automatic camera integration ensures lighting remains consistent across zoom levels and rotations, maintaining visual quality at any scale.

### ⚡ High performance - up to 100 concurrent lights

Optimized shader implementation supports up to 100 simultaneous lights with efficient GPU-based ray marching for smooth performance.

### 🎛️ Real-time configuration - adjust lighting properties on the fly

All light properties (color, range, angle, intensity) can be modified at runtime through exported variables in the editor or via code.

# 📦 Installation

1. [Download Latest Release](https://github.com/bitbrain/sdfuse/releases/latest)
2. Unpack the `addons/sdfuse` folder into your `/addons` folder within the Godot project

# Getting started

SDFuse provides a simple node-based approach to 2D lighting. The system consists of two main components: lights (`SDFLight`) and a rendering canvas (`SDFCanvas`).

## Basic Setup

1. **Add an SDFCanvas to your scene** - This acts as the rendering surface for lighting effects:

```gdscript
# Add SDFCanvas node to your scene
# It will automatically register with the lighting manager
```

2. **Add SDFLight nodes** - Place lights anywhere in your scene:

```gdscript
# Create a basic omnidirectional light
var light = SDFLight.new()
light.range = 500
light.color = Color.WHITE
add_child(light)
```

3. **Configure light properties**:

```gdscript
# Omnidirectional light (full circle)
light.fan_angle = TAU  # Full circle

# Directional light (spotlight/flashlight)
light.angle = 0.0      # Direction in radians
light.fan_angle = PI * 0.25  # 45-degree cone

# Adjust appearance
light.color = Color.CYAN
light.range = 800
```

## Example Scene Setup

```gdscript
extends Node2D

func _ready():
    # Add the lighting canvas
    var canvas = SDFCanvas.new()
    canvas.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(canvas)
    
    # Add a flashlight that follows the player
    var flashlight = SDFLight.new()
    flashlight.range = 600
    flashlight.color = Color.YELLOW
    flashlight.angle = 0.0
    flashlight.fan_angle = PI * 0.3  # 54-degree cone
    player.add_child(flashlight)
    
    # Add ambient room lighting
    var room_light = SDFLight.new()
    room_light.position = Vector2(400, 300)
    room_light.range = 800
    room_light.color = Color(0.8, 0.9, 1.0, 0.6)  # Cool ambient
    room_light.fan_angle = TAU  # Omnidirectional
    add_child(room_light)
```

# 📚 API Reference

## SDFLight

The main light component that can be added to any node in your scene.

### Properties

- `range: int` - Light range in pixels (default: 500)
- `color: Color` - Light color and intensity (default: Color.WHITE)
- `angle: float` - Light direction in radians (default: 0.0)
- `fan_angle: float` - Light cone angle in radians. Use TAU for omnidirectional (default: TAU)

### Usage

```gdscript
# Create a red spotlight pointing right
var spotlight = SDFLight.new()
spotlight.range = 400
spotlight.color = Color.RED
spotlight.angle = 0.0  # Point right
spotlight.fan_angle = PI * 0.25  # 45-degree cone
```

## SDFCanvas

The rendering surface that displays lighting effects. Must be present in the scene for lighting to work.

### Usage

```gdscript
# Add to scene as a full-screen overlay
var canvas = SDFCanvas.new()
canvas.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
add_child(canvas)
```

## SDFuseLightingManager (Autoload)

Global singleton that manages all lights and rendering. Automatically available when the addon is enabled.

### Methods

- `register_light(data: Dictionary) -> String` - Register a light (used internally)
- `unregister_light(id: String)` - Remove a light (used internally)
- `register_canvas(canvas: SDFCanvas)` - Register rendering canvas (used internally)
- `unregister_canvas(canvas: SDFCanvas)` - Remove rendering canvas (used internally)

# 🎮 Advanced Usage

## Dynamic Lighting

```gdscript
# Animate light properties
func _process(delta):
    # Flickering torch effect
    torch_light.color.a = 0.8 + sin(Time.get_time() * 10.0) * 0.2
    
    # Rotating searchlight
    searchlight.angle += delta * 0.5
    
    # Pulsing light range
    pulse_light.range = 300 + sin(Time.get_time() * 2.0) * 100
```

## Multiple Light Types

```gdscript
# Flashlight that follows mouse
func _input(event):
    if event is InputEventMouseMotion:
        var direction = (get_global_mouse_position() - global_position).angle()
        flashlight.angle = direction

# Day/night cycle
func set_time_of_day(hour: float):
    var intensity = clamp(sin((hour - 6.0) * PI / 12.0), 0.0, 1.0)
    ambient_light.color.a = intensity
```

# 🔧 Technical Details

## Shader Configuration

The SDF shader supports several constants that can be modified for different visual effects:

- `LIGHT_N: 100` - Maximum number of concurrent lights
- `STEP_MAX: 32` - Ray marching steps (higher = more accurate, slower)
- `SOFT_LIMIT: 10.0` - Distance threshold for soft shadows
- `HARD_LIMIT: 5.0` - Distance threshold for hard shadows
- `ANG_EDGE: 0.1` - Soft edge width for light fans
- `WALL_EDGE: 8.0` - Light edge width on walls

## Performance Considerations

- Each light uses GPU resources; monitor performance with many lights
- SDF resolution affects shadow quality and performance
- Ray marching steps can be adjusted for quality vs. performance trade-offs

# 🥰 Credits

- Original SDF implementation by [greycheeked](https://github.com/greycheeked/SDF-2D-Lighting)
- Refined and packaged for production use by [bitbrain](https://github.com/bitbrain)
- Built for Godot Engine 4.x

# 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.