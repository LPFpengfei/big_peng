// H5版核心逻辑

// 类型定义
class Book {
    constructor(id, title, author, cover_url, description, content) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.cover_url = cover_url;
        this.description = description;
        this.content = content;
    }
}

// 模拟数据
const mockBooks = {
    1: new Book(1, 'JavaScript高级程序设计', 'Nicholas C. Zakas', 'https://via.placeholder.com/150', '深入理解JavaScript语言，从基础到高级应用', '第1章 什么是JavaScript\n\nJavaScript是一种轻量级的脚本语言，最初由Netscape开发，用于增强网页的交互性。随着Web技术的发展，JavaScript已经成为前端开发的核心语言，同时也可以用于后端开发（如Node.js）。\n\nJavaScript具有以下特点：\n1. 解释执行，不需要编译\n2. 弱类型语言\n3. 基于对象和事件驱动\n4. 跨平台兼容性\n\n本章将介绍JavaScript的基本概念和历史发展，帮助读者建立对这门语言的初步认识。'),
    2: new Book(2, 'Python编程：从入门到实践', 'Eric Matthes', 'https://via.placeholder.com/150', '零基础学Python，适合初学者的实践指南', '第1章 起步\n\nPython是一种简单易学、功能强大的编程语言，它具有优雅的语法和丰富的库，适合各种编程任务。本章将引导你安装Python环境，并编写第一个Python程序。\n\n1.1 Python简介\nPython由Guido van Rossum于1989年圣诞节期间开发，最初的设计目标是创建一种易于阅读和编写的编程语言。\n\n1.2 安装Python\n在不同的操作系统上安装Python的方法略有不同，本章将详细介绍Windows、macOS和Linux系统的安装步骤。'),
    3: new Book(3, '算法导论', 'Thomas H. Cormen', 'https://via.placeholder.com/150', '算法领域经典著作，全面介绍算法设计与分析', '第1章 算法在计算中的作用\n\n算法是解决问题的步骤集合，它定义了如何将输入转换为输出。算法是计算机科学的核心概念，几乎所有的计算机程序都依赖于算法。\n\n1.1 算法的定义\n算法是一个有限的指令集，它接收一些输入（也可以没有输入），产生输出，并在有限的步骤内终止。\n\n1.2 算法的重要性\n良好的算法设计对于提高程序的效率至关重要，尤其是在处理大规模数据时。一个高效的算法可以将原本需要几天时间的计算任务缩短到几秒钟。'),
    4: new Book(4, 'TypeScript实战', '张同光', 'https://via.placeholder.com/150', 'TypeScript从入门到精通，实战项目案例', '第1章 TypeScript简介\n\nTypeScript是JavaScript的超集，它添加了静态类型定义和其他高级特性，帮助开发者编写更可靠、更易于维护的代码。\n\n1.1 为什么选择TypeScript？\n- 静态类型检查\n- 更好的IDE支持\n- 更易于重构\n- 适合大型项目\n\n1.2 TypeScript的安装和配置\n本章将介绍如何安装TypeScript，并配置开发环境。'),
    5: new Book(5, 'React设计模式与最佳实践', 'Marco Concetto Rudelli', 'https://via.placeholder.com/150', 'React开发中的设计模式和最佳实践', '第1章 React基础回顾\n\nReact是一个用于构建用户界面的JavaScript库，它采用组件化的开发方式，使开发者能够构建复杂的UI界面。\n\n1.1 React组件\n组件是React应用的基本构建块，每个组件都负责渲染UI的一部分。\n\n1.2 JSX语法\nJSX是JavaScript的扩展语法，它允许开发者在JavaScript代码中编写HTML-like的代码。')
};

// 全局状态
let currentPage = 'indexPage';
let currentTab = '全部';
let bookshelfBooks = [1, 2]; // 书架中的书籍ID
let searchKeyword = '';

// 扩展Book类，添加阅读进度
class BookshelfBook extends Book {
    constructor(id, title, author, cover_url, description, content, progress = 0, lastReadAt = '') {
        super(id, title, author, cover_url, description, content);
    this.progress = progress;
        this.lastReadAt = lastReadAt;
    }
}

