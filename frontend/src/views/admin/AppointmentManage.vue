<script setup>
import { ref, onMounted } from 'vue'
import { appointmentApi } from '@/api/appointment'
import { APPOINTMENT_STATUS } from '@/utils/constants'

const records = ref([])
const total = ref(0)
const current = ref(1)
const statusFilter = ref(null)
const loading = ref(false)
const pageSize = 10

onMounted(() => load())

async function load() {
  loading.value = true
  try {
    const params = { current: current.value, pageSize }
    if (statusFilter.value) params.status = statusFilter.value
    const res = await appointmentApi.list(params)
    if (res.success) { records.value = res.data?.records || []; total.value = res.data?.total || 0 }
  } finally { loading.value = false }
}

function getStatusTag(s) {
  return APPOINTMENT_STATUS[s] || { label: '未知', type: 'info' }
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
      <div class="topbar">预约管理</div>
      <div class="content">
        <div class="flex-between">
          <h2>预约记录</h2>
          <el-select v-model="statusFilter" placeholder="状态筛选" clearable style="width:140px" @change="load">
            <el-option label="待就诊" :value="1" /><el-option label="已就诊" :value="2" /><el-option label="已取消" :value="3" /><el-option label="已过期" :value="4" />
          </el-select>
        </div>
        <el-table :data="records" v-loading="loading" border style="margin-top:16px">
          <el-table-column prop="id" label="订单号" width="180" />
          <el-table-column prop="appointDate" label="预约日期" width="120" />
          <el-table-column prop="timeSlot" label="时段" width="80" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }"><el-tag :type="getStatusTag(row.status).type">{{ getStatusTag(row.status).label }}</el-tag></template>
          </el-table-column>
        </el-table>
        <div class="pagination-wrap" v-if="total > pageSize">
          <el-pagination v-model:current-page="current" :total="total" :page-size="pageSize" layout="prev,pager,next" @current-change="load" />
        </div>
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
.pagination-wrap { display: flex; justify-content: center; margin-top: 20px; }
</style>
