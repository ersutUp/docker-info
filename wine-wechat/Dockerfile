FROM ghcr.io/ersutup/wine-kasmvnc:latest

ARG WECHAT_VERSION=3.9.12.51

#复制脚本
COPY ./shell/* /shell/

RUN echo "****** update apt-get ******" && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "****** install xdotool ******" && \
    sudo apt-get update  && apt-get install -y \
    xdotool && \
    rm -rf /var/lib/apt/lists/*

USER abc

RUN echo "****** install wechat ******" && \
    sudo chown -R abc:abc /shell && \
    wget -nc -O /WeChat.exe https://github.com/tom-snow/wechat-windows-versions/releases/download/v${WECHAT_VERSION}/WeChatSetup-${WECHAT_VERSION}.exe && \
    /shell/install_wechat.sh

USER root

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8