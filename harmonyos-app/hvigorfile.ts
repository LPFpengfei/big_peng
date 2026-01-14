// hvigorfile.ts
// HarmonyOS 应用构建配置文件
// 注意：该文件仅用于鸿蒙应用构建，在当前环境下无法解析相关依赖

// import { appTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: {
    framework: 'ohos'
  },
  plugins: {
    ohos: {
      // plugin: appTasks,
      params: {
        app: {
          product: 'default',
          signMode: 'debug',
          profile: '',
          certificate: '',
          privateKey: ''
        }
      }
    }
  }
};