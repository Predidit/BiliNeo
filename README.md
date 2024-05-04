# bilineo

又一个 Bilibili 第三方客户端，仅支持番剧相关功能，项目使用 flutter 构建。本项目目的为个人学习与测试 Flutter 开发，所用API为B站公开API的封装，无任何破解行为。

## 支持平台

- Android 10 及以上
- Windows 10 1809 及以上

## 功能 / 开发计划

- [x] 番剧目录
- [x] 番剧搜索
- [x] 番剧字幕
- [x] 番剧弹幕
- [x] 港澳台番剧
- [x] 视频播放器
- [x] 硬件加速
- [x] 在线更新
- [x] 倍速播放
- [ ] 新番动态
- [ ] 番剧时间表
- [ ] 追番列表
- [ ] 番剧下载
- [ ] 番剧评论
- [ ] 还有更多 (/・ω・＼) 

## Q&A

#### Q: 为什么我找不到 xxx 番剧？ 为什么新番缺了那么多？
A: 由于众所周知的问题，B站近年即使在港澳台区，购买番剧版权的策略也倾向于保守，如果没有您要找的番剧，可以试试作者的另一个项目 [oneAnime](https://github.com/Predidit/oneAnime)

#### Q: 为什么 xxx 番剧没有字幕？
A: B站部分番剧使用外挂字幕而非内嵌字幕，对应接口只支持包含有效用户签名的调用，对于此类番剧，需要您登录账号以获得字幕。

#### Q: 我在尝试自行编译该项目，但是编译不通过。

 A: flutter 项目编译需要良好的网络环境，如果您位于中国大陆，可能需要设置恰当的镜像地址。

## 致谢

特别感谢 [pilipala](https://github.com/guozhigq/pilipala) 本项目使用了来自 pilipala 的代码。

感谢 [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect) 该项目收集的公开API使第三方客户端成为可能。

感谢 [bilibili-helper](https://github.com/ipcjs/bilibili-helper) 提供了解析 Bilibili 港澳台的相关思路。
