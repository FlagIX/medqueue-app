import request from './request'

export const adminApi = {
  login(data) {
    return request.post('/admin/login', data)
  }
}
