FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# COPY root /


RUN echo "****** update apt-get ******" && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    sudo echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    sudo apt-get update  && apt-get install -y \
    wget vim nano && \
    echo "****** install wine ******" && \
    sudo dpkg --add-architecture i386 && \
    sudo mkdir -pm755 /usr/share/keyrings && \
    sudo wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    sudo echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/winehq-archive.key] https://mirrors.tuna.tsinghua.edu.cn/wine-builds/debian/ bookworm main" > /etc/apt/sources.list.d/winehq-bookworm.list && \
    sudo apt-get update && \
    sudo apt install -y --install-recommends winehq-stable && \
    echo "****** install chinese fonts ******" && \
    apt-get install -y ttf-wqy-microhei locales procps && \
    rm -rf /var/lib/apt/lists/* && \
    sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
