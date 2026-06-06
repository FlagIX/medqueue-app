<script setup>
import { ref, onMounted } from 'vue'
import { departmentApi } from '@/api/department'

const departments = ref([])
const loading = ref(false)

onMounted(() => load())

async function load() {
  loading.value = true
  try {
    const res = await departmentApi.list()
    if (res.success) departments.value = res.data || []
  } finally { loading.value = false }
}
</script>

<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <h2 class="sidebar-title">MedQueue 管理</h2>
      <el-menu router :default-active="$route.path" background-color="#1f2d3d" text-color="#bfcbd9" active-text-color="#409eff">
        <el-menu-item index="/admin/dashboard"><el-icon><DataAnalysis /></el-icon>仪表盘</el-menu-item>
        <el-menu-item index="/admin/hospital"><el-icon><HomeFilled /></el-icon>医院管理</el-menu-item>
        <el-menu-item index="/admin/department"><el-icon><Grid /></el-icon>科室管理</el-menu-item>
        <el-menu-item index="/admin/doctor"><el-icon><UserFilled /></el-icon>医生管理</el-menu-item>
        <el-menu-item index="/admin/schedule"><el-icon><Calendar /></el-icon>排班管理</el-menu-item>
        <el-menu-item index="/admin/appointment"><el-icon><Document /></el-icon>预约管理</el-menu-item>
      </el-menu>
    </aside>
    <main class="main-content">
      <div class="topbar">科室管理</div>
      <div class="content">
        <h2>科室列表</h2>
        <el-table :data="departments" v-loading="loading" border style="margin-top:16px">
          <el-table-column prop="id" label="ID" width="60" />
          <el-table-column prop="name" label="科室名称" />
          <el-table-column prop="sort" label="排序" width="80" />
        </el-table>
      </div>
    </main>
  </div>
</template>

<style scoped>
.admin-layout { display: flex; min-height: 100vh; }
.sidebar { width: 220px; background: #1f2d3d; flex-shrink: 0; }
.sidebar-title { color: #fff; font-size: 16px; padding: 20px; text-align: center; }
.main-content { flex: 1; display: flex; flex-direction: column; }
.topbar { height: 50px; background: #fff; border-bottom: 1px solid #e4e7ed; display: flex; align-items: center; padding: 0 20px; font-weight: 600; }
.content { padding: 24px; }
</style>
