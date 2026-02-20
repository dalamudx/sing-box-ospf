<div align="center">

# 🚀 Sing-Box-OSPF

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dalamudx/sing-box-ospf/AutoBuild.yml?style=flat-square&logo=github)](https://github.com/dalamudx/sing-box-ospf/actions)
[![GitHub release](https://img.shields.io/github/v/release/dalamudx/sing-box-ospf?style=flat-square&label=sing-box-ospf&color=blue)](https://github.com/dalamudx/sing-box-ospf/releases)
[![Docker Pulls](https://img.shields.io/badge/Container%20Registry-GHCR-blue?style=flat-square&logo=docker)](https://github.com/dalamudx/sing-box-ospf/pkgs/container/sing-box-ospf)

_基于 [sing-box](https://github.com/SagerNet/sing-box) 的多功能容器，集成 OSPF 路由和自动更新功能_

</div>

## ✨ 特性

- 🔄 利用 GitHub Actions 自动编译最新版 [sing-box](https://github.com/SagerNet/sing-box)
- 🖥️ 定时更新 UI，支持 [metacubexd](https://github.com/MetaCubeX/metacubexd) 、[zashboard](https://github.com/Zephyruso/zashboard) 和 [Yacd-meta](https://github.com/MetaCubeX/Yacd-meta)
- 🌐 集成 OSPF 路由功能 (基于 bird2 实现)
- 🛡️ 定期修复容器中存在的严重漏洞

## 🏗️ 支持架构

<table>
  <tr>
    <td align="center">amd64</td>
    <td align="center">x86</td>
    <td align="center">armv6</td>
    <td align="center">armv7</td>
    <td align="center">arm64</td>
    <td align="center">ppc64le</td>
    <td align="center">riscv64</td>
    <td align="center">s390x</td>
  </tr>
  <tr>
    <td align="center">✅</td>
    <td align="center">✅</td>
    <td align="center">✅</td>
    <td align="center">✅</td>
    <td align="center">✅</td>
    <td align="center">✅</td>
    <td align="center">✅</td>
    <td align="center">✅</td>
  </tr>
</table>

## 📦 镜像地址

- **GitHub Container Registry**: `ghcr.io/dalamudx/sing-box-ospf`
- **DockerHub** (自2025-05-13已弃用): `docker.io/dalamudx/sing-box-ospf`

## 🚀 快速开始

### 拉取镜像

```bash
# 拉取最新版本
docker pull ghcr.io/dalamudx/sing-box-ospf:latest

# 拉取特定版本
docker pull ghcr.io/dalamudx/sing-box-ospf:v1.8.14
```

### 运行容器

```bash
docker run -d \
  --name sing-box \
  --restart unless-stopped \
  -v /path/to/app:/app \
  -v /path/to/supervisor.d:/etc/supervisor.d \
  -p 9090:9090 \
  ghcr.io/dalamudx/sing-box-ospf:latest
```

## 📁 项目结构

```
.
├── app
│   ├── bird
│   │   ├── bird.conf     # bird配置文件
│   │   ├── routes4.conf  # ipv4路由表
│   │   └── routes6.conf  # ipv6路由表
│   ├── cron              # 定时任务
│   ├── sing-box
│   │   └── config.json   # sing-box配置文件
│   ├── ui                # UI更新脚本
│   └── update            # 路由、GEO文件、UI更新
├── Dockerfile
├── entrypoint.sh
├── README.md
└── supervisor.d
     └── service.ini      # supervisor服务配置文件
```

## ⚙️ 配置说明

1. **环境变量配置**:
   - **核心网络与 OSPF 配置**:
     - `BIRD_INTERFACE` - Bird OSPF 监听和广播网络路由的网卡接口。
     - `BIRD_ROUTER_ID` - OSPF Router ID，通常需修改为所在宿主机或物理网络的实际 IP 地址。
     - `BIRD_PASSWD` - OSPF v2/v3 的认证密码。
     - `TUN_DEVICE` - 显式指定 sing-box 的 TUN 网卡名称（如 `tun0`, `sing-tun`）。
   - **下载与更新代理设置**:
     - `GH_PROXY` - GitHub 镜像加速代理，用于路由表和 Web UI 拉取。
     - `GEO_PROXY` - Geo 数据库代理，用于加速下载 `geoip.db` 等规则集。

2. **Bird 配置**:
   - 使用模板生成，核心参数可通过上述环境变量配置。
   - 若您进行深度自定义，可直接修改 `app/bird/bird.conf`（修改后需注意环境变量的覆盖逻辑或移除模板生成步骤）。
   - 如有其他需求，请自行修改 `app/bird/bird.template`，不要修改 `app/bird/bird.conf`。

3. **Sing-Box 配置**:
   - 替换 `app/sing-box/config.json` 为你自己的配置文件。

4. **Bird路由**:
   - 修改 `app/update` 脚本中第2、3行下载链接为你要部署的静态路由表链接

5. **部署方式**:
   - 将 `app` 目录挂载在容器的 `/app` 路径
   - 将 `supervisor.d` 目录挂载在容器的 `/etc/supervisor.d` 路径

## ⚠️ 注意事项

- **自定义配置保护**:
  - 本镜像不会自动更新 `app` 或 `supervisor.d` 目录下文件
  - 如需新功能，请手动更新相关文件以与仓库保持一致
  - 更新时请自行 `diff` 文件内容，保持本地自定义设置

- **ROUTEROS**:
  - 如果你使用 RouterOS 内置的容器服务，在调试时请注意需要手动 `source /etc/profile` 才会显示正确的环境变量值，否则使用 `env`、`printenv` 等命令查看所有环境变量均为默认值，会花大量时间在该问题上，这是因为目前(版本 7.21.3)为止，使用 RouterOS 的类似命令 `/container shell 0` 进入容器不会自动加载 profile 导致。

- **旧版本升级**:
  - 如使用 2024-09-16 以前的版本，更新镜像后需更新以下文件:
    `app/cron`，`app/update`，`app/ui`，`supervisor.d/service.ini`

- **路由表配置**:
  - 如需应用启动后立即广播路由，请提前准备 `routes4.conf` 和 `routes6.conf` 放到 `app/bird` 目录
  - 或在容器启动后手动执行 `sh /app/update`

- **UI 更新机制**:
  - 更新 UI 功能通过删除本地目录并用 `git` 拉取最新版本实现
  - 该目录在 sing-box 配置文件 config.json 中由 `external_ui` 定义
  - 如未指定则不会对 UI 进行更新

## 🔧 调试命令

```bash
# 检查所有服务运行状态
supervisorctl status all

# 检查 bird 服务运行状态
supervisorctl status bird

# 重启所有服务
supervisorctl restart all

# 单独重启 sing-box 服务
supervisorctl restart sing-box
```

## 📝 更新历史

查看完整的[更新日志](CHANGELOG.md)了解详细的版本变更历史。