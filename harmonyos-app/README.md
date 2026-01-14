# 鸿蒙电子书应用

这是一个基于HarmonyOS开发的电子书应用，与Rails后端配合使用，提供电子书阅读、书架管理、书签管理等功能。

## 功能特性

- 用户登录/注册
- 我的书架
- 电子书发现与搜索
- 书籍详情查看
- 电子书阅读
- 阅读进度保存
- 书签管理

## 技术栈

- HarmonyOS ArkTS
- TypeScript
- RESTful API

## 项目结构

```
harmonyos-app/
├── app.json5                 # 应用配置文件
├── entry/                    # 入口模块
│   ├── module.json5          # 模块配置文件
│   └── src/
│       └── main/
│           ├── ets/          # TypeScript源码
│           │   ├── entryability/   # 应用入口能力
│           │   ├── models/         # 数据模型
│           │   ├── pages/         # 页面组件
│           │   └── utils/         # 工具类
│           └── resources/    # 资源文件
├── hvigorfile.ts             # 构建配置文件
└── package.json              # 项目依赖配置
```

## 构建与运行

### 前置条件

- 已安装HarmonyOS DevEco Studio
- 已配置HarmonyOS开发环境
- 已启动Rails后端服务（默认地址：http://localhost:3000）

### 构建步骤

1. 打开DevEco Studio
2. 导入项目：选择`harmonyos-app`目录
3. 等待项目同步完成
4. 连接HarmonyOS设备或启动模拟器
5. 点击运行按钮，构建并运行应用

### 调试

- 确保设备与开发机在同一网络下
- 在`api.ts`中修改`BASE_URL`为后端服务的实际地址
- 使用DevEco Studio的调试工具进行调试

## API接口

应用通过RESTful API与后端通信，主要接口包括：

- 认证相关：登录、注册、登出
- 书籍相关：获取书籍列表、获取书籍详情
- 书架相关：获取书架、添加到书架、从书架移除
- 书签相关：获取书签、创建书签、更新书签、删除书签
- 阅读进度相关：获取阅读进度、更新阅读进度
- 分类相关：获取分类列表、获取分类详情

## 权限说明

应用需要以下权限：

- `ohos.permission.INTERNET`：访问网络获取电子书数据
- `ohos.permission.READ_MEDIA`：读取媒体文件
- `ohos.permission.WRITE_MEDIA`：写入媒体文件

## 注意事项

1. 首次运行需要先注册账号
2. 确保后端服务正常运行
3. 应用默认使用http://localhost:3000作为后端地址，如需修改请编辑`utils/api.ts`文件中的`BASE_URL`
4. 阅读器目前使用模拟数据，实际使用时需要接入真实的电子书解析库

## 后续优化

- 接入真实的电子书解析库
- 添加夜间模式
- 支持更多电子书格式
- 添加阅读统计功能
- 实现离线阅读

## License

Apache-2.0
