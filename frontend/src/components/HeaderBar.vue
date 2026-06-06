<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { departmentApi } from '@/api/department'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const departments = ref([])
const searchKeyword = ref('')
const drawerVisible = ref(false)

onMounted(async () => {
  try {
    const res = await departmentApi.list()
    if (res.success) departments.value = res.data || []
  } catch (_) {}
})

function goHome() { router.push('/') }
function goDepartment(id) { router.push(`/hospital?deptId=${id}`) }
function goLogin() { router.push('/login') }
function goMyAppointments() { router.push('/appointment/list') }
function goMyPatients() { router.push('/patient') }
function goMyReviews() { router.push('/review/list') }
function goMyFollows() { router.push('/follow/list') }

function doSearch() {
  if (searchKeyword.value.trim()) {
    router.push(`/hospital?name=${searchKeyword.value.trim()}`)
  }
}

function handleLogout() {
  userStore.logout()
  router.push('/')
}
</script>

<template>
  <header class="header">
    <div class="header-inner">
      <div class="logo" @click="goHome">
        <span class="logo-icon">+</span>
        <span class="logo-text">MedQueue</span>
      </div>

      <div class="search-box">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索医院名称..."
          clearable
          @keyup.enter="doSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        <el-button type="primary" @click="doSearch">搜索</el-button>
      </div>

      <div class="nav-links">
        <el-button text @click="goHome">首页</el-button>
        <el-dropdown v-if="departments.length" trigger="hover">
          <el-button text>科室 <el-icon><ArrowDown /></el-icon></el-button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item
                v-for="d in departments"
                :key="d.id"
                @click="goDepartment(d.id)"
              >{{ d.name }}</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>

      <div class="user-area">
        <template v-if="userStore.user">
          <el-dropdown trigger="hover">
            <el-button text>
              <el-icon><User /></el-icon>
              {{ userStore.user.nickName || '用户' }}
            </el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="goMyAppointments">我的预约</el-dropdown-item>
                <el-dropdown-item @click="goMyPatients">就诊人管理</el-dropdown-item>
                <el-dropdown-item @click="goMyReviews">我的评价</el-dropdown-item>
                <el-dropdown-item @click="goMyFollows">我的关注</el-dropdown-item>
                <el-dropdown-item divided @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
        <template v-else>
          <el-button type="primary" @click="goLogin">登录</el-button>
        </template>
      </div>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: #fff;
  border-bottom: 1px solid #e4e7ed;
  position: sticky;
  top: 0;
  z-index: 100;
}
.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: var(--header-height);
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 0 20px;
}
.logo {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  flex-shrink: 0;
}
.logo-icon {
  width: 32px;
  height: 32px;
  background: var(--color-primary);
  color: #fff;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: bold;
}
.logo-text {
  font-size: 18px;
  font-weight: 700;
  color: var(--color-primary);
}
.search-box {
  flex: 1;
  max-width: 400px;
  display: flex;
  gap: 8px;
}
.nav-links {
  display: flex;
  gap: 4px;
  flex-shrink: 0;
}
.user-area {
  flex-shrink: 0;
  margin-left: auto;
}
</style>
