import request from './request'

export const reviewApi = {
  page(params) {
    return request.get('/review/page', { params })
  },
  save(data) {
    return request.post('/review', data)
  },
  like(id) {
    return request.put(`/review/like/${id}`)
  }
}
