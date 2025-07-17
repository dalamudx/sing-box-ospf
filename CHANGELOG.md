# 更新日志 (Changelog)

本文档记录 Sing-Box OSPF 项目的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [2025-07-17]

### 变更
- 新增对UI [zashboard](https://github.com/Zephyruso/zashboard) 的更新支持
- 对 git 的相关操作添加 `--depth 1` 选项以减小体积
- 优化 UI 更新逻辑
- 替换 update 中的代理地址 

### 修改
- 更新 `app/ui` 文件
- 更新 `app/update` 文件

## [2025-05-13]

### 变更
- 由于 DockerHub 限制较多，遂将镜像仓库从 DockerHub 迁移到 GitHub Container Registry，后续不再更新 DockerHub 镜像
- 单独的 CHANGELOG.md 文件用于更好地管理更新历史
- 优化编译选项获取方式、优化 README.md 和 GitHub Actions 工作流文件
- 去除连接数检查功能（ sing-box 自 1.10.7 版本后，vless+reality 协议链接数泄漏问题已修复）

### 删除
- 移除 `app/monitor_conn` 文件

### 修改
- 更新 `app/cron` 文件
- 更新 `app/update` 文件

## [2025-01-06]

### 新增
- 添加网络连接数检查功能，防止 DDoS 误判
- 新增 `app/monitor_conn` 文件

### 优化
- 优化 GitHub Actions 工作流配置

### 修改
- 更新 `app/cron` 文件

## [2024-11-19]

### 修复
- 修复 git 拉取仓库命令失败时会导致 UI 丢失的问题

### 修改
- 更新 `app/ui` 文件

## [2024-11-01]

### 变更
- 配置文件迁移到指定目录下，由原来的 `app` 目录分别迁移到 `app/bird` 和 `app/sing-box`
- 该更新仅对服务对应的配置文件进行分门别类，无需更新镜像

### 修改
- 更新 `app/cron` 文件
- 更新 `app/ui` 文件
- 更新 `app/update` 文件
- 更新 `supervisor.d/service.ini` 文件

## [2024-10-22]

### 新增
- 增加对 UI 的定时更新功能
- 支持 [metacubexd](https://github.com/MetaCubeX/metacubexd) 和 [Yacd-meta](https://github.com/MetaCubeX/Yacd-meta)
- 新增 `app/ui` 文件

### 修改
- 更新 `app/cron` 文件

## [2024-10-01]

### 新增
- 重新添加静态路由配置样例，便于部署时作为对照

### 修复
- 修复 GitHub Actions 中版本检查和容器 meta 信息

## [2024-09-16]

### 新增
- 增加对多平台架构镜像构建支持
  - 支持 `amd64`, `x86`, `armv6`, `armv7`, `arm64`, `ppc64le`, `riscv64`, `s390x`

### 优化
- 优化应用运行逻辑
