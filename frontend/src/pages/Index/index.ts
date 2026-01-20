// src/pages/Index/index.ts
import { Book } from '../../types'

Page({
  data: {
    books: [] as Book[]
  },

  onLoad() {
    this.loadBooks()
  },

  loadBooks() {
    // 模拟数据，后续将替换为真实API调用
    const mockBooks: Book[] = [
      {
        id: 1,
        title: 'JavaScript高级程序设计',
        author: 'Nicholas C. Zakas',
        cover_url: 'https://via.placeholder.com/150',
        description: '深入理解JavaScript语言',
        content: '...'
      },
      {
        id: 2,
        title: 'Python编程：从入门到实践',
        author: 'Eric Matthes',
        cover_url: 'https://via.placeholder.com/150',
        description: '零基础学Python',
        content: '...'
      },
      {
        id: 3,
        title: '算法导论',
        author: 'Thomas H. Cormen',
        cover_url: 'https://via.placeholder.com/150',
        description: '算法领域经典著作',
        content: '...'
      }
    ]
    this.setData({ books: mockBooks })
  },

  goToBookshelf() {
    wx.switchTab({
      url: '/src/pages/Bookshelf/index'
    })
  },

  goToDiscover() {
    wx.switchTab({
      url: '/src/pages/Discover/index'
    })
  },

  goToReader(e: WechatMiniprogram.TouchEvent) {
    const bookId = e.currentTarget.dataset.id as number
    wx.navigateTo({
      url: `/src/pages/Reader/index?bookId=${bookId}`
    })
  }
})