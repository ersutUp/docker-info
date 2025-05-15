FROM ghcr.io/ersutup/wine-kasmvnc:latest

ARG WECHAT_VERSION=3.9.12.51

COPY root /

USER abc

RUN echo "****** start xvnc ******" && \
    sudo rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 \
    # 安装微信使用的 xdotool 需要启动桌面（xvnc）
    bash -c "nohup /usr/local/bin/Xvnc $DISPLAY -interface 0.0.0.0 2>&1 &" && sleep 5 && \
    echo "****** install wechat ******" && \
    sudo wget -nc -O /WeChat.exe https://github.com/tom-snow/wechat-windows-versions/releases/download/v${WECHAT_VERSION}/WeChatSetup-${WECHAT_VERSION}.exe && \
    sudo chown abc:abc /WeChat.exe && \
    sudo chown abc:abc  ~/shell/*.sh && sudo chmod +x ~/shell/*.sh && \
    ~/shell/install-wechat.sh && \
    sudo rm -rf /WeChat.exe

USER root