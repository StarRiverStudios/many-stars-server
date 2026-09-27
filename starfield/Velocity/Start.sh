#!/bin/bash

# 设定工作目录
cd "$(dirname "$0")" || exit 1

# 定义基本参数
jvmCore="${JDK_25}/bin/java"
memory="1024M"
jarFile="velocity-server.jar"

# 定义 JVM 参数
jvmArgs=(
    # === JVM 设置 ===
    "-XX:+UnlockExperimentalVMOptions" # 启用实验性功能
    "-Djava.net.preferIPv4Stack=false" # 禁用强制 IPv4，允许使用 IPv6
    "-Djava.net.preferIPv6Addresses=true" # 优先使用 IPv6 地址，确保在 IPv6 网络环境下的兼容性

    # === 垃圾收集器 ===
    "-XX:+UseG1GC" # 使用 G1 垃圾收集器
    "-XX:MaxGCPauseMillis=25" # 设置 GC 停顿时间
    "-XX:G1HeapRegionSize=4M" # G1 堆区域大小，适用于小内存
    "-XX:ParallelGCThreads=2" # GC 并行线程数，适用于多核 CPU
    "-XX:ConcGCThreads=1" # GC 并发线程数，适用于多核 CPU
    "-XX:MaxInlineLevel=15" # 设置方法内联的最大深度，优化性能

    # === 内存与系统稳定性 ===
    "-XX:+AlwaysPreTouch" # 预分配内存，提高启动速度
    "-XX:+UseContainerSupport" # 启用容器内存感知
    "-XX:+DisableExplicitGC" # 禁止显式调用 System.gc()，避免服务器触发 Full GC

    # === 控制台与日志 ===
    "-Dfile.encoding=UTF-8" # 设置文件编码为 UTF-8
    "-Dterminal.ansi=true" # 启用控制台 ANSI 颜色支持，便于日志可读性
    "-Dlog4j2.formatMsgNoLookups=true" # Log4j2 安全参数，防止远程代码执行漏洞

    # === 平台特定优化 ===
    "-Dvelocity.max-known-packs=2048" # Velocity 已知数据包数量上限
    "-Dvelocity.max-plugin-message-payload-size=2097152" # Velocity 插件消息负载上限（单位：字节）
)
authlibArgs=()
agentArgs=()
programArgs=()

# 获取 JDK 版本
jdkVersion="$("${jvmCore}" -version 2>&1 | sed -n 's/.*version "\([^"]*\)".*/\1/p' | head -n 1)"
if [ -z "${jdkVersion}" ]; then
    jdkVersion="未知版本"
fi

# 执行 Java 命令
sleep 0.5
echo "正在启动 Minecraft 服务器..."
sleep 0.5
echo "正在设定基本参数..."
sleep 0.5
echo "已设定 JDK 版本：${jdkVersion}"
sleep 0.5
echo "已设定内存：${memory}"
sleep 0.5
echo "已设定 JAR 核心文件：${jarFile}"
sleep 0.5
echo "正在设定 JVM 参数..."
sleep 0.5
echo "已设定 JVM 参数：${jvmArgs[*]:-无}"
sleep 0.5
echo "已设定外置登录参数：${authlibArgs[*]:-无}"
sleep 0.5
echo "已设定代理参数：${agentArgs[*]:-无}"
sleep 0.5
echo "已设定程序参数：${programArgs[*]:-无}"
sleep 0.5
echo "全部参数设定完成，正在启动..."
exec "${jvmCore}" "-Xmx${memory}" "-Xms${memory}" "${jvmArgs[@]}" "${authlibArgs[@]}" "${agentArgs[@]}" -jar "${jarFile}" "${programArgs[@]}"