// hvigorfile.ts
// HarmonyOS 应用构建配置文件
import { appTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: {
    framework: 'ohos'
  },
  plugins: {
    ohos: {
      plugin: appTasks,
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