import request from './request'

export const userApi = {
  sendCode(phone) {
    return request.post('/user/code', null, { params: { phone } })
  },
  login(data) {
    return request.post('/user/login', data)
  },
  logout() {
    return request.post('/user/logout')
  },
  getMe() {
    return request.get('/user/me')
  },
  register(data) {
    return request.post('/user/register', data)
  }
}
