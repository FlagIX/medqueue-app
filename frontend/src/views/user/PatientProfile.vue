<script setup>
import { ref, onMounted } from 'vue'
import { patientApi } from '@/api/patient'
import { ElMessage, ElMessageBox } from 'element-plus'
import { PATIENT_RELATIONS } from '@/utils/constants'

const patients = ref([])
const dialogVisible = ref(false)
const editingId = ref(null)
const form = ref({ name: '', idCard: '', phone: '', relation: '本人' })
const loading = ref(false)

onMounted(() => loadPatients())

async function loadPatients() {
  const res = await patientApi.list()
  if (res.success) patients.value = res.data || []
}

function openAdd() {
  editingId.value = null
  form.value = { name: '', idCard: '', phone: '', relation: '本人' }
  dialogVisible.value = true
}

function openEdit(p) {
  editingId.value = p.id
  form.value = { name: p.name, idCard: p.idCard, phone: p.phone, relation: p.relation }
  dialogVisible.value = true
}

async function handleSave() {
  if (!form.value.name || !form.value.idCard) return ElMessage.warning('请填写完整')
  loading.value = true
  try {
    const res = editingId.value
      ? await patientApi.update({ ...form.value, id: editingId.value })
      : await patientApi.save(form.value)
    if (res.success) {
      ElMessage.success(editingId.value ? '已更新' : '添加成功')
      dialogVisible.value = false
      await loadPatients()
    } else {
      ElMessage.error(res.errorMsg || '操作失败')
    }
  } catch (e) {
    ElMessage.error(e.message || '操作失败')
  } finally {
    loading.value = false
  }
}

async function handleRemove(id) {
  try {
    await ElMessageBox.confirm('确定删除该就诊人？')
    const res = await patientApi.remove(id)
    if (res.success) { ElMessage.success('已删除'); loadPatients() }
  } catch {}
}
</script>

<template>
  <div class="page-container">
    <div class="card">
      <div class="flex-between">
        <h2>就诊人管理</h2>
        <el-button type="primary" @click="openAdd">添加就诊人</el-button>
      </div>

      <div v-if="patients.length" class="patient-list">
        <div v-for="p in patients" :key="p.id" class="patient-card">
          <div class="info">
            <strong>{{ p.name }}</strong>
            <el-tag size="small">{{ p.relation }}</el-tag>
          </div>
          <p>身份证：{{ p.idCard }}</p>
          <p>手机号：{{ p.phone }}</p>
          <el-button type="primary" text @click="openEdit(p)">编辑</el-button>
          <el-button type="danger" text @click="handleRemove(p.id)">删除</el-button>
        </div>
      </div>
      <el-empty v-else description="暂无就诊人" />

      <el-dialog v-model="dialogVisible" :title="editingId ? '编辑就诊人' : '添加就诊人'" width="450px">
        <el-form :model="form" label-width="80px">
          <el-form-item label="姓名"><el-input v-model="form.name" /></el-form-item>
          <el-form-item label="身份证"><el-input v-model="form.idCard" maxlength="18" /></el-form-item>
          <el-form-item label="手机号"><el-input v-model="form.phone" maxlength="11" /></el-form-item>
          <el-form-item label="关系">
            <el-select v-model="form.relation">
              <el-option v-for="r in PATIENT_RELATIONS" :key="r" :label="r" :value="r" />
            </el-select>
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" :loading="loading" @click="handleSave">保存</el-button>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<style scoped>
.patient-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 12px; margin-top: 16px; }
.patient-card {
  padding: 16px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
}
.patient-card .info { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.patient-card p { font-size: 13px; color: #606266; margin-bottom: 4px; }
</style>
