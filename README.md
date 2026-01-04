# 🏓 Pong Game (Assembly)

A minimal and highly optimized **Pong / Air-Hockey–style game** written in **assembly language**,  using a **framebuffer graphics interface** and **joystick-based input system calls**.

Designed to run on the **Montana Mini Computer**.

The project demonstrates **low-level game programming techniques**, focusing on efficient control flow, deterministic behavior, and real-time rendering without high-level abstractions.

---

## ⚙️ Optimization Highlights

- Zero heap allocation
- Zero stack-based game state
- Register-driven logic
- Jump-table–based control flow
- Single framebuffer flush per frame
- Minimal memory access per update cycle

---

## 🧮 Movement & Physics

- Puck movement slope is stored in a **bit-packed format**, minimizing state size
- Direction resolution is performed using a **jump table**, avoiding conditional branching
- X-axis motion is controlled using an **accumulator**, allowing fractional slope handling
- Initial puck position and slope are **randomized at game start**
- Collision response is implemented using **bitwise slope inversion**
- All gameplay logic avoids heap and stack usage, relying on **registers and static data only**

---

## 🎮 Controls


| Input | Action |
|-----|-------|
| Left  | Move paddle left |
| Right | Move paddle right |
| Up    | Resume game |
| Down  | Pause game |
| `S`   | Exit game |

---

## ✨ Author

**Ved Walvekar**

---

Happy hacking 🕹️
