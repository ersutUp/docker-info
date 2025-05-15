# wine 镜像

父镜像已经安装 kasmvnc  端口为3000

本镜像主要是安装了 wine、winetricks



**wine版本：10.0**



❎ **目前存在的问题** 安装 wine-mono 报错找不到 GUI；  可能是未安装`zenity`，目前已安装， 问题未验证



💡注意：需要挂载宿主机的/usr/share/fonts目录到容器的/usr/share/fonts目录

## 参考资料

- dockerfile参考：https://github.com/xineur/wine-box/tree/master
- wine安装：https://github.com/zouyu4524/install-wechat-via-wine
- wine中文字体安装：
  - https://gist.github.com/qin-yu/bfd799f2380c875045e7c8b918d02f36
  - https://gist.github.com/swordfeng/c3fd6b6fcf6dc7d7fa8a