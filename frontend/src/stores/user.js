import { defineStore } from 'pinia'
import { ref } from 'vue'
import { userApi } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('token') || '')

  async function fetchUser() {
    if (!token.value) return
    try {
      const res = await userApi.getMe()
      if (res.success) {
        user.value = res.data
      }
    } catch (_) {}
  }

  // 初始化时如果有 token 则拉取用户信息
  if (token.value) {
    fetchUser()
  }

  async function login(loginForm) {
    const res = await userApi.login(loginForm)
    if (res.success) {
      token.value = res.data
      localStorage.setItem('token', res.data)
      await fetchUser()
    }
    return res
  }

  function logout() {
    user.value = null
    token.value = ''
    localStorage.removeItem('token')
    userApi.logout()
  }

  async function register(registerForm) {
    return await userApi.register(registerForm)
  }

  return { user, token, login, fetchUser, logout, register }
})
