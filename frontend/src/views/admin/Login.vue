<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { adminApi } from '@/api/admin'

const router = useRouter()
const form = ref({ username: '', password: '' })
const loading = ref(false)

async function handleLogin() {
  if (!form.value.username || !form.value.password) {
    return ElMessage.warning('请输入账号和密码')
  }
  loading.value = true
  try {
    const res = await adminApi.login(form.value)
    if (res.success) {
      localStorage.setItem('adminToken', res.data)
      ElMessage.success('欢迎回来')
      router.push('/admin/dashboard')
    }
  } catch {
    // 错误已由响应拦截器统一处理
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="admin-login">
    <div class="login-box">
      <h2>管理端登录</h2>
      <el-form :model="form">
        <el-form-item><el-input v-model="form.username" placeholder="管理员账号" size="large" /></el-form-item>
        <el-form-item><el-input v-model="form.password" type="password" placeholder="密码" size="large" show-password /></el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" style="width:100%" :loading="loading" @click="handleLogin">登录</el-button>
        </el-form-item>
      </el-form>
      <p class="tip">默认账号 admin / admin123</p>
    </div>
  </div>
</template>

<style scoped>
.admin-login {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #1f2d3d;
}
.login-box {
  width: 380px;
  padding: 40px;
  background: #fff;
  border-radius: 8px;
}
.login-box h2 { text-align: center; margin-bottom: 24px; }
.tip { text-align: center; color: #909399; font-size: 12px; margin-top: 16px; }
</style>
