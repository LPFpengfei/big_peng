// api.ts
// API 工具类，处理与后端的通信
import http from '@ohos.net.http';

// API 基础 URL
const BASE_URL = 'http://localhost:3000/api/v1';

// 获取 token
function getToken(): string | undefined {
  return AppStorage.Get<string>('token');
}

// 通用请求方法
async function request(url: string, method: http.RequestMethod, data?: any): Promise<any> {
  // 创建 HTTP 请求
  let httpRequest = http.createHttp();
  
  // 构建请求选项
  let options: http.HttpRequestOptions = {
    method: method,
    header: {
      'Content-Type': 'application/json'
    }
  };
  
  // 添加认证 token
  const token = getToken();
  if (token) {
    options.header['Authorization'] = `Bearer ${token}`;
  }
  
  // 添加请求体
  if (data) {
    options.extraData = data;
  }
  
  try {
    // 发送请求
    let response = await httpRequest.request(BASE_URL + url, options);
    
    // 处理响应
    if (response.responseCode === 200) {
      return JSON.parse(response.result as string);
    } else {
      throw new Error(`Request failed with status ${response.responseCode}`);
    }
  } catch (error) {
    console.error('API request error:', error);
    throw error;
  } finally {
    // 销毁 HTTP 请求
    httpRequest.destroy();
  }
}

// 认证相关 API

// 用户登录
export async function login(email: string, password: string): Promise<any> {
  return request('/auth/login', http.RequestMethod.POST, { email, password });
}

// 用户注册
export async function register(email: string, nickname: string, password: string): Promise<any> {
  return request('/auth/register', http.RequestMethod.POST, { email, nickname, password });
}

// 用户登出
export async function logout(): Promise<any> {
  return request('/auth/logout', http.RequestMethod.DELETE);
}

// 书籍相关 API

// 获取书籍列表
export async function getBooks(params?: { category_id?: number; q?: string; page?: number; per_page?: number }): Promise<any> {
  let url = '/books';
  if (params) {
    const queryString = Object.entries(params)
      .map(([key, value]) => `${key}=${encodeURIComponent(value as string)}`)
      .join('&');
    if (queryString) {
      url += `?${queryString}`;
    }
  }
  return request(url, http.RequestMethod.GET);
}

// 获取书籍详情
export async function getBook(id: number): Promise<any> {
  return request(`/books/${id}`, http.RequestMethod.GET);
}

// 书架相关 API

// 获取书架列表
export async function getBookshelves(): Promise<any> {
  return request('/bookshelves', http.RequestMethod.GET);
}

// 添加到书架
export async function addToBookshelf(bookId: number): Promise<any> {
  return request('/bookshelves', http.RequestMethod.POST, { book_id: bookId });
}

// 从书架移除
export async function removeFromBookshelf(bookshelfId: number): Promise<any> {
  return request(`/bookshelves/${bookshelfId}`, http.RequestMethod.DELETE);
}

// 书签相关 API

// 获取书签列表
export async function getBookmarks(params?: { book_id?: number }): Promise<any> {
  let url = '/bookmarks';
  if (params?.book_id) {
    url += `?book_id=${params.book_id}`;
  }
  return request(url, http.RequestMethod.GET);
}

// 创建书签
export async function createBookmark(bookId: number, chapter: string, page: number, note?: string): Promise<any> {
  return request('/bookmarks', http.RequestMethod.POST, { book_id: bookId, chapter, page, note });
}

// 更新书签
export async function updateBookmark(id: number, data: { chapter?: string; page?: number; note?: string }): Promise<any> {
  return request(`/bookmarks/${id}`, http.RequestMethod.PUT, data);
}

// 删除书签
export async function deleteBookmark(id: number): Promise<any> {
  return request(`/bookmarks/${id}`, http.RequestMethod.DELETE);
}

// 阅读进度相关 API

// 获取阅读进度
export async function getReadingProgress(bookId: number): Promise<any> {
  return request(`/reading_progresses/${bookId}`, http.RequestMethod.GET);
}

// 更新阅读进度
export async function updateReadingProgress(bookId: number, chapter: string, page: number): Promise<any> {
  return request(`/reading_progresses/${bookId}`, http.RequestMethod.PUT, { chapter, page });
}

// 分类相关 API

// 获取分类列表
export async function getCategories(): Promise<any> {
  return request('/categories', http.RequestMethod.GET);
}

// 获取分类详情
export async function getCategory(id: number, params?: { page?: number; per_page?: number }): Promise<any> {
  let url = `/categories/${id}`;
  if (params) {
    const queryString = Object.entries(params)
      .map(([key, value]) => `${key}=${encodeURIComponent(value as string)}`)
      .join('&');
    if (queryString) {
      url += `?${queryString}`;
    }
  }
  return request(url, http.RequestMethod.GET);
}