// src/pages/Discover/index.ts
import { Book } from '../../types'

Page({
  data: {
    hotBooks: [] as Book[],
    newBooks: [] as Book[],
    searchKeyword: ''
  },

  onLoad() {
    this.loadHotBooks()
    this.loadNewBooks()
  },

  loadHotBooks() {
    // 模拟热门图书数据
    const mockHotBooks: Book[] = [
      {
        id: 1,
        title: 'JavaScript高级程序设计',
        author: 'Nicholas C. Zakas',
        cover_url: 'https://via.placeholder.com/150',
        description: '深入理解JavaScript语言，从基础到高级应用',
        content: '...'
      },
      {
        id: 2,
        title: 'Python编程：从入门到实践',
        author: 'Eric Matthes',
        cover_url: 'https://via.placeholder.com/150',
        description: '零基础学Python，适合初学者的实践指南',
        content: '...'
      },
      {
        id: 3,
        title: '算法导论',
        author: 'Thomas H. Cormen',
        cover_url: 'https://via.placeholder.com/150',
        description: '算法领域经典著作，全面介绍算法设计与分析',
        content: '...'
      }
    ]
    this.setData({ hotBooks: mockHotBooks })
  },

  loadNewBooks() {
    // 模拟新书上架数据
    const mockNewBooks: Book[] = [
      {
        id: 4,
        title: 'TypeScript实战',
        author: '张同光',
        cover_url: 'https://via.placeholder.com/150',
        description: 'TypeScript从入门到精通，实战项目案例',
        content: '...'
      },
      {
        id: 5,
        title: 'React设计模式与最佳实践',
        author: 'Marco Concetto Rudelli',
        cover_url: 'https://via.placeholder.com/150',
        description: 'React开发中的设计模式和最佳实践',
        content: '...'
      }
    ]
    this.setData({ newBooks: mockNewBooks })
  },

  onSearchInput(e: WechatMiniprogram.BaseEvent) {
    this.setData({ searchKeyword: (e as any).detail.value })
  },

  onSearch() {
    // 实现搜索功能，后续替换为真实API调用
    wx.showToast({
      title: `搜索: ${this.data.searchKeyword}`,
      icon: 'none'
    })
  },

  goToReader(e: WechatMiniprogram.TouchEvent) {
    const bookId = e.currentTarget.dataset.id as number
    wx.navigateTo({
      url: `/src/pages/Reader/index?bookId=${bookId}`
    })
  },

  addToBookshelf(e: WechatMiniprogram.TouchEvent) {
    const book = e.currentTarget.dataset.book as Book
    // 模拟添加到书架
    wx.showToast({
      title: '已添加到书架',
      icon: 'success'
    })
    // 这里可以保存到本地存储或调用API保存到服务器
    console.log('添加到书架:', book)
  }
})