// 页面切换函数
function switchPage(pageId, title) {
    // 隐藏所有页面
    const pages = document.querySelectorAll('.page');
    pages.forEach(page => page.classList.remove('active'));
            
    // 显示目标页面
    const targetPage = document.getElementById(pageId);
    if (targetPage) {
        targetPage.classList.add('active');
        currentPage = pageId;

        // 更新导航栏标题
        const navTitle = document.getElementById('navTitle');
        if (navTitle) {
            navTitle.textContent = title;
        }

        // 更新底部导航
        const tabItems = document.querySelectorAll('.tab-bar-item');
        tabItems.forEach(item => item.classList.remove('active'));

        // 激活对应的底部导航项
        if (pageId === 'indexPage') {
            document.querySelectorAll('.tab-bar-item')[0].classList.add('active');
            renderIndexBooks();
        } else if (pageId === 'bookshelfPage') {
            document.querySelectorAll('.tab-bar-item')[1].classList.add('active');
            renderBookshelf();
        } else if (pageId === 'discoverPage') {
        document.querySelectorAll('.tab-bar-item')[2].classList.add('active');
            renderDiscoverBooks();
        }
    }
}

// 渲染首页图书
function renderIndexBooks() {
    const books = [mockBooks[1], mockBooks[2], mockBooks[3]];
    const container = document.getElementById('indexBooks');

    container.innerHTML = books.map(book => `
        <div class="book-item" onclick="goToReader(${book.id})">
            <img class="book-cover" src="${book.cover_url}" alt="${book.title}">
            <text class="book-title">${book.title}</text>
        </div>
    `).join('');
}

// 渲染书架
function renderBookshelf() {
    // 模拟带有阅读进度的数据
    const booksWithProgress = [
        new BookshelfBook(1, 'JavaScript高级程序设计', 'Nicholas C. Zakas', 'https://via.placeholder.com/150', '深入理解JavaScript语言', '...', 45, '2026-01-20'),
        new BookshelfBook(2, 'Python编程：从入门到实践', 'Eric Matthes', 'https://via.placeholder.com/150', '零基础学Python', '...', 78, '2026-01-19'),
        new BookshelfBook(3, '算法导论', 'Thomas H. Cormen', 'https://via.placeholder.com/150', '算法领域经典著作', '...', 23, '2026-01-18')
    ];

    const books = booksWithProgress;
    const container = document.getElementById('bookshelfBooks');
    const emptyTip = document.getElementById('emptyBookshelf');

    if (books.length === 0) {
        container.innerHTML = '';
        emptyTip.style.display = 'block';
    } else {
        container.innerHTML = books.map(book => `
            <div class="bookshelf-item" onclick="goToReader(${book.id})">
                <img class="bookshelf-cover" src="${book.cover_url}" alt="${book.title}">
                <div class="bookshelf-info">
                    <text class="bookshelf-title">${book.title}</text>
                    <text class="bookshelf-author">${book.author}</text>
                    <div class="reading-progress">
                        <div class="progress-bar" style="width: ${book.progress || 0}%"></div>
                    </div>
                </div>
            </div>
        `).join('');
        emptyTip.style.display = 'none';
    }
}

// 切换标签
function switchTab(tabName) {
    // 更新标签状态
    const tabItems = document.querySelectorAll('.tab-item');
    tabItems.forEach(item => {
        item.classList.remove('active');
        if (item.textContent === tabName) {
            item.classList.add('active');
        }
    });

    currentTab = tabName;
    // 这里可以添加根据标签筛选图书的逻辑
    alert(`切换到${tabName}标签`);
}

