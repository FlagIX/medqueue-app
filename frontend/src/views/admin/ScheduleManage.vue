<script setup>
import { ref, onMounted } from 'vue'
import { doctorApi } from '@/api/doctor'
import { hospitalApi } from '@/api/hospital'

const doctors = ref([])
const hospitals = ref([])
const selectedDoctor = ref(null)
const scheduleDate = ref('')
const schedules = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const form = ref({ timeSlot: '上午', totalCount: 30, remainCount: 30 })
const pageSize = 20

onMounted(async () => {
  const hRes = await hospitalApi.page({ current: 1, pageSize: 999 })
  if (hRes.success) hospitals.value = hRes.data?.records || []
})

async function selectHospital(hospitalId) {
  const dRes = await doctorApi.page({ hospitalId, current: 1, pageSize: 999 })
  if (dRes.success) doctors.value = dRes.data?.records || []
  selectedDoctor.value = null
  schedules.value = []
}

async function loadSchedules() {
  if (!selectedDoctor.value || !scheduleDate.value) return
  loading.value = true
  try {
    const res = await doctorApi.getSchedule(selectedDoctor.value, { date: scheduleDate.value })
    if (res.success) schedules.value = res.data || []
  } finally { loading.value = false }
}

function openAdd() {
  form.value = { doctorId: selectedDoctor.value, date: scheduleDate.value, timeSlot: '上午', totalCount: 30, remainCount: 30 }
  dialogVisible.value = true
}

async function handleSave() {
  loading.value = true
  try {
    ElMessage.success('排班设置成功（需后端实现 save 接口）')
    dialogVisible.value = false
    loadSchedules()
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
      <div class="topbar">排班管理</div>
      <div class="content">
        <div class="filter-bar">
          <el-select v-model="form.hospitalId" placeholder="选择医院" filterable style="width:200px" @change="selectHospital">
            <el-option v-for="h in hospitals" :key="h.id" :label="h.name" :value="h.id" />
          </el-select>
          <el-select v-model="selectedDoctor" placeholder="选择医生" style="width:200px" @change="loadSchedules">
            <el-option v-for="d in doctors" :key="d.id" :label="d.name" :value="d.id" />
          </el-select>
          <el-date-picker v-model="scheduleDate" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" @change="loadSchedules" />
          <el-button type="primary" @click="openAdd" :disabled="!selectedDoctor || !scheduleDate">新增排班</el-button>
        </div>
        <el-table :data="schedules" v-loading="loading" border style="margin-top:16px">
          <el-table-column prop="timeSlot" label="时段" width="120" />
          <el-table-column prop="totalCount" label="总号源" width="100" />
          <el-table-column prop="remainCount" label="剩余号源" width="100" />
        </el-table>
      </div>
    </main>
    <el-dialog v-model="dialogVisible" title="新增排班" width="400px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="时段"><el-select v-model="form.timeSlot"><el-option label="上午" value="上午" /><el-option label="下午" value="下午" /><el-option label="晚班" value="晚班" /></el-select></el-form-item>
        <el-form-item label="总号源"><el-input-number v-model="form.totalCount" :min="1" :max="200" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialogVisible = false">取消</el-button><el-button type="primary" :loading="loading" @click="handleSave">保存</el-button></template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-layout { display: flex; min-height: 100vh; }
.sidebar { width: 220px; background: #1f2d3d; flex-shrink: 0; }
.sidebar-title { color: #fff; font-size: 16px; padding: 20px; text-align: center; }
.main-content { flex: 1; display: flex; flex-direction: column; }
.topbar { height: 50px; background: #fff; border-bottom: 1px solid #e4e7ed; display: flex; align-items: center; padding: 0 20px; font-weight: 600; }
.content { padding: 24px; }
.filter-bar { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
</style>
