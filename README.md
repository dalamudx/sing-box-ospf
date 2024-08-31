# sing-box-ospf
  - 利用github actions自编译
  - 集成ospf(bird2实现)
  - 会尽量修复容器中存在的严重漏洞
  * 注意：1.9.x以上版本在tun模式下如果strict_route为true，会墙掉自身，外部无法访问容器端口
    
## 支持架构
  - `amd64`,`x86`,`arm64v8`,`armv6`,`armv7`,`riscv64`
  * `x86`,`armv6`,`armv7`和`riscv64`为新加架构，使用如果有问题请通提issue回报

## 镜像地址
- https://hub.docker.com/r/dalamudx/sing-box-ospf

## 使用说明
- 修改`/app/bird.conf`第3行`router id x.x.x.x;`中`x.x.x.x`为实际IP地址，如有必要也请修改`interface`、`authentication`和`password`
- 替换`/app/config.json`为你自己的sing-box配置文件，仓库中该配置仅供参考
- 修改`/app/update`脚本中第2、3行下载链接为你要部署的静态路由表链接
- 部署容器时将库中下载的的`app`目录挂载在`/app`，而`supervisor.d`目录挂载在`/etc/supervisor.d`