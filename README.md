# xmrig-assistant
XMR挖矿助手，掉进程维护，掉算力维护。

XMR mining assistant, maintenance of processes and computing power.

GaiaXmrig负责开启xmrig，以及掉进程维护；HadesXmrig负责关闭无效的xmrig进程，可维护掉算力的情况，其由GaiaXmrig开启。
需要将GaiaXmrig、HadesXmrig和xmrig、config.json放在一起，将GaiaXmrig添加为开机启动项，重启电脑即可自动挖矿。
由于xmrig在管理员模式可获得最佳效果，所以GaiaXmrig也是运行在管理员模式下，这需要关闭UAC。

GaiaXmrig is responsible for enabling xmrig and maintaining dropped processes; HadesXmrig is responsible for closing invalid xmrig processes and can maintain the situation of computing power loss, which is enabled by GaiaXmrig.
We need to put GaiaXmrig, HadesXmrig, xmrig, config.json together, add GaiaXmrig as the startup option, and restart the computer to automatically mine.
Due to the best performance of xmrig in administrator mode, GaiaXmrig also runs in administrator mode, which requires turning off UAC.

这适用于矿池连接失败导致的掉算力，思路是实时检测CPU占用率，如30%设为阈值，低于该值认为掉算力，间隔10分钟重复检测3次，一旦检测到恢复算力，就跳过，否则第三次时会关掉xmrig。

This applies to the drop in computing power caused by mining pool connection failure. The idea is to detect CPU usage in real-time, such as setting a threshold of 30%. If the threshold is lower than this value, it is considered drop in computing power. Repeat the detection three times every 10 minutes. Once the restored computing power is detected, skip it, otherwise xmrig will be turned off on the third time.

对了，GaiaXmrig是在后台开启xmrig和HadesXmrig的，所以如果安装了杀毒软件，请将其添加到白名单。

By the way, GaiaXmrig and HadesXmrig are enabled in the background, so if antivirus software is installed, please add it to the whitelist.

如搬运请标明出处，不得用于非法用途！
唯一来源：https://github.com/sprlightning/xmrig-assistant

If transporting, please indicate the source and do not use it for illegal purposes!
Unique source: https://github.com/sprlightning/xmrig-assistant

