<script setup>
import { ref, onMounted } from 'vue'
import { hospitalApi } from '@/api/hospital'
import { appointmentApi } from '@/api/appointment'

const stats = ref({ hospitals: 0, todayAppointments: 0, pendingAppointments: 0 })

onMounted(async () => {
  try {
    const hRes = await hospitalApi.page({ current: 1, pageSize: 1 })
    const aRes = await appointmentApi.list({ current: 1, pageSize: 1 })
    stats.value.hospitals = hRes.success ? hRes.data?.total || 0 : 0
    stats.value.pendingAppointments = aRes.success ? aRes.data?.total || 0 : 0
  } catch (_) {}
})
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
      <div class="topbar">后台管理</div>
      <div class="content">
        <h2>仪表盘</h2>
        <div class="stat-grid">
          <div class="stat-card"><h3>{{ stats.hospitals }}</h3><p>医院总数</p></div>
          <div class="stat-card"><h3>{{ stats.pendingAppointments }}</h3><p>总预约数</p></div>
          <div class="stat-card"><h3>—</h3><p>今日预约</p></div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
.admin-layout { display: flex; min-height: 100vh; }
.sidebar {
  width: 220px;
  background: #1f2d3d;
  flex-shrink: 0;
}
.sidebar-title {
  color: #fff;
  font-size: 16px;
  padding: 20px;
  text-align: center;
}
.main-content { flex: 1; display: flex; flex-direction: column; }
.topbar {
  height: 50px;
  background: #fff;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  align-items: center;
  padding: 0 20px;
  font-weight: 600;
}
.content { padding: 24px; }
.stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-top: 16px; }
.stat-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  text-align: center;
  box-shadow: 0 1px 4px rgba(0,0,0,0.08);
}
.stat-card h3 { font-size: 32px; color: var(--color-primary); }
.stat-card p { color: #909399; margin-top: 8px; }
</style>
