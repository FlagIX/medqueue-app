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
  byType(typeId, params) {
    return request.get('/hospital/of/type', { params: { typeId, ...params } })
  },
  save(data) {
    return request.post('/hospital', data)
  },
  update(data) {
    return request.put('/hospital', data)
  }
}
