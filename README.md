# sing-box-ospf
  - 利用github actions自编译[sing-box](https://github.com/SagerNet/sing-box)
  - 定时更新UI，支持[metacubexd](https://github.com/MetaCubeX/metacubexd)和[Yacd-meta](https://github.com/MetaCubeX/Yacd-meta)
  - 集成ospf(bird2实现)
  - 会尽量修复容器中存在的严重漏洞
    
## 支持架构
  - `amd64`,`x86`,`armv6`,`armv7`,`arm64`,`ppc64le`,`riscv64`,`s390x`

## 镜像地址
- https://hub.docker.com/r/dalamudx/sing-box-ospf

## 使用说明
- 本镜像为了能够灵活处理一些个人需求，不会自动更新`app`或`supervisor.d`目录下文件，这意味着如果需要一些新支持的功能，需要手动更新`app`或`supervisor.d`目录下文件跟仓库保持一致
- 基于上面所述更新逻辑，你可以自定义服务和脚本，但随仓库更新`app`或`supervisor.d`目录时，请根据更新历史中的文件变动说明(总是与上一个发布版本相对比)自行`diff`文件内容，以保持本地自定义设置，切勿简单替换，而造成本地配置丢失

项目文件说明
```
.
├── app
│   ├── bird
│   │   ├── bird.conf     #bird配置文件
│   │   ├── routes4.conf  #ipv4静态路由
│   │   └── routes6.conf  #ipv6静态路由
│   ├── cron               #定时任务
│   ├── sing-box
│   │   └── config.json   #sing-box配置文件
│   ├── ui                 #UI更新脚本
│   └── update             #静态路由、GEO文件、UI更新
├── Dockerfile
├── entrypoint.sh
├── README.md
└── supervisor.d
     └── service.ini        #supervisor服务配置文件
```
- 修改`app/bird/bird.conf`第3行`router id x.x.x.x;`中`x.x.x.x`为实际IP地址，如有必要也请修改`interface`、`authentication`和`password`
- 替换`app/sing-box/config.json`为你自己的sing-box配置文件，仓库中该配置仅供参考
- 修改`app/update`脚本中第2、3行下载链接为你要部署的静态路由表链接
- 部署容器时将库中下载的的`app`目录挂载在`/app`，而`supervisor.d`目录挂载在`/etc/supervisor.d`
## 注意：
- 如果你使用旧版本(2024-09-16以前的版本)更新镜像后还需要对以下文件进行更新，保持与仓库中文件内容一致\
  `app/cron`，`app/update`，`app/ui`，`supervisor.d/service.ini`
- 如果想要应用启动后立即广播静态路由，请提前准备`routes4.conf`和`routes6.conf`放到`app/bird`目录下，或者应用启动后，在容器中手动执行`sh /app/update`
- 更新UI功能通过删除本地目录(该目录在sing-box配置文件config.json中有定义`external_ui`，如果没有指定则不会对UI进行更新)，并用`git`拉取[metacubexd](https://github.com/MetaCubeX/metacubexd)和[Yacd-meta](https://github.com/MetaCubeX/Yacd-meta)最新版本
- 调试相关命令\
  `supervisorctl status all` 检查服务运行状态\
  `supervisorctl status bird` 检查bird服务运行状态\
  `supervisorctl restart all` 重启所有服务\
  `supervisorctl restart sing-box` 单独重启sing-box服务
## 更新历史
- 2024-11-19 修复git拉取仓库命令失败时会导致UI丢失的问题，更安全地更新UI\
             文件修改：`app/ui`
- 2024-11-01 配置文件迁移到指定目录下，由原来的`app`目录，分别迁移到`app/bird`和`app/sing-box`\
             文件修改：`app/cron`、`app/ui`、`app/update`、`supervisor.d/service.ini`\
             该更新仅对服务对应的配置文件进行分门别类，无需更新镜像
- 2024-10-22 增加对UI的定时更新，支持[metacubexd](https://github.com/MetaCubeX/metacubexd)和[Yacd-meta](https://github.com/MetaCubeX/Yacd-meta)\
             文件增加：`app/ui`\
             文件修改：`app/cron`
- 2024-10-01 为了部署时作为对照，重新添加静态路由配置样例\
             修复github actions中版本检查和容器meta信息
- 2024-09-16 增加对多平台架构镜像构建支持，优化应用运行逻辑
