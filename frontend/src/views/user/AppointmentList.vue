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

// 详情弹窗
const detailVisible = ref(false)
const detailData = ref(null)
const detailLoading = ref(false)

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
    if (res.success) {
      ElMessage.success({ message: '已取消', duration: 2000 })
      loadRecords()
    }
  } catch {}
}

async function showDetail(row) {
  detailLoading.value = true
  detailVisible.value = true
  try {
    const res = await appointmentApi.detail(row.id)
    if (res.success) detailData.value = res.data
  } catch { detailVisible.value = false }
  finally { detailLoading.value = false }
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

      <el-table :data="records" v-loading="loading" style="margin-top:16px" @row-click="showDetail">
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
              @click.stop="handleCancel(row.id)"
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

    <!-- 预约详情弹窗 -->
    <el-dialog v-model="detailVisible" title="预约详情" width="500px" :close-on-click-modal="false">
      <el-skeleton :loading="detailLoading" animated :count="5">
        <el-descriptions v-if="detailData" :column="1" border>
          <el-descriptions-item label="订单号">{{ detailData.id }}</el-descriptions-item>
          <el-descriptions-item label="医院">{{ detailData.hospitalName || '—' }}</el-descriptions-item>
          <el-descriptions-item label="医生">
            {{ detailData.doctorName || '—' }}
            <el-tag size="small" style="margin-left:6px" v-if="detailData.doctorTitle">{{ detailData.doctorTitle }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="就诊人">{{ detailData.patientName || '—' }}</el-descriptions-item>
          <el-descriptions-item label="预约日期">{{ detailData.appointDate }}</el-descriptions-item>
          <el-descriptions-item label="就诊时段">{{ detailData.timeSlot }}</el-descriptions-item>
          <el-descriptions-item label="挂号费" v-if="detailData.fee != null">
            {{ (detailData.fee / 100).toFixed(2) }} 元
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="getStatusTag(detailData.status).type">{{ getStatusTag(detailData.status).label }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ detailData.createTime }}</el-descriptions-item>
        </el-descriptions>
      </el-skeleton>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.pagination-wrap { display: flex; justify-content: center; margin-top: 20px; }
</style>
