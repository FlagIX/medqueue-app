<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { userApi } from '@/api/user'

const router = useRouter()
const userStore = useUserStore()

const nickName = ref('')
const icon = ref('')
const city = ref('')
const introduce = ref('')
const gender = ref(null)
const birthday = ref('')
const loading = ref(true)
const saving = ref(false)

onMounted(async () => {
  loading.value = true
  try {
    if (userStore.user) {
      nickName.value = userStore.user.nickName || ''
      icon.value = userStore.user.icon || ''
    }
    const res = await userApi.getUserInfo()
    if (res.success && res.data) {
      city.value = res.data.city || ''
      introduce.value = res.data.introduce || ''
      gender.value = res.data.gender
      birthday.value = res.data.birthday || ''
    }
  } catch (e) {
    console.error('加载用户信息失败:', e)
  } finally {
    loading.value = false
  }
})

async function handleSave() {
  if (!nickName.value || !nickName.value.trim()) {
    return ElMessage.warning('请输入昵称')
  }
  saving.value = true
  try {
    const data = {
      nickName: nickName.value.trim()
    }
    if (city.value) data.city = city.value
    if (introduce.value) data.introduce = introduce.value
    if (gender.value !== null && gender.value !== undefined) data.gender = gender.value
    if (birthday.value) data.birthday = birthday.value

    const res = await userApi.updateProfile(data)
    if (res.success) {
      ElMessage.success('保存成功')
      if (userStore.user) {
        userStore.user.nickName = nickName.value.trim()
      }
      router.push('/')
    }
  } catch (e) {
    console.error('保存失败:', e)
  } finally {
    saving.value = false
  }
}

function goBack() {
  router.back()
}
</script>

<template>
  <div class="profile-page">
    <div class="profile-card">
      <div class="header">
        <el-button text @click="goBack">&lt; 返回</el-button>
        <h2>个人信息</h2>
      </div>

      <el-form label-width="80px" class="profile-form" v-loading="loading">
        <el-form-item label="昵称">
          <el-input v-model="nickName" placeholder="请输入昵称" maxlength="20" />
        </el-form-item>

        <el-form-item label="城市">
          <el-input v-model="city" placeholder="请输入所在城市" maxlength="20" />
        </el-form-item>

        <el-form-item label="性别">
          <el-radio-group v-model="gender">
            <el-radio :value="false">男</el-radio>
            <el-radio :value="true">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="生日">
          <el-date-picker v-model="birthday" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" style="width:100%" />
        </el-form-item>

        <el-form-item label="简介">
          <el-input v-model="introduce" type="textarea" placeholder="介绍一下自己..." maxlength="128" show-word-limit :rows="3" />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" :loading="saving" @click="handleSave" style="width:100%">保存</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<style scoped>
.profile-page {
  max-width: 600px;
  margin: 40px auto;
  padding: 0 20px;
}
.profile-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
  padding: 32px;
}
.header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 28px;
}
.header h2 {
  margin: 0;
  font-size: 20px;
  color: #303133;
}
.profile-form {
  max-width: 400px;
  margin: 0 auto;
}
</style>
