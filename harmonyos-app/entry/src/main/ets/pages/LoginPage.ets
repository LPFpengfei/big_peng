// LoginPage.ets
// 登录页面
import router from '@ohos.router';
import { login, register } from '../utils/api';

@Entry
@Component
struct LoginPage {
  @State isLogin: boolean = true;
  @State email: string = '';
  @State nickname: string = '';
  @State password: string = '';
  @State loading: boolean = false;
  @State errorMessage: string = '';

  build() {
    Column({
      space: 20
    }) {
      // 标题
      Text(this.isLogin ? '登录' : '注册')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 80 })

      // 错误提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontColor(Color.Red)
          .fontSize(14)
      }

      // 表单
      Column({
        space: 16
      }) {
        // 邮箱输入
        TextInput({
          placeholder: '请输入邮箱',
          text: this.email
        })
          .width('80%')
          .height(50)
          .borderRadius(25)
          .backgroundColor(Color.Gray)
          .fontSize(16)
          .onChange((value) => {
            this.email = value;
          })

        // 昵称输入（仅注册）
        if (!this.isLogin) {
          TextInput({
            placeholder: '请输入昵称',
            text: this.nickname
          })
            .width('80%')
            .height(50)
            .borderRadius(25)
            .backgroundColor(Color.Gray)
            .fontSize(16)
            .onChange((value) => {
              this.nickname = value;
            })
        }

        // 密码输入
        TextInput({
          placeholder: '请输入密码',
          text: this.password,
          type: InputType.Password
        })
          .width('80%')
          .height(50)
          .borderRadius(25)
          .backgroundColor(Color.Gray)
          .fontSize(16)
          .onChange((value) => {
            this.password = value;
          })

        // 登录/注册按钮
        Button(this.isLogin ? '登录' : '注册')
          .width('80%')
          .height(50)
          .borderRadius(25)
          .backgroundColor(Color.Blue)
          .fontSize(18)
          .fontColor(Color.White)
          .onClick(() => {
            this.handleAuth();
          })
          .enabled(!this.loading)
      }
      .margin({ top: 40 })

      // 切换登录/注册
      Row({
        space: 8
      }) {
        Text(this.isLogin ? '还没有账号？' : '已有账号？')
          .fontSize(16)
          .fontColor(Color.Gray)
        Text(this.isLogin ? '去注册' : '去登录')
          .fontSize(16)
          .fontColor(Color.Blue)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.isLogin = !this.isLogin;
            this.errorMessage = '';
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 处理登录/注册
  private handleAuth() {
    this.errorMessage = '';
    this.loading = true;

    try {
      if (this.isLogin) {
        // 登录
        login(this.email, this.password).then((result) => {
          this.loading = false;
          if (result.success) {
            // 登录成功，保存token，跳转到书架页面
            AppStorage.SetOrCreate('token', result.data.token);
            router.replaceUrl({
              url: 'pages/BookshelfPage'
            });
          } else {
            this.errorMessage = result.error;
          }
        }).catch((error) => {
          this.loading = false;
          this.errorMessage = '登录失败，请检查网络连接';
          console.error('Login error:', error);
        });
      } else {
        // 注册
        register(this.email, this.nickname, this.password).then((result) => {
          this.loading = false;
          if (result.success) {
            // 注册成功，保存token，跳转到书架页面
            AppStorage.SetOrCreate('token', result.data.token);
            router.replaceUrl({
              url: 'pages/BookshelfPage'
            });
          } else {
            this.errorMessage = result.error;
          }
        }).catch((error) => {
          this.loading = false;
          this.errorMessage = '注册失败，请检查网络连接';
          console.error('Register error:', error);
        });
      }
    } catch (error) {
      this.loading = false;
      this.errorMessage = '操作失败，请重试';
      console.error('Auth error:', error);
    }
  }
}