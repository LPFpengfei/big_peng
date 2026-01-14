// EntryAbility.ts
// 应用入口类
// 注意：该文件使用鸿蒙特定API，在当前环境下无法解析相关依赖

// 鸿蒙UIAbility类型声明
declare module '@ohos.app.ability.UIAbility' {
  interface Want {
    [key: string]: any;
  }

  interface LaunchParam {
    [key: string]: any;
  }

  class UIAbility {
    onCreate(want: Want, launchParam: LaunchParam): void;
    onDestroy(): void;
    onWindowStageCreate(windowStage: any): void;
    onWindowStageDestroy(): void;
    onForeground(): void;
    onBackground(): void;
  }

  export default UIAbility;
}

// 鸿蒙window类型声明
declare module '@ohos.window' {
  interface WindowStage {
    loadContent(pagePath: string, callback: (err: any, data: any) => void): void;
  }
}

// 模拟UIAbility和window模块
const UIAbility = class {
  onCreate(want: any, launchParam: any): void { }
  onDestroy(): void { }
  onWindowStageCreate(windowStage: any): void { }
  onWindowStageDestroy(): void { }
  onForeground(): void { }
  onBackground(): void { }
};

const window = {
  WindowStage: class {
    loadContent(pagePath: string, callback: (err: any, data: any) => void): void {
      callback({ code: 0 }, {});
    }
  }
};

// 应用入口类
export default class EntryAbility extends UIAbility {
  // 隐藏未使用参数的警告
  onCreate(_want: any, _launchParam: any) {
    console.log('EntryAbility onCreate');
  }

  onDestroy() {
    console.log('EntryAbility onDestroy');
  }

  // 隐藏未使用参数的警告
  onWindowStageCreate(_windowStage: any) {
    // 设置主窗口页面
    _windowStage.loadContent('pages/LoginPage', (_err: any, _data: any) => {
      // 模拟实现，在实际鸿蒙环境中会执行
    });
  }

  onWindowStageDestroy() {
    console.log('EntryAbility onWindowStageDestroy');
  }

  onForeground() {
    console.log('EntryAbility onForeground');
  }

  onBackground() {
    console.log('EntryAbility onBackground');
  }
}