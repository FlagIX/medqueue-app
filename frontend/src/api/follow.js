import request from './request'

export const followApi = {
  follow(id, type = 0) {
    return request.post(`/follow/${id}`, null, { params: { type } })
  },
  unfollow(id, type = 0) {
    return request.delete(`/follow/${id}`, { params: { type } })
  },
  list(params) {
    return request.get('/follow/list', { params })
  },
  isFollow(id, type = 0) {
    return request.get(`/follow/or/${id}/${type}`)
  }
}
