import request from './request'

export const doctorApi = {
  page(params) {
    return request.get('/doctor/page', { params })
  },
  getById(id) {
    return request.get(`/doctor/${id}`)
  },
  getSchedule(id, params) {
    return request.get(`/doctor/${id}/schedule`, { params })
  },
  byHospital(hospitalId, params) {
    return request.get('/doctor/of/hospital', { params: { hospitalId, ...params } })
  },
  byDepartment(departmentId, params) {
    return request.get('/doctor/of/department', { params: { departmentId, ...params } })
  },
  save(data) {
    return request.post('/doctor', data)
  },
  update(data) {
    return request.put('/doctor', data)
  }
}
