# 基于以下开源项目

- [p2p-media-loader](https://github.com/Novage/p2p-media-loader) | [Forked](https://github.com/HV-LIVE/p2p-media-loader)

# 同步构建结果

- 编译 [p2p-media-loader](https://github.com/HV-LIVE/p2p-media-loader) 项目中的 `p2p-media-loader-demo` 子项目，从源项目同步以下文件到本项目中：

  - 将源项目 `p2p-media-loader-demo/node_modules/p2p-media-loader-core/build/p2p-media-loader-core.min.js` 同步到本项目 `p2p-media-loader-demo` 目录中

  - 将源项目 `p2p-media-loader-demo/node_modules/p2p-media-loader-hlsjs/build/p2p-media-loader-hlsjs.min.js` 同步到本项目 `p2p-media-loader-demo` 目录中

  - 将源项目 `p2p-media-loader-demo/node_modules/p2p-media-loader-shaka/build/p2p-media-loader-shaka.min.js` 同步到本项目 `p2p-media-loader-demo` 目录中

  - 将源项目 `p2p-media-loader-demo/p2p-graph.js` 同步到本项目 `p2p-media-loader-demo` 目录中

  - 将源项目 `p2p-media-loader-demo/index.html` 同步到本项目 `launcher/template/var/www/html` 目录中

    - 不要直接覆盖，需要手动对比合并，所有需要保留的内容都用 `HV_MODIFY` 注释标记

- 当前同步的分支: [master](https://github.com/HV-LIVE/p2p-media-loader/tree/master)

- 当前同步的提交: [65bfee0](https://github.com/HV-LIVE/p2p-media-loader/commit/65bfee0a54b4da9b6ae1699038e069698d265945)

# 编译镜像

```sh
docker build -t hvlive/p2p-media-loader-demo:latest .
```

# 部署镜像

编辑配置文件 `{host_config_path}/config.ini`

写入以下内容:

```ini
[ENV_LIST]
# Tracker 服务列表
P2P_TRACKERS =
    {wt_tracker_url}

# ICE 服务列表
P2P_ICE_SERVERS =
    stun:stun.l.google.com:19302
    stun:global.stun.twilio.com:3478
```

启动容器

```sh
# HTTP
docker run -d --restart=unless-stopped \
    --name p2p-media-loader-demo \
    -p {host_port}:80 \
    -v {host_config_path}/config.ini:/etc/launcher/config.ini \
    hvlive/p2p-media-loader-demo:latest

# HTTPS
docker run -d --restart=unless-stopped \
    --name p2p-media-loader-demo \
    -p {host_port}:80 \
    -v {host_config_path}/config.ini:/etc/launcher/config.ini \
    -v {host_cert_path}:{container_cert_path} \
    -e HV_HTTPS_CERT={container_cert_path}/{pem_file} \
    -e HV_HTTPS_CERT_KEY={container_cert_path}/{key_file} \
    hvlive/p2p-media-loader-demo:latest
```

# 配置列表

| 环境变量           | 默认值 | 说明                                                 |
| ------------------ | ------ | ---------------------------------------------------- |
| HV_HTTP_PORT       | 80     | 容器内的 HTTP 端口（如果指定了证书就是 HTTPS 端口）  |
| HV_HTTPS_CERT      |        | 容器内的证书 pem 文件路径（指定后会开启 HTTPS 协议） |
| HV_HTTPS_CERT_KEY  |        | 容器内的证书 key 文件路径（指定后会开启 HTTPS 协议） |
| HV_P2P_TRACKERS    |        | P2P Tracker 服务列表 （必须指定）                    |
| HV_P2P_ICE_SERVERS |        | P2P ICE 服务列表 （必须指定）                        |
