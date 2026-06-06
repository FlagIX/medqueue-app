<script setup>
import { ref, onMounted } from 'vue'
import { doctorApi } from '@/api/doctor'
import { hospitalApi } from '@/api/hospital'
import { departmentApi } from '@/api/department'

const doctors = ref([])
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
  const [hRes, dRes] = await Promise.all([hospitalApi.page({ current: 1, pageSize: 999 }), departmentApi.list()])
  if (hRes.success) hospitals.value = hRes.data?.records || []
  if (dRes.success) departments.value = dRes.data || []
  load()
})

async function load() {
  loading.value = true
  try {
    const res = await doctorApi.page({ current: current.value, pageSize })
    if (res.success) { doctors.value = res.data?.records || []; total.value = res.data?.total || 0 }
  } finally { loading.value = false }
}

function openAdd() {
  isEdit.value = false; form.value = { name: '', title: '主治医师', hospitalId: null, departmentId: null, introduction: '' }
  dialogVisible.value = true
}
function openEdit(row) { isEdit.value = true; form.value = { ...row }; dialogVisible.value = true }

async function handleSave() {
  loading.value = true
  try {
    const res = isEdit.value ? await doctorApi.update(form.value) : await doctorApi.save(form.value)
    if (res.success) { ElMessage.success(isEdit.value ? '更新成功' : '添加成功'); dialogVisible.value = false; load() }
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
      <div class="topbar">医生管理</div>
      <div class="content">
        <div class="flex-between"><h2>医生列表</h2><el-button type="primary" @click="openAdd">新增医生</el-button></div>
        <el-table :data="doctors" v-loading="loading" border style="margin-top:16px">
          <el-table-column prop="id" label="ID" width="60" />
          <el-table-column prop="name" label="姓名" width="100" />
          <el-table-column prop="title" label="职称" width="120" />
          <el-table-column prop="introduction" label="简介" min-width="200" show-overflow-tooltip />
          <el-table-column label="操作" width="120" fixed="right">
            <template #default="{ row }"><el-button type="primary" link @click="openEdit(row)">编辑</el-button></template>
          </el-table-column>
        </el-table>
        <div class="pagination-wrap" v-if="total > pageSize">
          <el-pagination v-model:current-page="current" :total="total" :page-size="pageSize" layout="prev,pager,next" @current-change="load" />
        </div>
      </div>
    </main>
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑医生' : '新增医生'" width="550px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="姓名"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="职称"><el-select v-model="form.title"><el-option label="住院医师" value="住院医师" /><el-option label="主治医师" value="主治医师" /><el-option label="副主任医师" value="副主任医师" /><el-option label="主任医师" value="主任医师" /></el-select></el-form-item>
        <el-form-item label="所属医院"><el-select v-model="form.hospitalId" filterable><el-option v-for="h in hospitals" :key="h.id" :label="h.name" :value="h.id" /></el-select></el-form-item>
        <el-form-item label="所属科室"><el-select v-model="form.departmentId"><el-option v-for="d in departments" :key="d.id" :label="d.name" :value="d.id" /></el-select></el-form-item>
        <el-form-item label="简介"><el-input v-model="form.introduction" type="textarea" :rows="3" /></el-form-item>
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
