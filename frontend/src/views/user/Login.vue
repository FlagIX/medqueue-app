<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { userApi } from '@/api/user'

const router = useRouter()
const userStore = useUserStore()
const phone = ref('')
const code = ref('')
const codeBtnText = ref('获取验证码')
const codeBtnDisabled = ref(false)
const loading = ref(false)

async function sendCode() {
  if (!/^1[3-9]\d{9}$/.test(phone.value)) {
    return ElMessage.warning('请输入正确的手机号')
  }
  codeBtnDisabled.value = true
  let count = 60
  codeBtnText.value = `${count}s`
  const timer = setInterval(() => {
    count--
    if (count <= 0) {
      clearInterval(timer)
      codeBtnText.value = '重新获取'
      codeBtnDisabled.value = false
    } else {
      codeBtnText.value = `${count}s`
    }
  }, 1000)
  try {
    await userApi.sendCode(phone.value)
    ElMessage.success('验证码已发送')
  } catch {
    clearInterval(timer)
    codeBtnDisabled.value = false
    codeBtnText.value = '获取验证码'
  }
}

async function handleLogin() {
  if (!phone.value || !code.value) return ElMessage.warning('请填写完整')
  loading.value = true
  try {
    const res = await userStore.login({ phone: phone.value, code: code.value })
    if (res.success) {
      ElMessage.success('登录成功')
      router.push('/')
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-card">
      <h2 class="title">MedQueue</h2>
      <p class="subtitle">医疗预约挂号平台</p>
      <el-form label-width="0" class="login-form">
        <el-form-item>
          <el-input v-model="phone" placeholder="手机号" size="large" maxlength="11" />
        </el-form-item>
        <el-form-item>
          <div class="code-row">
            <el-input v-model="code" placeholder="验证码" size="large" maxlength="6" style="flex:1" />
            <el-button
              :disabled="codeBtnDisabled"
              @click="sendCode"
              size="large"
            >{{ codeBtnText }}</el-button>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            size="large"
            :loading="loading"
            style="width:100%"
            @click="handleLogin"
          >登录 / 注册</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #e8f4fd 0%, #f0f5ff 100%);
}
.login-card {
  width: 400px;
  padding: 40px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
}
.title {
  text-align: center;
  color: var(--color-primary);
  font-size: 28px;
  margin-bottom: 4px;
}
.subtitle {
  text-align: center;
  color: #909399;
  font-size: 14px;
  margin-bottom: 32px;
}
.login-form {
  max-width: 320px;
  margin: 0 auto;
}
.code-row {
  display: flex;
  gap: 8px;
  width: 100%;
}
</style>
