// Book.ts
// 书籍模型
export interface Book {
  id: number;
  title: string;
  author: string;
  description: string;
  cover_image: string;
  file_path: string;
  category_id: number;
  source: string;
  added_at?: string;
}