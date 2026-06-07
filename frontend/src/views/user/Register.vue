<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { userApi } from '@/api/user'

const router = useRouter()
const userStore = useUserStore()

const phone = ref('')
const nickName = ref('')
const password = ref('')
const confirmPassword = ref('')
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

async function handleRegister() {
  if (!/^1[3-9]\d{9}$/.test(phone.value)) {
    return ElMessage.warning('请输入正确的手机号')
  }
  if (!password.value || password.value.length < 6) {
    return ElMessage.warning('密码长度不能少于6位')
  }
  if (password.value !== confirmPassword.value) {
    return ElMessage.warning('两次密码输入不一致')
  }
  if (!code.value || code.value.length !== 6) {
    return ElMessage.warning('请输入验证码')
  }
  loading.value = true
  try {
    const res = await userStore.register({
      phone: phone.value,
      nickName: nickName.value,
      password: password.value,
      code: code.value
    })
    if (res.success) {
      ElMessage.success('注册成功')
      router.push('/login')
    }
  } catch (e) {
    console.error('注册失败:', e)
  } finally {
    loading.value = false
  }
}

function goLogin() {
  router.push('/login')
}
</script>

<template>
  <div class="register-page">
    <div class="register-card">
      <h2 class="title">MedQueue</h2>
      <p class="subtitle">创建账号</p>

      <el-form label-width="0" class="register-form">
        <el-form-item>
          <el-input v-model="phone" placeholder="手机号" size="large" maxlength="11" />
        </el-form-item>

        <el-form-item>
          <el-input v-model="nickName" placeholder="昵称（选填）" size="large" maxlength="20" />
        </el-form-item>

        <el-form-item>
          <el-input
            v-model="password"
            type="password"
            placeholder="密码（不少于6位）"
            size="large"
            show-password
          />
        </el-form-item>

        <el-form-item>
          <el-input
            v-model="confirmPassword"
            type="password"
            placeholder="确认密码"
            size="large"
            show-password
          />
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
            @click="handleRegister"
          >注册</el-button>
        </el-form-item>
      </el-form>

      <div class="login-link">
        已有账号？<span @click="goLogin">去登录</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.register-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #e8f4fd 0%, #f0f5ff 100%);
}
.register-card {
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
.register-form {
  max-width: 320px;
  margin: 0 auto;
}
.code-row {
  display: flex;
  gap: 8px;
  width: 100%;
}
.login-link {
  text-align: center;
  margin-top: 16px;
  font-size: 14px;
  color: #909399;
}
.login-link span {
  color: var(--color-primary);
  cursor: pointer;
}
.login-link span:hover {
  text-decoration: underline;
}
</style>
