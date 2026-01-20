// src/types/index.ts

export interface Book {
  id: number
  title: string
  author: string
  cover_url: string
  description: string
  content: string
  created_at?: string
  updated_at?: string
}

export interface User {
  id: number
  username: string
  email: string
  created_at?: string
  updated_at?: string
}

export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
}

export interface Pagination<T> {
  list: T[]
  total: number
  page: number
  page_size: number
}