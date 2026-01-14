// ReaderPage.ets
// 阅读器页面，核心功能页面
import router from '@ohos.router';
import { getBook, getReadingProgress, updateReadingProgress, createBookmark } from '../utils/api';
import { Book } from '../models/Book';

@Entry
@Component
struct ReaderPage {
  @State book: Book | null = null;
  @State loading: boolean = true;
  @State errorMessage: string = '';
  @State bookId: number = 0;
  @State currentChapter: string = '第一章';
  @State currentPage: number = 1;
  @State totalPages: number = 100;
  @State fontSize: number = 18;
  @State isMenuVisible: boolean = false;
  @State isBookmarkMenuVisible: boolean = false;
  @State bookmarkNote: string = '';

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams();
    this.bookId = params?.bookId as number || 0;
    this.loadBookAndProgress();
  }

  build() {
    Column() {
      // 顶部状态栏（默认隐藏，点击屏幕显示）
      if (this.isMenuVisible) {
        Row({
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }) {
          Button('返回')
            .fontSize(16)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.saveReadingProgress();
              router.back();
            })
          Text(this.book?.title || '阅读')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Button('菜单')
            .fontSize(16)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.isMenuVisible = !this.isMenuVisible;
            })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 40, bottom: 20 })
        .backgroundColor('#00000080')
      }

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
          .margin({ top: 200 })
      } else if (this.book) {
        // 阅读器主体
        Column({
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          // 书籍内容区域
          Column({
            alignItems: ItemAlign.Start
          }) {
            // 章节标题
            Text(this.currentChapter)
              .fontSize(this.fontSize + 4)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 20 })
              .fontColor(Color.Black)

            // 模拟书籍内容
            for (let i = 0; i < 20; i++) {
              Text(`这是第${this.currentPage}页的第${i + 1}行内容，用于模拟电子书的阅读体验。`)
                .fontSize(this.fontSize)
                .lineHeight(this.fontSize + 8)
                .margin({ bottom: 8 })
                .fontColor(Color.Black)
            }
          }
          .width('80%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .shadow({ radius: 4, offsetY: 2, color: '#0000001A' })

          // 页码指示器
          Text(`${this.currentPage} / ${this.totalPages}`)
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ top: 20 })

          // 翻页按钮
          Row({
            justifyContent: FlexAlign.SpaceAround,
            alignItems: ItemAlign.Center
          }) {
            Button('上一页')
              .fontSize(16)
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .enabled(this.currentPage > 1)
              .onClick(() => {
                this.prevPage();
              })
            Button('添加书签')
              .fontSize(16)
              .backgroundColor(Color.Yellow)
              .fontColor(Color.Black)
              .onClick(() => {
                this.toggleBookmarkMenu();
              })
            Button('下一页')
              .fontSize(16)
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .enabled(this.currentPage < this.totalPages)
              .onClick(() => {
                this.nextPage();
              })
          }
          .width('100%')
          .padding({ left: 40, right: 40, top: 20 })

          // 书签输入框
          if (this.isBookmarkMenuVisible) {
            Column({
              space: 12,
              alignItems: ItemAlign.Center
            }) {
              TextInput({
                placeholder: '添加书签备注（可选）',
                text: this.bookmarkNote
              })
                .width('80%')
                .height(100)
                .borderRadius(8)
                .backgroundColor(Color.White)
                .fontSize(16)
                .type(InputType.Multiline)
                .onChange((value) => {
                  this.bookmarkNote = value;
                })

              Row({
                space: 16
              }) {
                Button('取消')
                  .width(100)
                  .height(48)
                  .fontSize(16)
                  .backgroundColor(Color.Gray)
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.toggleBookmarkMenu();
                  })
                Button('保存')
                  .width(100)
                  .height(48)
                  .fontSize(16)
                  .backgroundColor(Color.Green)
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.saveBookmark();
                  })
              }
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#00000080')
            .margin({ top: 20 })
          }

          // 底部工具栏（默认隐藏，点击屏幕显示）
          if (this.isMenuVisible) {
            Column({
              space: 16,
              alignItems: ItemAlign.Center
            }) {
              Text('阅读设置')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)

              // 字体大小调整
              Row({
                alignItems: ItemAlign.Center,
                space: 20
              }) {
                Text('字体大小')
                  .fontSize(16)
                  .fontColor(Color.White)
                Button('A-')
                  .fontSize(14)
                  .backgroundColor(Color.Gray)
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.fontSize = Math.max(12, this.fontSize - 2);
                  })
                Text(`${this.fontSize}px`)
                  .fontSize(this.fontSize)
                  .fontColor(Color.White)
                Button('A+')
                  .fontSize(14)
                  .backgroundColor(Color.Gray)
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.fontSize = Math.min(28, this.fontSize + 2);
                  })
              }

              // 其他设置项可以在这里添加
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#00000080')
            .margin({ top: 20 })
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          this.isMenuVisible = !this.isMenuVisible;
        })
      } else {
        // 书籍不存在
        Text('书籍不存在')
          .fontSize(20)
          .fontColor(Color.Gray)
          .margin({ top: 200 })
        Button('返回')
          .fontSize(16)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .margin({ top: 20 })
          .onClick(() => {
            router.back();
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 加载书籍和阅读进度
  private loadBookAndProgress() {
    this.loading = true;
    this.errorMessage = '';

    // 并行加载书籍和阅读进度
    Promise.all([
      getBook(this.bookId),
      getReadingProgress(this.bookId)
    ]).then((results) => {
      this.loading = false;

      // 处理书籍数据
      const bookResult = results[0];
      if (bookResult.success) {
        this.book = bookResult.data.book;
      } else {
        this.errorMessage = '加载书籍失败';
      }

      // 处理阅读进度
      const progressResult = results[1];
      if (progressResult.success && progressResult.data.reading_progress) {
        this.currentChapter = progressResult.data.reading_progress.chapter;
        this.currentPage = progressResult.data.reading_progress.page;
      }
    }).catch((error) => {
      this.loading = false;
      this.errorMessage = '加载失败，请检查网络连接';
      console.error('Load book and progress error:', error);
    });
  }

  // 上一页
  private prevPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.saveReadingProgress();
    }
  }

  // 下一页
  private nextPage() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.saveReadingProgress();
    }
  }

  // 保存阅读进度
  private saveReadingProgress() {
    updateReadingProgress(this.bookId, this.currentChapter, this.currentPage)
      .then((result) => {
        if (!result.success) {
          console.error('Save reading progress failed:', result.error);
        }
      })
      .catch((error) => {
        console.error('Save reading progress error:', error);
      });
  }

  // 切换书签菜单
  private toggleBookmarkMenu() {
    this.isBookmarkMenuVisible = !this.isBookmarkMenuVisible;
    if (!this.isBookmarkMenuVisible) {
      this.bookmarkNote = '';
    }
  }

  // 保存书签
  private saveBookmark() {
    createBookmark(this.bookId, this.currentChapter, this.currentPage, this.bookmarkNote)
      .then((result) => {
        if (result.success) {
          // 显示添加成功提示
          promptAction.showToast({
            message: '书签已添加',
            duration: 2000
          });
          this.toggleBookmarkMenu();
        } else {
          // 显示添加失败提示
          promptAction.showToast({
            message: result.error || '添加书签失败',
            duration: 2000
          });
        }
      })
      .catch((error) => {
        // 显示添加失败提示
        promptAction.showToast({
          message: '添加书签失败，请检查网络连接',
          duration: 2000
        });
        console.error('Save bookmark error:', error);
      });
  }
}