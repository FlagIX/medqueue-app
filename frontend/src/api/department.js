import request from './request'

export const departmentApi = {
  list() {
    return request.get('/department/list')
  }
}
