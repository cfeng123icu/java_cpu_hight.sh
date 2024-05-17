#!/bin/bash

# 找到 CPU 使用率最高的 Java 进程信息
p_info=$(ps -Leo pid,tid,%cpu,cmd | grep -E 'java|.jar|-jar' | grep -v grep | grep -v "sh" | sort -k3 -r -n | awk 'NR==1')
# 打印 java 进程信息
echo "java 进程信息："
echo "============================================"
p_head_info=$(ps -Leo pid,tid,%cpu,cmd | awk 'NR==1')
echo "$p_head_info"
echo "$p_info"
echo "============================================"
# 判断是否为空
if [ -z "$p_info" ]; then
  echo "未找到 Java 进程信息"
  exit 1
fi
# 获取 CPU 使用率最高的 Java 进程ID 和 线程ID
pid=$(echo "$p_info" | awk '{print $1}')
tid=$(echo "$p_info" | awk '{print $2}')
# 打印 Java 进程ID 和 线程ID
echo "Java 进程 ID：$pid"
echo "Java 线程 ID：$tid"
# Java 线程 ID 转 16进制
tid_hex=$(printf "%x" "$tid")
# 打印 Java 线程 ID 16进制
echo "Java 线程 ID 16进制：$tid_hex"
log_file=jstack_cpu_"$pid"_"$tid"_"$(date "+%Y-%m-%d_%H:%M:%S")".log
jstack "$pid" | grep -A 100 "nid=0x$tid_hex" > "$log_file"
echo "Java 线程堆栈信息已导出到：$log_file"
