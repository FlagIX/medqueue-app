<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { hospitalApi } from '@/api/hospital'
import { doctorApi } from '@/api/doctor'
import DoctorCard from '@/components/DoctorCard.vue'

const route = useRoute()
const router = useRouter()
const hospital = ref(null)
const doctors = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    const res = await hospitalApi.getById(route.params.id)
    if (res.success) hospital.value = res.data
    const docRes = await doctorApi.byHospital(route.params.id, { current: 1 })
    if (docRes.success) doctors.value = docRes.data?.records || []
  } catch (_) {} finally { loading.value = false }
})

function goDoctor(id) { router.push(`/doctor/${id}`) }
function goAppointment(doctorId) {
  router.push(`/appointment/create?doctorId=${doctorId}&hospitalId=${route.params.id}`)
}
</script>

<template>
  <div class="page-container" v-if="hospital">
    <el-skeleton :loading="loading" animated>
      <div class="hospital-header card">
        <div class="header-left">
          <h1>{{ hospital.name }}</h1>
          <div class="tags">
            <el-tag type="primary">{{ hospital.level }}</el-tag>
            <el-tag type="warning">{{ (hospital.score / 10).toFixed(1) }}分</el-tag>
          </div>
          <p class="addr">{{ hospital.area }} {{ hospital.address }}</p>
          <p class="phone" v-if="hospital.phone">电话：{{ hospital.phone }}</p>
          <p class="hours">就诊时间：{{ hospital.openHours }}</p>
        </div>
        <div class="header-right">
          <el-button type="primary" size="large" @click="goDoctor(doctors[0]?.id)" :disabled="!doctors.length">
            立即预约
          </el-button>
        </div>
      </div>

      <section class="section">
        <h2 class="section-title">医生列表</h2>
        <div v-for="d in doctors" :key="d.id" @click="goDoctor(d.id)">
          <DoctorCard :doctor="d" />
        </div>
        <el-empty v-if="!doctors.length" description="暂无医生信息" />
      </section>
    </el-skeleton>
  </div>
</template>

<style scoped>
.hospital-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}
.header-left h1 { font-size: 24px; margin-bottom: 8px; }
.tags { display: flex; gap: 8px; margin-bottom: 8px; }
.addr, .phone, .hours { color: #606266; font-size: 14px; margin-bottom: 4px; }
.section { margin-top: 24px; }
.section-title {
  font-size: 18px;
  margin-bottom: 12px;
  padding-left: 12px;
  border-left: 3px solid var(--color-primary);
}
</style>
