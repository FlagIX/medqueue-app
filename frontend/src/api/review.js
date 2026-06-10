import request from './request'

export const reviewApi = {
  page(params) {
    return request.get('/review/page', { params })
  },
  byHospital(hospitalId, params) {
    return request.get(`/review/of/hospital/${hospitalId}`, { params })
  },
  save(data) {
    return request.post('/review', data)
  },
  like(id) {
    return request.put(`/review/like/${id}`)
  },
  ofMe(params) {
    return request.get('/review/of/me', { params })
  },
  hot(params) {
    return request.get('/review/hot', { params })
  }
}