// 渲染发现页图书
function renderDiscoverBooks() {
    const hotBooks = [mockBooks[1], mockBooks[2], mockBooks[3]];
    const newBooks = [mockBooks[4], mockBooks[5]];

    // 渲染热门推荐
    const hotContainer = document.getElementById('hotBooks');
    hotContainer.innerHTML = hotBooks.map(book => `
        <div class="book-item" onclick="goToReader(${book.id})">
            <img class="book-cover" src="${book.cover_url}" alt="${book.title}">
            <div class="book-info">
                <text class="book-title">${book.title}</text>
                <text class="book-author">${book.author}</text>
                <text class="book-desc">${book.description}</text>
            </div>
            <button class="add-btn" onclick="addToBookshelf(${book.id}, event)">添加</button>
        </div>
    `).join('');

    // 渲染新书上架
    const newContainer = document.getElementById('newBooks');
    newContainer.innerHTML = newBooks.map(book => `
        <div class="book-item" onclick="goToReader(${book.id})">
            <img class="book-cover" src="${book.cover_url}" alt="${book.title}">
            <div class="book-info">
                <text class="book-title">${book.title}</text>
                <text class="book-author">${book.author}</text>
                <text class="book-desc">${book.description}</text>
            </div>
            <button class="add-btn" onclick="addToBookshelf(${book.id}, event)">添加</button>
        </div>
    `).join('');
}

// 分类导航
function goToCategory(category) {
    alert(`查看${category}分类图书`);
}

// 渲染阅读器
function renderReader(bookId) {
    const book = mockBooks[bookId] || mockBooks[1];

    document.getElementById('readerTitle').textContent = book.title;
    document.getElementById('readerAuthor').textContent = book.author;
    document.getElementById('readerContent').textContent = book.content;

    // 更新书架按钮状态
    const bookshelfBtn = document.getElementById('bookshelfBtn');
    const inBookshelf = bookshelfBooks.includes(bookId);
    if (inBookshelf) {
        bookshelfBtn.textContent = '移除书架';
        bookshelfBtn.className = 'btn-secondary';
        bookshelfBtn.onclick = () => removeFromBookshelf(bookId);
    } else {
        bookshelfBtn.textContent = '添加到书架';
        bookshelfBtn.className = 'btn-primary';
        bookshelfBtn.onclick = () => addToBookshelf(bookId);
    }

    // 切换到阅读器页面
    switchPage('readerPage', book.title);
}

// 导航函数
function goToBookshelf() {
    switchPage('bookshelfPage', '我的书架');
}

function goToDiscover() {
    switchPage('discoverPage', '发现好书');
}

function goToReader(bookId) {
    renderReader(bookId);
}

// 书架管理
function addToBookshelf(bookId, event) {
    // 阻止事件冒泡
    if (event) {
        event.stopPropagation();
    }

    if (!bookshelfBooks.includes(bookId)) {
        bookshelfBooks.push(bookId);
        alert('已添加到书架');

        // 如果当前在书架页，重新渲染
        if (currentPage === 'bookshelfPage') {
            renderBookshelf();
        } else if (currentPage === 'readerPage') {
            renderReader(bookId);
        }
    }
}

function removeFromBookshelf(bookId) {
    const index = bookshelfBooks.indexOf(bookId);
    if (index > -1) {
        bookshelfBooks.splice(index, 1);
        alert('已移除书架');

        // 如果当前在书架页，重新渲染
        if (currentPage === 'bookshelfPage') {
            renderBookshelf();
        } else if (currentPage === 'readerPage') {
            renderReader(bookId);
        }
    }
}

// 搜索功能
function onSearchInput(event) {
    searchKeyword = event.target.value;
}

function onSearchKeyPress(event) {
    if (event.key === 'Enter') {
        onSearch();
    }
}

function onSearch() {
    alert(`搜索: ${searchKeyword}`);
    // 这里可以添加搜索逻辑
}

// 阅读器功能
function prevChapter() {
    alert('上一章功能开发中');
}

function nextChapter() {
    alert('下一章功能开发中');
}

// 初始化
function init() {
    // 渲染首页
    renderIndexBooks();
}

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', init);

// 导出全局函数，供HTML调用
window.switchPage = switchPage;
window.goToBookshelf = goToBookshelf;
window.goToDiscover = goToDiscover;
window.goToReader = goToReader;
window.addToBookshelf = addToBookshelf;
window.removeFromBookshelf = removeFromBookshelf;
window.onSearchInput = onSearchInput;
window.onSearchKeyPress = onSearchKeyPress;
window.onSearch = onSearch;
window.prevChapter = prevChapter;
window.nextChapter = nextChapter;