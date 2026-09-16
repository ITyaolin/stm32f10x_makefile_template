# STM32F10x Makefile Template

基于 STM32F103C8T6 (Blue Pill) 的 Makefile 工程模板，使用 STM32 Standard Peripheral Library。

## 环境要求

- arm-none-eabi-gcc 工具链
- [stlink](https://github.com/texane/stlink) — 烧录工具
- [OpenOCD](https://openocd.org/) — 调试服务器
- VS Code 扩展：[Cortex-Debug](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)、[C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)

## 使用

```bash
make            # 编译（产物在 output/ 目录）
make clean      # 清理 output/
make flash      # 编译 + 烧录到 MCU
make erase      # 擦除 Flash
```

## 调试

### VS Code

1. 安装 Cortex-Debug 和 C/C++ 扩展
2. `Ctrl+Shift+B` 编译
3. `F5` 选择 **Debug (OpenOCD)** 启动调试

### 命令行

```bash
# 终端 1：启动 OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f1x.cfg

# 终端 2：连接 GDB
arm-none-eabi-gdb output/stm32f10x_makefile_template.elf
(gdb) target extended-remote :3333
(gdb) monitor reset halt
(gdb) load
(gdb) continue
```

## 项目结构

```
├── Makefile                 # 主 Makefile
├── makefile_std_lib.mk      # STM32 标准库配置
├── build.sh                 # 一键编译 + 烧录脚本
├── stm32_flash.ld           # 链接脚本
├── user/
│   └── main.c               # 用户代码（LED 闪烁）
├── stm32f10x_lib/           # STM32 标准外设库 + CMSIS
└── output/                  # 编译产物（.o .elf .hex .bin .map .lst）
```

## 硬件

- MCU: STM32F103C8T6 (Cortex-M3, 64K Flash, 20K RAM)
- 板载 LED: PC13 (低电平点亮)
