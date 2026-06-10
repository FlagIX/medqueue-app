import request from './request'

export const appointmentApi = {
  create(data) {
    return request.post('/appointment', data)
  },
  list(params) {
    return request.get('/appointment/list', { params })
  },
  detail(id) {
    return request.get(`/appointment/${id}/detail`)
  },
  cancel(id) {
    return request.put(`/appointment/${id}/cancel`)
  }
}
