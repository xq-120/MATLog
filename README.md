# MATLog
基于CocoaLumberjack的封装，方便使用，以及增加了一些功能。
1. 优化了DDLog的默认打印格式，打印信息更详细。
2. 默认增加了文件logger。
3. 支持单条日志在打印的同时，将日志上传到服务器。上传失败则会存储在数据库等待下一次上传。

DDLog默认打印格式：

```
2023-02-16 19:01:40.284509+0800 MATLogDemo[21016:2029302] DDLog默认打印格式
```

MATLog默认打印格式：

```
2023-02-16 18:59:48.250799+0800 MATLogDemo[20850:2026287] btnDidClicked(_:) +41 [level:Debug,module:0]
MATLog默认打印格式
```

