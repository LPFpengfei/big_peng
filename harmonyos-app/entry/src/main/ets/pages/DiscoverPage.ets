// DiscoverPage.ets
// 发现页面，用于浏览和搜索电子书
import router from '@ohos.router';
import { getBooks, addToBookshelf } from '../utils/api';
import { Book } from '../models/Book';

@Entry
@Component
struct DiscoverPage {
  @State books: Book[] = [];
  @State loading: boolean = true;
  @State errorMessage: string = '';
  @State searchText: string = '';
  @State currentPage: number = 1;
  @State totalPages: number = 1;
  @State isLoadingMore: boolean = false;

  aboutToAppear() {
    this.loadBooks();
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
        Text('发现')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text('')
          .width(80)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 40, bottom: 20 })
      .backgroundColor(Color.White)
      .shadow({ radius: 4, offsetY: 2, color: '#0000001A' })

      // 搜索栏
      Row({
        alignItems: ItemAlign.Center,
        space: 12
      }) {
        TextInput({
          placeholder: '搜索书籍或作者',
          text: this.searchText
        })
          .width('75%')
          .height(48)
          .borderRadius(24)
          .backgroundColor(Color.Gray)
          .fontSize(16)
          .onChange((value) => {
            this.searchText = value;
          })
        Button('搜索')
          .width(80)
          .height(48)
          .borderRadius(24)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .onClick(() => {
            this.searchBooks();
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 20 })
      .backgroundColor(Color.White)

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
        // 书籍列表
        if (this.books.length > 0) {
          List() {
            ForEach(this.books, (book: Book) => {
              ListItem() {
                Row({
                  space: 16
                }) {
                  // 书籍封面
                  Image(book.cover_image || 'common/images/default_cover.png')
                    .width(80)
                    .height(120)
                    .borderRadius(8)
                    .objectFit(ImageFit.Cover)
                    .backgroundColor(Color.Gray)

                  // 书籍信息
                  Column({
                    space: 8,
                    alignItems: ItemAlign.Start
                  }) {
                    Text(book.title)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .maxLines(2)
                      .overflow({ overflow: TextOverflow.Ellipsis })
                    Text(book.author)
                      .fontSize(16)
                      .fontColor(Color.Gray)
                    Text(book.description)
                      .fontSize(14)
                      .fontColor(Color.Gray)
                      .maxLines(3)
                      .overflow({ overflow: TextOverflow.Ellipsis })

                    // 操作按钮
                    Row({
                      space: 12
                    }) {
                      Button('详情')
                        .width(80)
                        .height(36)
                        .fontSize(14)
                        .backgroundColor(Color.Blue)
                        .fontColor(Color.White)
                        .onClick(() => {
                          // 跳转到书籍详情页面
                          router.pushUrl({
                            url: `pages/BookDetailPage?bookId=${book.id}`
                          });
                        })
                      Button('加入书架')
                        .width(100)
                        .height(36)
                        .fontSize(14)
                        .backgroundColor(Color.Green)
                        .fontColor(Color.White)
                        .onClick(() => {
                          this.addToBookshelf(book.id);
                        })
                    }
                  }
                  .flexGrow(1)
                }
                .padding(16)
                .backgroundColor(Color.White)
                .borderRadius(12)
                .margin({ left: 20, right: 20, top: 12 })
                .shadow({ radius: 4, offsetY: 2, color: '#0000001A' })
              }
            })

            // 加载更多
            if (this.currentPage < this.totalPages) {
              ListItem() {
                Column() {
                  if (this.isLoadingMore) {
                    LoadingProgress()
                      .width(30)
                      .height(30)
                      .color(Color.Blue)
                      .margin({ top: 20, bottom: 20 })
                  } else {
                    Text('加载更多')
                      .fontSize(16)
                      .fontColor(Color.Blue)
                      .margin({ top: 20, bottom: 20 })
                      .onClick(() => {
                        this.loadMoreBooks();
                      })
                  }
                }
              }
            }
          }
          .width('100%')
          .layoutWeight(1)
        } else {
          // 无数据提示
          Text('没有找到相关书籍')
            .fontSize(20)
            .fontColor(Color.Gray)
            .margin({ top: 100 })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 加载书籍列表
  private loadBooks(page: number = 1) {
    this.loading = page === 1;
    this.isLoadingMore = page > 1;
    this.errorMessage = '';

    getBooks({
      q: this.searchText,
      page: page,
      per_page: 10
    }).then((result) => {
      this.loading = false;
      this.isLoadingMore = false;
      
      if (result.success) {
        if (page === 1) {
          this.books = result.data.books || [];
        } else {
          this.books = [...this.books, ...(result.data.books || [])];
        }
        this.currentPage = result.data.pagination?.current_page || 1;
        this.totalPages = result.data.pagination?.total_pages || 1;
      } else {
        this.errorMessage = result.error;
      }
    }).catch((error) => {
      this.loading = false;
      this.isLoadingMore = false;
      this.errorMessage = '加载失败，请检查网络连接';
      console.error('Load books error:', error);
    });
  }

  // 搜索书籍
  private searchBooks() {
    this.loadBooks(1);
  }

  // 加载更多书籍
  private loadMoreBooks() {
    if (this.currentPage < this.totalPages && !this.isLoadingMore) {
      this.loadBooks(this.currentPage + 1);
    }
  }

  // 添加到书架
  private addToBookshelf(bookId: number) {
    addToBookshelf(bookId).then((result) => {
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
}