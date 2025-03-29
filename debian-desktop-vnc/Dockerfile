FROM debian:12.10

COPY root /

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" >  /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >>  /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >>  /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >>  /etc/apt/sources.list 

RUN apt-get update && apt-get install -y \
    curl wget supervisor \
    x11vnc novnc xvfb  \
    sudo zenity \
    dbus-x11 x11-utils alsa-utils \
    mesa-utils libgl1-mesa-dri lxde 
RUN mkdir ~/.vnc && x11vnc -storepasswd vncpass ~/.vnc/passwd

#中文
RUN apt-get install -y ttf-wqy-microhei locales procps vim \
    && rm -rf /var/lib/apt/lists/* \
    && sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen


# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini && chmod +x /startup.sh

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8

EXPOSE 8080

ENTRYPOINT [ "/startup.sh" ]