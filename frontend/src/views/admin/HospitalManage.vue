<script setup>
import { ref, onMounted } from 'vue'
import { hospitalApi } from '@/api/hospital'
import { departmentApi } from '@/api/department'

const hospitals = ref([])
const departments = ref([])
const total = ref(0)
const current = ref(1)
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const form = ref({})
const pageSize = 10

onMounted(async () => {
  const dRes = await departmentApi.list()
  if (dRes.success) departments.value = dRes.data || []
  loadHospitals()
})

async function loadHospitals() {
  loading.value = true
  try {
    const res = await hospitalApi.page({ current: current.value, pageSize })
    if (res.success) { hospitals.value = res.data?.records || []; total.value = res.data?.total || 0 }
  } finally { loading.value = false }
}

function openAdd() {
  isEdit.value = false
  form.value = { name: '', level: '综合', address: '', phone: '', openHours: '08:00-17:00' }
  dialogVisible.value = true
}

function openEdit(row) {
  isEdit.value = true
  form.value = { ...row }
  dialogVisible.value = true
}

async function handleSave() {
  loading.value = true
  try {
    const res = isEdit.value ? await hospitalApi.update(form.value) : await hospitalApi.save(form.value)
    if (res.success) { ElMessage.success(isEdit.value ? '更新成功' : '添加成功'); dialogVisible.value = false; loadHospitals() }
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
      <div class="topbar">医院管理</div>
      <div class="content">
        <div class="flex-between"><h2>医院列表</h2><el-button type="primary" @click="openAdd">新增医院</el-button></div>
        <el-table :data="hospitals" v-loading="loading" style="margin-top:16px" border>
          <el-table-column prop="id" label="ID" width="60" />
          <el-table-column prop="name" label="医院名称" min-width="150" />
          <el-table-column prop="level" label="等级" width="100" />
          <el-table-column prop="area" label="区域" width="120" />
          <el-table-column prop="address" label="地址" min-width="200" />
          <el-table-column prop="phone" label="电话" width="140" />
          <el-table-column label="评分" width="80">
            <template #default="{ row }">{{ row.score ? (row.score/10).toFixed(1) : '—' }}</template>
          </el-table-column>
          <el-table-column label="操作" width="120" fixed="right">
            <template #default="{ row }"><el-button type="primary" link @click="openEdit(row)">编辑</el-button></template>
          </el-table-column>
        </el-table>
        <div class="pagination-wrap" v-if="total > pageSize">
          <el-pagination v-model:current-page="current" :total="total" :page-size="pageSize" layout="prev,pager,next" @current-change="loadHospitals" />
        </div>
      </div>
    </main>
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑医院' : '新增医院'" width="600px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="名称"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="等级"><el-select v-model="form.level"><el-option label="三甲" value="三甲" /><el-option label="三乙" value="三乙" /><el-option label="二甲" value="二甲" /><el-option label="社区医院" value="社区医院" /><el-option label="综合" value="综合" /></el-select></el-form-item>
        <el-form-item label="区域"><el-input v-model="form.area" /></el-form-item>
        <el-form-item label="地址"><el-input v-model="form.address" /></el-form-item>
        <el-form-item label="电话"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="时间"><el-input v-model="form.openHours" placeholder="08:00-17:00" /></el-form-item>
        <el-form-item label="经度"><el-input v-model="form.x" /></el-form-item>
        <el-form-item label="纬度"><el-input v-model="form.y" /></el-form-item>
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
.pagination-wrap { display: flex; justify-content: center; margin-top: 20px; }
</style>
