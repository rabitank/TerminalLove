# TerminalLove · 对终端的爱

> 一款运行在终端中的像素风视觉小说，基于 [TermAVG](https://github.com/rabitank/TermAVG) 引擎开发。

## 简介

在大学时就一直想在终端上运行视觉小说。辞职之后，我用刚学的 Rust 写下了这款游戏——一个沉迷互联网媒体内容的高中生发现真相后获得幸福的短篇科幻故事。

它包含了我对职业和生活的一些反思，希望和你对上电波。

同样支持 GUI 版本和 Linux 平台。仍在开发中，部分 CG 和画廊使用了占位符，但不影响核心故事体验 :)

开源游戏，所有资源及代码均在仓库中：  

| 仓库 | 地址 |
|------|------|
| 游戏 | [TerminalLove](https://github.com/rabitank/TerminalLove) |
| 引擎 | [TermAVG](https://github.com/rabitank/TermAVG) |

## 运行方式

- **Linux** → 下载 `TerminalLove-v*-linux.zip`
- **Windows** → 下载 `TerminalLove-v*.zip`（不带 `-linux` 的）

解压后：

| 你 | 推荐 |
|----|------|
| 会用终端 | `./tmj`(解压的文件夹中打开终端输入)或 `./run.bat`（Win11，需 Windows Terminal） |
| 不想折腾 | 直接打开 `tmj_gui` / `tmj_gui.exe` |

> `run.bat` 通过 `wt` 命令唤起 Windows Terminal，推荐 Win11 用户使用。不确定的话直接用 GUI 版。

## 快捷键

| 按键 | 功能 |
|------|------|
| Enter / 空格 / 点击 / A | 推进对话 |
| 长按 A | 快速跳过 |
| Esc / q | 返回菜单 |
| s | 保存 |
| l | 读取 |
| c | 设置 |
| ↑ | 历史 |

## 系统要求

| | 终端模式 | GUI 模式 |
|---|---|---|
| Windows (x86_64) | ✅ | ✅ |
| Linux (x86_64) | ✅ | ✅ |

GUI 模式需要 Vulkan 驱动（需要显卡,Linux 用户请确认 `vulkan-icd-loader` 已安装,以及其他依赖,一般桌面环境这些依赖都存在）。

## 下载

- [GitHub Releases](https://github.com/rabitank/TerminalLove/releases)
- [itch.io](https://forstar.itch.io/terminallove)

## 打赏

如果喜欢这款游戏，愿意赞助一下，请扫码支持作者 T\_T

<img src="alipay.jpg" width="240" alt="支付宝收款码">
