// BookDetailPage.ets
// 书籍详情页面
import router from '@ohos.router';
import { getBook, addToBookshelf } from '../utils/api';
import { Book } from '../models/Book';

@Entry
@Component
struct BookDetailPage {
  @State book: Book | null = null;
  @State loading: boolean = true;
  @State errorMessage: string = '';
  @State bookId: number = 0;

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams();
    this.bookId = params?.bookId as number || 0;
    this.loadBookDetail();
  }

  build() {
    Column() {
      // 标题栏
      Row({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Button('返回')
          .fontSize(16)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            router.back();
          })
        Text('书籍详情')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text('')
          .width(80)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 40, bottom: 20 })
      .backgroundColor(Color.White)
      .shadow({ radius: 4, offsetY: 2, color: '#0000001A' })

      // 错误提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontColor(Color.Red)
          .fontSize(16)
          .margin({ top: 20 })
      }

      // 加载中
      if (this.loading) {
        LoadingProgress()
          .width(50)
          .height(50)
          .color(Color.Blue)
          .margin({ top: 100 })
      } else if (this.book) {
        // 书籍详情
        Scroll() {
          Column({
            space: 20
          }) {
            // 书籍封面和基本信息
            Row({
              space: 20
            }) {
              // 书籍封面
              Image(this.book.cover_image || 'common/images/default_cover.png')
                .width(150)
                .height(225)
                .borderRadius(12)
                .objectFit(ImageFit.Cover)
                .backgroundColor(Color.Gray)

              // 书籍基本信息
              Column({
                space: 12,
                alignItems: ItemAlign.Start
              }) {
                Text(this.book.title)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                Text(this.book.author)
                  .fontSize(20)
                  .fontColor(Color.Gray)
                Text(`来源: ${this.book.source}`)
                  .fontSize(16)
                  .fontColor(Color.Gray)

                // 操作按钮
                Row({
                  space: 16
                }) {
                  Button('加入书架')
                    .width(120)
                    .height(48)
                    .fontSize(16)
                    .backgroundColor(Color.Green)
                    .fontColor(Color.White)
                    .onClick(() => {
                      this.addToBookshelf();
                    })
                  Button('开始阅读')
                    .width(120)
                    .height(48)
                    .fontSize(16)
                    .backgroundColor(Color.Blue)
                    .fontColor(Color.White)
                    .onClick(() => {
                      this.startReading();
                    })
                }
              }
            }
            .padding({ left: 20, right: 20, top: 20 })

            // 书籍描述
            Column({
              alignItems: ItemAlign.Start
            }) {
              Text('书籍简介')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 12 })
              Text(this.book.description)
                .fontSize(16)
                .lineHeight(24)
                .fontColor(Color.Black)
            }
            .padding({ left: 20, right: 20, bottom: 20 })
          }
          .width('100%')
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        // 书籍不存在
        Text('书籍不存在')
          .fontSize(20)
          .fontColor(Color.Gray)
          .margin({ top: 100 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 加载书籍详情
  private loadBookDetail() {
    this.loading = true;
    this.errorMessage = '';

    getBook(this.bookId).then((result) => {
      this.loading = false;
      if (result.success) {
        this.book = result.data.book;
      } else {
        this.errorMessage = result.error;
      }
    }).catch((error) => {
      this.loading = false;
      this.errorMessage = '加载书籍详情失败，请检查网络连接';
      console.error('Load book detail error:', error);
    });
  }

  // 添加到书架
  private addToBookshelf() {
    addToBookshelf(this.bookId).then((result) => {
      if (result.success) {
        // 显示添加成功提示
        promptAction.showToast({
          message: '已添加到书架',
          duration: 2000
        });
      } else {
        // 显示添加失败提示
        promptAction.showToast({
          message: result.error || '添加失败',
          duration: 2000
        });
      }
    }).catch((error) => {
      // 显示添加失败提示
      promptAction.showToast({
        message: '添加失败，请检查网络连接',
        duration: 2000
      });
      console.error('Add to bookshelf error:', error);
    });
  }

  // 开始阅读
  private startReading() {
    router.pushUrl({
      url: `pages/ReaderPage?bookId=${this.bookId}`
    });
  }
}