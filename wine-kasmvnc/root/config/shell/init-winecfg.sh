#!/usr/bin/env bash
function skipsomething() {
    LAST="1"
    while :
    do
        xdotool search "$@"
        NOTFOUND=$?
        if [ "$LAST" == "0" ] && [ "$NOTFOUND" == "1" ]; then
            break
        fi
        echo "[skipsomething] find $@ : $NOTFOUND"
        if [ "$NOTFOUND" == "0" ]; then
            #xdotool search "$@" windowactivate
            sleep 3
            xdotool key Tab
            sleep 0.5
            xdotool key Return
        fi
        LAST=$NOTFOUND
        sleep 1
    done
}
function closeSetting() {
    LAST="1"
    while :
    do
        xdotool search --name "$@"
        NOTFOUND=$?
        if [ "$LAST" == "0" ] && [ "$NOTFOUND" == "1" ]; then
            break
        fi
        xdotool search --name "$@" getwindowname
        echo "[closeSetting] find $@ : $NOTFOUND"
        if [ "$NOTFOUND" == "0" ]; then
            WINE_PID=($(ps aux | grep "winecfg" | grep -v grep | awk '{print $2}'))
            echo "[closeSetting] winecfg PID : $WINE_PID"
            sudo kill -9 $WINE_PID
        fi
        LAST=$NOTFOUND
        sleep 2
    done
}
# 初始化配置
winecfg &


sleep 10

# 关闭安装 Mono 窗口
skipsomething "Wine Mono"

sleep 10

# 关闭安装 wine设置 窗口
closeSetting "Wine "
wait

sleep 5