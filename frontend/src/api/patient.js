import request from './request'

export const patientApi = {
  list() {
    return request.get('/patient/list')
  },
  save(data) {
    return request.post('/patient', data)
  },
  remove(id) {
    return request.delete(`/patient/${id}`)
  }
}
