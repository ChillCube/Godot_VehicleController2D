# Godot_VehicleController2D API Reference
Generated: 2026-03-09

A character controller for vehicles in 2D (top down)

## Class: VehicleBody2D
**Inherits:** [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)


### ⚙️ Inspector Variables (Exported)
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **speed** | `Variant` | `250.0` | The base force applied when moving forward. |
| **max_speed** | `Variant` | `1000.0` | The absolute maximum speed the vehicle can reach. |
| **acceleration** | `Variant` | `0.1` | How quickly the vehicle reaches max speed. |
| **deceleration** | `Variant` | `0.05` | How quickly the vehicle slows down. |
| **enable_boosting** | `Variant` | `true` | If true, the vehicle can use the boost maneuver. |
| **boost_force** | `Variant` | `1500.0` | The speed added instantly when boosting. |
| **boost_max_speed_limit** | `Variant` | `2500.0` | The temporary speed cap during boost. |
| **boost_duration** | `Variant` | `0.4` | How long the boost speed lasts in seconds. |
| **boost_cooldown** | `Variant` | `2.0` | Time in seconds before you can boost again. |
| **input_boost** | `Variant` | `"boost"` | Input action name for boosting. |
| **input_left** | `Variant` | `"ui_left"` | Input action name for turning left. |
| **input_right** | `Variant` | `"ui_right"` | Input action name for turning right. |
| **input_backward** | `Variant` | `"ui_down"` | Input action name for reversing/braking. |
| **input_forward** | `Variant` | `"ui_up"` | Input action name for moving forward. |

### 🔔 Signals
| Signal | Arguments | Description |
| :--- | :--- | :--- |
| **velocity_changed** | `current_velocity : Vector2` |  Emitted every frame the vehicle is moving. |
| **movement_started** | - |  Emitted when the vehicle starts moving from a standstill. |
| **movement_stopped** | - |  Emitted when the vehicle comes to a complete stop. |
| **boost_started** | `direction : Vector2` |  Emitted when the boost is activated. |
| **boost_ended** | - |  Emitted when the boost effect wears off. |

---

