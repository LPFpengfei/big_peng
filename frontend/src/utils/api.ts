// src/utils/api.ts
import { ApiResponse, Book, User } from '../types'

const BASE_URL = 'http://localhost:3000/api'

export class Api {
  static request<T>(url: string, options: Partial<WechatMiniprogram.RequestOption> = {}): Promise<ApiResponse<T>> {
    return new Promise((resolve, reject) => {
      const token = wx.getStorageSync('token')

      wx.request({
        url: `${BASE_URL}${url}`,
        header: {
          'Content-Type': 'application/json',
          'Authorization': token ? `Bearer ${token}` : '',
          ...options.header
        },
        method: options.method || 'GET',
        data: options.data,
        success: (res) => {
          const response = res.data as ApiResponse<T>
          if (response.code === 200) {
            resolve(response)
          } else {
            reject(new Error(response.message || '请求失败'))
          }
        },
        fail: (err) => {
          reject(new Error(err.errMsg || '网络错误'))
        }
      })
    })
  }

  static get<T>(url: string, params?: any): Promise<ApiResponse<T>> {
    return this.request<T>(url, {
      method: 'GET',
      data: params
    })
  }

  static post<T>(url: string, data?: any): Promise<ApiResponse<T>> {
    return this.request<T>(url, {
      method: 'POST',
      data
    })
  }

  static put<T>(url: string, data?: any): Promise<ApiResponse<T>> {
    return this.request<T>(url, {
      method: 'PUT',
      data
    })
  }

  static delete<T>(url: string): Promise<ApiResponse<T>> {
    return this.request<T>(url, {
      method: 'DELETE'
    })
  }
}

// 书籍相关API
export const bookApi = {
  getBooks(params?: { page?: number; page_size?: number }) {
    return Api.get<Book[]>('/books', params)
  },

  getBookById(id: number) {
    return Api.get<Book>(`/books/${id}`)
  },

  addBook(data: Omit<Book, 'id' | 'created_at' | 'updated_at'>) {
    return Api.post<Book>('/books', data)
  },

  updateBook(id: number, data: Partial<Book>) {
    return Api.put<Book>(`/books/${id}`, data)
  },

  deleteBook(id: number) {
    return Api.delete<Book>(`/books/${id}`)
  }
}

// 用户相关API
export const userApi = {
  login(data: { username: string; password: string }) {
    return Api.post<{ token: string; user: User }>('/auth/login', data)
  },

  register(data: { username: string; email: string; password: string }) {
    return Api.post<User>('/auth/register', data)
  },

  getProfile() {
    return Api.get<User>('/auth/profile')
  }
}