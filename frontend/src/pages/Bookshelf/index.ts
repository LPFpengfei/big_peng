// src/pages/Bookshelf/index.ts
import { Book } from '../../types'

interface BookshelfBook extends Book {
  progress?: number
  lastReadAt?: string
}

Page({
  data: {
    books: [] as BookshelfBook[]
  },

  onLoad() {
    this.loadBooks()
  },

  onShow() {
    // 每次显示页面时重新加载数据，确保数据最新
    this.loadBooks()
  },

  loadBooks() {
    // 模拟书架数据，后续将替换为真实API调用
    const mockBooks: BookshelfBook[] = [
      {
        id: 1,
        title: 'JavaScript高级程序设计',
        author: 'Nicholas C. Zakas',
        cover_url: 'https://via.placeholder.com/150',
        description: '深入理解JavaScript语言',
        content: '...',
        progress: 45, // 阅读进度
        lastReadAt: '2026-01-20'
      },
      {
        id: 2,
        title: 'Python编程：从入门到实践',
        author: 'Eric Matthes',
        cover_url: 'https://via.placeholder.com/150',
        description: '零基础学Python',
        content: '...',
        progress: 78, // 阅读进度
        lastReadAt: '2026-01-19'
      },
      {
        id: 3,
        title: '算法导论',
        author: 'Thomas H. Cormen',
        cover_url: 'https://via.placeholder.com/150',
        description: '算法领域经典著作',
        content: '...',
        progress: 23, // 阅读进度
        lastReadAt: '2026-01-18'
      }
    ]
    this.setData({ books: mockBooks })
  },

  goToReader(e: WechatMiniprogram.TouchEvent) {
    const bookId = e.currentTarget.dataset.id as number
    wx.navigateTo({
      url: `/src/pages/Reader/index?bookId=${bookId}`
    })
  },

  goToDiscover() {
    wx.switchTab({
      url: '/src/pages/Discover/index'
    })
  }
})