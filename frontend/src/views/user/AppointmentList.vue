<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { appointmentApi } from '@/api/appointment'
import { APPOINTMENT_STATUS } from '@/utils/constants'

const router = useRouter()
const records = ref([])
const total = ref(0)
const current = ref(1)
const statusFilter = ref(null)
const loading = ref(false)
const pageSize = 10

onMounted(() => loadRecords())

async function loadRecords() {
  loading.value = true
  try {
    const params = { current: current.value, pageSize }
    if (statusFilter.value) params.status = statusFilter.value
    const res = await appointmentApi.list(params)
    if (res.success) {
      records.value = res.data?.records || []
      total.value = res.data?.total || 0
    }
  } finally { loading.value = false }
}

function onPageChange(page) { current.value = page; loadRecords() }

async function handleCancel(id) {
  try {
    await ElMessageBox.confirm('确定取消该预约吗？')
    const res = await appointmentApi.cancel(id)
    if (res.success) { ElMessage.success('已取消'); loadRecords() }
  } catch {}
}

function getStatusTag(s) {
  return APPOINTMENT_STATUS[s] || { label: '未知', type: 'info' }
}
</script>

<template>
  <div class="page-container">
    <div class="card">
      <div class="flex-between">
        <h2>我的预约</h2>
        <el-select v-model="statusFilter" placeholder="全部状态" clearable style="width:140px" @change="loadRecords">
          <el-option label="待就诊" :value="1" />
          <el-option label="已就诊" :value="2" />
          <el-option label="已取消" :value="3" />
          <el-option label="已过期" :value="4" />
        </el-select>
      </div>

      <el-table :data="records" v-loading="loading" style="margin-top:16px">
        <el-table-column prop="id" label="订单号" width="180" />
        <el-table-column label="预约日期">
          <template #default="{ row }">{{ row.appointDate }}</template>
        </el-table-column>
        <el-table-column label="时段">
          <template #default="{ row }">{{ row.timeSlot }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusTag(row.status).type">{{ getStatusTag(row.status).label }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button
              v-if="row.status === 1"
              type="danger"
              size="small"
              @click="handleCancel(row.id)"
            >取消预约</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap" v-if="total > pageSize">
        <el-pagination
          v-model:current-page="current"
          :total="total"
          :page-size="pageSize"
          layout="prev, pager, next"
          @current-change="onPageChange"
        />
      </div>
      <el-empty v-if="!loading && !records.length" description="暂无预约记录" />
    </div>
  </div>
</template>

<style scoped>
.pagination-wrap { display: flex; justify-content: center; margin-top: 20px; }
</style>
