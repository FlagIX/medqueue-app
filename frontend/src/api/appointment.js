import request from './request'

export const appointmentApi = {
  create(data) {
    return request.post('/appointment', data)
  },
  list(params) {
    return request.get('/appointment/list', { params })
  },
  cancel(id) {
    return request.put(`/appointment/${id}/cancel`)
  }
}
