<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
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
const doctorInfo = ref(null)
const scheduleInfo = ref(null)

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
      ElMessage.success('预约成功！')
      router.push('/appointment/list')
    }
  } finally { loading.value = false }
}
</script>

<template>
  <div class="page-container">
    <div class="card">
      <h2>确认预约信息</h2>
      <el-descriptions :column="1" border style="margin:20px 0">
        <el-descriptions-item label="医生">{{ doctorInfo?.name || '—' }}</el-descriptions-item>
        <el-descriptions-item label="职称">{{ doctorInfo?.title || '—' }}</el-descriptions-item>
        <el-descriptions-item label="预约日期">{{ route.query.date }}</el-descriptions-item>
        <el-descriptions-item label="就诊时段">{{ route.query.timeSlot }}</el-descriptions-item>
      </el-descriptions>

      <h3>选择就诊人</h3>
      <el-radio-group v-model="selectedPatient" class="patient-list">
        <el-radio
          v-for="p in patients"
          :key="p.id"
          :value="p.id"
          class="patient-item"
        >
          <div>
            <strong>{{ p.name }}</strong>
            <span style="margin-left:8px;color:#909399;font-size:13px">{{ p.relation }}</span>
            <span style="margin-left:8px;color:#909399;font-size:13px">{{ p.idCard }}</span>
          </div>
        </el-radio>
      </el-radio-group>
      <el-empty v-if="!patients.length" description="暂无就诊人，请先添加" />

      <div style="margin-top:24px">
        <el-button type="primary" size="large" :loading="loading" @click="submit">
          确认预约
        </el-button>
        <el-button size="large" @click="router.push('/patient')">添加就诊人</el-button>
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
.patient-item {
  padding: 12px 16px;
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  width: 100%;
}
</style>
