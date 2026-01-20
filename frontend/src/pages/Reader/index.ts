// src/pages/Reader/index.ts
import { Book } from '../../types'

interface ReaderBook extends Book {
  chapters?: Chapter[]
  progress?: number
  wordCount?: number
  readingTime?: number
}

interface Chapter {
  id: number
  title: string
  startPos: number
  endPos: number
}

Page({
  data: {
    book: {
      id: 0,
      title: '',
      author: '',
      cover_url: '',
      description: '',
      content: '',
      chapters: [],
      progress: 0,
      wordCount: 0,
      readingTime: 0
    } as ReaderBook,
    inBookshelf: false,
    showChapters: false,
    showSettings: false,
    currentChapter: 0,
    fontSize: 32,
    theme: 'default'
  },

  onLoad(options: { bookId?: string }) {
    const bookId = parseInt(options.bookId || '1')
    this.loadBook(bookId)
    this.checkInBookshelf(bookId)
  },

  loadBook(bookId: number) {
    // 模拟书籍内容，后续将替换为真实API调用
    const mockBooks: Record<number, ReaderBook> = {
      1: {
        id: 1,
        title: 'JavaScript高级程序设计',
        author: 'Nicholas C. Zakas',
        cover_url: 'https://via.placeholder.com/150',
        description: '深入理解JavaScript语言',
        content: '第1章 什么是JavaScript\n\nJavaScript是一种轻量级的脚本语言，最初由Netscape开发，用于增强网页的交互性。随着Web技术的发展，JavaScript已经成为前端开发的核心语言，同时也可以用于后端开发（如Node.js）。\n\nJavaScript具有以下特点：\n1. 解释执行，不需要编译\n2. 弱类型语言\n3. 基于对象和事件驱动\n4. 跨平台兼容性\n\n本章将介绍JavaScript的基本概念和历史发展，帮助读者建立对这门语言的初步认识。\n\n第2章 JavaScript语法基础\n\nJavaScript的语法是其核心组成部分，它定义了如何编写有效的JavaScript代码。本章将介绍JavaScript的基本语法，包括变量、数据类型、运算符、表达式和语句等。\n\n2.1 变量和常量\n在JavaScript中，变量是用来存储数据的容器。变量可以通过var、let或const关键字来声明。\n\n2.2 数据类型\nJavaScript有多种数据类型，包括原始类型和引用类型。原始类型包括Number、String、Boolean、Null、Undefined和Symbol。引用类型包括Object、Array、Function等。',
        chapters: [
          { id: 1, title: '第1章 什么是JavaScript', startPos: 0, endPos: 500 },
          { id: 2, title: '第2章 JavaScript语法基础', startPos: 500, endPos: 1000 }
        ],
        progress: 45,
        wordCount: 100000,
        readingTime: 60
      },
      2: {
        id: 2,
        title: 'Python编程：从入门到实践',
        author: 'Eric Matthes',
        cover_url: 'https://via.placeholder.com/150',
        description: '零基础学Python',
        content: '第1章 起步\n\nPython是一种简单易学、功能强大的编程语言，它具有优雅的语法和丰富的库，适合各种编程任务。本章将引导你安装Python环境，并编写第一个Python程序。\n\n1.1 Python简介\nPython由Guido van Rossum于1989年圣诞节期间开发，最初的设计目标是创建一种易于阅读和编写的编程语言。\n\n1.2 安装Python\n在不同的操作系统上安装Python的方法略有不同，本章将详细介绍Windows、macOS和Linux系统的安装步骤。',
        chapters: [
          { id: 1, title: '第1章 起步', startPos: 0, endPos: 300 }
        ],
        progress: 78,
        wordCount: 80000,
        readingTime: 45
      },
      3: {
        id: 3,
        title: '算法导论',
        author: 'Thomas H. Cormen',
        cover_url: 'https://via.placeholder.com/150',
        description: '算法领域经典著作',
        content: '第1章 算法在计算中的作用\n\n算法是解决问题的步骤集合，它定义了如何将输入转换为输出。算法是计算机科学的核心概念，几乎所有的计算机程序都依赖于算法。\n\n1.1 算法的定义\n算法是一个有限的指令集，它接收一些输入（也可以没有输入），产生输出，并在有限的步骤内终止。\n\n1.2 算法的重要性\n良好的算法设计对于提高程序的效率至关重要，尤其是在处理大规模数据时。一个高效的算法可以将原本需要几天时间的计算任务缩短到几秒钟。',
        chapters: [
          { id: 1, title: '第1章 算法在计算中的作用', startPos: 0, endPos: 400 }
        ],
        progress: 23,
        wordCount: 120000,
        readingTime: 75
      }
    }

    const book = mockBooks[bookId] || mockBooks[1]
    this.setData({ book })
  },

  checkInBookshelf(bookId: number) {
    // 模拟检查书籍是否在书架中
    const bookshelfIds = [1, 2] // 模拟书架中已有书籍的ID
    const inBookshelf = bookshelfIds.includes(bookId)
    this.setData({ inBookshelf })
  },

  // 章节导航
  prevChapter() {
    const { currentChapter } = this.data
    if (currentChapter > 0) {
      this.setData({ currentChapter: currentChapter - 1 })
      // 这里可以添加切换章节的逻辑
      wx.showToast({
        title: `已切换到第${currentChapter}章`,
        icon: 'none'
      })
    } else {
      wx.showToast({
        title: '已经是第一章',
        icon: 'none'
      })
    }
  },

  nextChapter() {
    const { currentChapter, book } = this.data
    const chapters = book.chapters || []
    if (currentChapter < chapters.length - 1) {
      this.setData({ currentChapter: currentChapter + 1 })
      // 这里可以添加切换章节的逻辑
      wx.showToast({
        title: `已切换到第${currentChapter + 2}章`,
        icon: 'none'
      })
    } else {
      wx.showToast({
        title: '已经是最后一章',
        icon: 'none'
      })
    }
  },

  // 书架管理
  addToBookshelf() {
    wx.showToast({
      title: '已添加到书架',
      icon: 'success'
    })
    this.setData({ inBookshelf: true })
  },

  removeFromBookshelf() {
    wx.showToast({
      title: '已移除书架',
      icon: 'success'
    })
    this.setData({ inBookshelf: false })
  },

  // 目录管理
  toggleChapters() {
    this.setData({ showChapters: !this.data.showChapters, showSettings: false })
  },

  showChapters() {
    this.setData({ showChapters: true, showSettings: false })
  },

  hideChapters() {
    this.setData({ showChapters: false })
  },

  goToChapter(e: WechatMiniprogram.TouchEvent) {
    const chapterIndex = e.currentTarget.dataset.index as number
    this.setData({ currentChapter: chapterIndex, showChapters: false })
    // 这里可以添加跳转到指定章节的逻辑
    wx.showToast({
      title: `已跳转到第${chapterIndex + 1}章`,
      icon: 'none'
    })
  },

  // 设置管理
  toggleSettings() {
    this.setData({ showSettings: !this.data.showSettings, showChapters: false })
  },

  showSettings() {
    this.setData({ showSettings: true, showChapters: false })
  },

  hideSettings() {
    this.setData({ showSettings: false })
  },

  // 工具栏管理
  toggleToolbar() {
    // 这里可以添加显示/隐藏工具栏的逻辑
    console.log('Toggle toolbar')
  },

  // 字体大小调整
  increaseFontSize() {
    if (this.data.fontSize < 48) {
      this.setData({ fontSize: this.data.fontSize + 2 })
    }
  },

  decreaseFontSize() {
    if (this.data.fontSize > 24) {
      this.setData({ fontSize: this.data.fontSize - 2 })
    }
  },

  // 主题切换
  switchTheme(e: WechatMiniprogram.TouchEvent) {
    const theme = e.currentTarget.dataset.theme as string
    this.setData({ theme })
  }
})