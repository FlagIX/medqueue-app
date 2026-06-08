<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { appointmentApi } from '@/api/appointment'
import { patientApi } from '@/api/patient'
import { doctorApi } from '@/api/doctor'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const patients = ref([])
const selectedPatient = ref(null)
const loading = ref(false)
const submitted = ref(false)
const orderId = ref('')
const doctorInfo = ref(null)
const scheduleInfo = ref(null)

const selectedPatientName = computed(() => {
  const p = patients.value.find(p => p.id === selectedPatient.value)
  return p ? p.name : ''
})

onMounted(async () => {
  if (!userStore.user) return router.push('/login')
  const [pRes] = await Promise.all([
    patientApi.list(),
    doctorApi.getById(route.query.doctorId)
  ])
  if (pRes.success) {
    patients.value = pRes.data || []
    if (patients.value.length) selectedPatient.value = patients.value[0].id
  }
  if (route.query.doctorId) {
    const dRes = await doctorApi.getById(route.query.doctorId)
    if (dRes.success) doctorInfo.value = dRes.data
  }
})

async function submit() {
  if (!selectedPatient.value) return ElMessage.warning('请选择就诊人')
  loading.value = true
  try {
    const res = await appointmentApi.create({
      doctorId: Number(route.query.doctorId),
      scheduleId: Number(route.query.scheduleId),
      patientId: selectedPatient.value,
      date: route.query.date,
      timeSlot: route.query.timeSlot
    })
    if (res.success) {
      orderId.value = res.data
      submitted.value = true
    } else {
      ElMessage.error(res.errorMsg || '预约失败')
    }
  } finally { loading.value = false }
}
</script>

<template>
  <div class="page-container">
    <div class="card" v-if="!submitted">
      <h2>确认预约信息</h2>
      <el-descriptions :column="1" border style="margin:20px 0">
        <el-descriptions-item label="医生">{{ doctorInfo?.name || '—' }}</el-descriptions-item>
        <el-descriptions-item label="职称">{{ doctorInfo?.title || '—' }}</el-descriptions-item>
        <el-descriptions-item label="预约日期">{{ route.query.date }}</el-descriptions-item>
        <el-descriptions-item label="就诊时段">{{ route.query.timeSlot }}</el-descriptions-item>
      </el-descriptions>

      <h3>选择就诊人</h3>
      <div class="patient-list">
        <div
          v-for="p in patients"
          :key="p.id"
          :class="['patient-card', { active: selectedPatient === p.id }]"
          @click="selectedPatient = p.id"
        >
          <div class="card-radio">
            <span :class="['radio-circle', { checked: selectedPatient === p.id }]" />
          </div>
          <div class="card-body">
            <strong>{{ p.name }}</strong>
            <span class="tag">{{ p.relation }}</span>
            <span class="idcard">{{ p.idCard }}</span>
          </div>
        </div>
      </div>
      <el-empty v-if="!patients.length" description="暂无就诊人，请先添加" />

      <div style="margin-top:24px">
        <el-button type="primary" size="large" :loading="loading" @click="submit">
          确认预约
        </el-button>
        <el-button size="large" @click="router.push('/patient?redirect=' + encodeURIComponent(route.fullPath))">添加就诊人</el-button>
      </div>
    </div>

    <div v-else class="card success-card">
      <div class="success-icon">✓</div>
      <h2>预约成功</h2>
      <el-descriptions :column="1" border style="margin:24px 0">
        <el-descriptions-item label="订单号">{{ orderId }}</el-descriptions-item>
        <el-descriptions-item label="医生">{{ doctorInfo?.name || '—' }}</el-descriptions-item>
        <el-descriptions-item label="职称">{{ doctorInfo?.title || '—' }}</el-descriptions-item>
        <el-descriptions-item label="就诊人">{{ selectedPatientName }}</el-descriptions-item>
        <el-descriptions-item label="预约日期">{{ route.query.date }}</el-descriptions-item>
        <el-descriptions-item label="就诊时段">{{ route.query.timeSlot }}</el-descriptions-item>
      </el-descriptions>
      <div class="success-actions">
        <el-button type="primary" size="large" @click="router.push('/appointment/list')">查看我的预约</el-button>
        <el-button size="large" @click="router.push('/')">返回首页</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.patient-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 12px;
}
.patient-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 18px;
  border: 1px solid #dcdfe6;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}
.patient-card:hover {
  border-color: var(--color-primary);
  background: rgba(64,158,255,0.04);
}
.patient-card.active {
  border-color: var(--color-primary);
  background: rgba(64,158,255,0.06);
  transform: scale(1.02);
  box-shadow: 0 2px 12px rgba(64,158,255,0.15);
}
.card-radio {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.radio-circle {
  display: inline-block;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  border: 2px solid #dcdfe6;
  transition: all 0.2s;
  position: relative;
}
.radio-circle.checked {
  border-color: var(--color-primary);
}
.radio-circle.checked::after {
  content: '';
  position: absolute;
  top: 2px; left: 2px;
  width: 8px; height: 8px;
  border-radius: 50%;
  background: var(--color-primary);
}
.card-body {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
  min-width: 0;
}
.card-body .tag {
  color: #909399;
  font-size: 13px;
  white-space: nowrap;
}
.card-body .idcard {
  color: #909399;
  font-size: 13px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.success-card {
  text-align: center;
  padding: 48px 32px;
}
.success-icon {
  width: 64px; height: 64px;
  border-radius: 50%;
  background: #67c23a;
  color: #fff;
  font-size: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
}
.success-card h2 { margin-bottom: 8px; }
.success-card :deep(.el-descriptions) { text-align: left; }
.success-actions { display: flex; gap: 12px; justify-content: center; }
</style>
