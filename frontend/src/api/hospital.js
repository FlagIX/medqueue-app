import request from './request'

export const hospitalApi = {
  getById(id) {
    return request.get(`/hospital/${id}`)
  },
  page(params) {
    return request.get('/hospital/page', { params })
  },
  nearby(params) {
    return request.get('/hospital/nearby', { params })
  },
  save(data) {
    return request.post('/hospital', data)
  },
  update(data) {
    return request.put('/hospital', data)
  }
}
