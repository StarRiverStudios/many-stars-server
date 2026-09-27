# 基于Debian 13（Trixie）作为基础镜像
FROM debian:trixie

# 镜像基本信息
ARG IMAGE_VERSION="Dev-Image"
LABEL org.opencontainers.image.title="Many Stars MC"
LABEL org.opencontainers.image.description="Project Many Stars Minecraft Universal Docker Image"
LABEL org.opencontainers.image.authors="ManyStars"
LABEL org.opencontainers.image.vendor="Star River Studios"
LABEL org.opencontainers.image.source="https://github.com/StarRiverStudios/many-stars-server"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"

# 设置环境变量
ENV TERM="xterm-256color"
ENV TZ="Asia/Shanghai"
ENV LANG="en_US.utf8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.utf8"
ENV DEBIAN_FRONTEND="noninteractive"
ENV JDK_21="/usr/lib/jvm/zulu21"
ENV JDK_25="/usr/lib/jvm/zulu25"

# 创建用户与工作目录
RUN groupadd --system manystars \
    && useradd --system --gid manystars --create-home --home-dir /home/mc-server mc-server \
    && mkdir -p /srv/mc-server \
    && chown -R mc-server:manystars /srv/mc-server

# 安装系统组件
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources \
    && apt update \
    && apt dist-upgrade -y --no-install-recommends \
    && apt install -y --no-install-recommends locales-all ca-certificates curl gnupg \
    && sed -i 's|^URIs: http://|URIs: https://|' /etc/apt/sources.list.d/debian.sources \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# 安装运行环境
RUN curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" > /etc/apt/sources.list.d/zulu.list \
    && apt update \
    && apt install -y --no-install-recommends zulu21-jdk zulu25-jdk python3 python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# 设置用户和工作目录
USER mc-server
WORKDIR /srv/mc-server