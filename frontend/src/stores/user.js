import { defineStore } from 'pinia'
import { ref } from 'vue'
import { userApi } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('token') || '')

  async function login(loginForm) {
    const res = await userApi.login(loginForm)
    if (res.success) {
      token.value = res.data
      localStorage.setItem('token', res.data)
      try { await fetchUser() } catch (_) {}
    }
    return res
  }

  async function fetchUser() {
    const res = await userApi.getMe()
    if (res.success) {
      user.value = res.data
    }
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
