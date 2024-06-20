#!/bin/bash

# 设置本地 Git 用户信息
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"

# 通过 GitHub API 获取最新 release 的版本号
RELEASE_TAG=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases | jq -r '.[] | select(.prerelease == false) | .tag_name' | head -n 1)

# 通过 GitHub API 获取 prerelease 的版本号
PRERELEASE_TAG=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases | jq -r '.[] | select(.prerelease == true) | .tag_name' | head -n 1)

OnlineReleaseTag=${RELEASE_TAG}
OnlinePrereleaseTag=${PRERELEASE_TAG}

# 从 DockerHub 中提取版本号
DockerReleaseTag=$(curl -s -X GET https://registry.hub.docker.com/v2/repositories/dalamudx/sing-box-ospf/tags/${OnlineReleaseTag} | jq '.digest')
DockerPrereleaseTag=$(curl -s -X GET https://registry.hub.docker.com/v2/repositories/dalamudx/sing-box-ospf/tags/${OnlinePrereleaseTag} | jq '.digest')

echo "DockerHub Release 版本号: ${DockerReleaseTag}"
echo "DockerHub Prerelease 版本号: ${DockerPrereleaseTag}"
echo "在线 Release 版本号: ${RELEASE_TAG}"
echo "在线 Prerelease 版本号: ${PRERELEASE_TAG}"

# 检查DockerHub版本号和在线版本号是否不同，如果有任何一个版本号不同，则触发更新动作
if [ "${DockerReleaseTag}" != "null" ]
then
   # 设置输出变量以便在后续步骤中使用
   echo "::set-output name=release_version::${RELEASE_TAG}"
   echo ${RELEASE_TAG} > ./ReleaseTag
   git commit -am "Update ReleaseTag ${RELEASE_TAG}"
   git push -v --progress
   echo "::set-output name=status::success"
fi

# 检查DockerHub版本号和在线版本号是否不同，如果有任何一个版本号不同，则触发更新动作
if [ "${DockerPrereleaseTag}" != "null" ]
then
   # 设置输出变量以便在后续步骤中使用
   echo "::set-output name=prerelease_version::${PRERELEASE_TAG}"
   echo ${PRERELEASE_TAG} > ./PreReleaseTag
   git commit -am "Update PreReleaseTag ${PRERELEASE_TAG}"
   git push -v --progress
   echo "::set-output name=pstatus::success"
fi

