# sing-box-ospf
  - 利用github actions自编译
  - 集成ospf(bird2实现)
  - 会尽量修复容器中存在的严重漏洞
    
## 支持架构
  - `amd64`,`x86`,`armv6`,`armv7`,`arm64`,`ppc64le`,`riscv64`,`s390x`

## 镜像地址
- https://hub.docker.com/r/dalamudx/sing-box-ospf

## 使用说明
- 修改`app/bird.conf`第3行`router id x.x.x.x;`中`x.x.x.x`为实际IP地址，如有必要也请修改`interface`、`authentication`和`password`
- 替换`app/config.json`为你自己的sing-box配置文件，仓库中该配置仅供参考
- 修改`app/update`脚本中第2、3行下载链接为你要部署的静态路由表链接
- 部署容器时将库中下载的的`app`目录挂载在`/app`，而`supervisor.d`目录挂载在`/etc/supervisor.d`
## 注意：
- 如果你使用旧版本更新镜像后还需要对以下文件进行更新，保持与仓库中文件内容一致\
  `app/cron`，`app/update`，`supervisor.d/service.ini`
- 如果想要应用启动后立即广播静态路由，请提前准备`routes4.conf`和`routes6.conf`放到`app/`目录下，或者应用启动后，在容器中手动执行`sh /app/update`
- 调试相关命令\
  `supervisorctl status all` 检查服务运行状态
## 更新历史
- 2024-09-16 增加对多平台架构镜像构建支持，优化应用运行逻辑
