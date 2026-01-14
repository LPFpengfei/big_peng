// BookshelfPage.ets
// 书架页面
import router from '@ohos.router';
import { getBookshelves, removeFromBookshelf } from '../utils/api';
import { Book } from '../models/Book';

@Entry
@Component
struct BookshelfPage {
  @State books: Book[] = [];
  @State loading: boolean = true;
  @State errorMessage: string = '';

  aboutToAppear() {
    this.loadBookshelves();
  }

  build() {
    Column() {
      // 标题栏
      Row({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Text('我的书架')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Button('发现')
          .fontSize(16)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/DiscoverPage'
            });
          })
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
      } else {
        // 书架列表
        if (this.books.length > 0) {
          Grid() {
            ForEach(this.books, (book: Book) => {
              GridItem() {
                Column({
                  space: 8
                }) {
                  // 书籍封面
                  Image(book.cover_image || 'common/images/default_cover.png')
                    .width(120)
                    .height(180)
                    .borderRadius(8)
                    .objectFit(ImageFit.Cover)
                    .backgroundColor(Color.Gray)
                    .onClick(() => {
                      // 跳转到阅读器页面
                      router.pushUrl({
                        url: `pages/ReaderPage?bookId=${book.id}`
                      });
                    })

                  // 书籍信息
                  Column({
                    space: 4
                  }) {
                    Text(book.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .width(120)
                      .textAlign(TextAlign.Center)
                      .maxLines(2)
                      .overflow({ overflow: TextOverflow.Ellipsis })
                    Text(book.author)
                      .fontSize(14)
                      .fontColor(Color.Gray)
                      .width(120)
                      .textAlign(TextAlign.Center)
                      .maxLines(1)
                      .overflow({ overflow: TextOverflow.Ellipsis })
                  }

                  // 操作按钮
                  Row({
                    justifyContent: FlexAlign.Center,
                    space: 8
                  }) {
                    Button('移除')
                      .width(80)
                      .height(32)
                      .fontSize(14)
                      .backgroundColor(Color.Red)
                      .fontColor(Color.White)
                      .onClick(() => {
                        this.removeBook(book.id);
                      })
                  }
                }
                .padding(12)
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(16)
          .rowsGap(20)
          .padding({ left: 20, right: 20, top: 20 })
          .width('100%')
        } else {
          // 空书架提示
          Column({
            space: 16
          }) {
            Text('你的书架还是空的')
              .fontSize(20)
              .fontColor(Color.Gray)
            Button('去发现')
              .fontSize(16)
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/DiscoverPage'
                });
              })
          }
          .margin({ top: 100 })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 加载书架数据
  private loadBookshelves() {
    this.loading = true;
    this.errorMessage = '';

    getBookshelves().then((result) => {
      this.loading = false;
      if (result.success) {
        this.books = result.data.bookshelves || [];
      } else {
        this.errorMessage = result.error;
      }
    }).catch((error) => {
      this.loading = false;
      this.errorMessage = '加载书架失败，请检查网络连接';
      console.error('Load bookshelves error:', error);
    });
  }

  // 从书架移除书籍
  private removeBook(bookId: number) {
    removeFromBookshelf(bookId).then((result) => {
      if (result.success) {
        // 重新加载书架
        this.loadBookshelves();
      } else {
        this.errorMessage = result.error;
      }
    }).catch((error) => {
      this.errorMessage = '移除失败，请检查网络连接';
      console.error('Remove from bookshelf error:', error);
    });
  }
}