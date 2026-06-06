<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { doctorApi } from '@/api/doctor'
import { formatDate } from '@/utils/format'

const route = useRoute()
const router = useRouter()
const doctor = ref(null)
const schedules = ref([])
const selectedDate = ref('')
const dateList = ref([])

onMounted(async () => {
  const res = await doctorApi.getById(route.params.id)
  if (res.success) doctor.value = res.data
  generateDateList()
  await loadSchedules()
})

function generateDateList() {
  const list = []
  const today = new Date()
  for (let i = 0; i < 7; i++) {
    const d = new Date(today)
    d.setDate(d.getDate() + i)
    list.push(formatDate(d.toISOString()))
  }
  dateList.value = list
  selectedDate.value = list[0]
}

async function loadSchedules() {
  if (!selectedDate.value) return
  const res = await doctorApi.getSchedule(route.params.id, { date: selectedDate.value })
  if (res.success) schedules.value = res.data || []
}

function selectDate(date) {
  selectedDate.value = date
  loadSchedules()
}

function goAppointment(schedule) {
  router.push(`/appointment/create?doctorId=${route.params.id}&scheduleId=${schedule.scheduleId}&date=${selectedDate.value}&timeSlot=${schedule.timeSlot}`)
}
</script>

<template>
  <div class="page-container" v-if="doctor">
    <div class="doctor-header card">
      <el-avatar :size="72" :src="doctor.avatar" />
      <div class="info">
        <div class="name-row">
          <h1>{{ doctor.name }}</h1>
          <el-tag>{{ doctor.title }}</el-tag>
        </div>
        <p>评分 {{ doctor.score ? (doctor.score / 10).toFixed(1) : '暂无' }}</p>
        <p>累计挂号 {{ doctor.appointmentCount || 0 }} 次</p>
        <p class="intro">{{ doctor.introduction }}</p>
      </div>
    </div>

    <section class="schedule-section card">
      <h2>选择日期</h2>
      <div class="date-list">
        <div
          v-for="d in dateList"
          :key="d"
          :class="['date-item', { active: d === selectedDate }]"
          @click="selectDate(d)"
        >
          <span class="date-week">{{ ['周日','周一','周二','周三','周四','周五','周六'][new Date(d).getDay()] }}</span>
          <span class="date-day">{{ d.substring(5) }}</span>
        </div>
      </div>

      <h2 style="margin-top:24px">号源信息</h2>
      <div v-if="schedules.length" class="slot-list">
        <div v-for="s in schedules" :key="s.scheduleId" class="slot-item">
          <div class="slot-info">
            <span class="slot-time">{{ s.timeSlot }}</span>
            <span class="slot-remain" :class="{ low: s.remainCount <= 5 }">
              剩余 {{ s.remainCount }}/{{ s.totalCount }} 号
            </span>
          </div>
          <el-button
            type="primary"
            :disabled="s.remainCount <= 0"
            @click="goAppointment(s)"
          >
            {{ s.remainCount > 0 ? '预约' : '已满' }}
          </el-button>
        </div>
      </div>
      <el-empty v-else description="暂无号源" />
    </section>
  </div>
</template>

<style scoped>
.doctor-header {
  display: flex;
  gap: 24px;
  align-items: flex-start;
}
.name-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}
.name-row h1 { font-size: 22px; }
.info p { color: #606266; font-size: 14px; margin-bottom: 4px; }
.intro { margin-top: 8px; color: #333; }
.date-list {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}
.date-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 16px;
  border-radius: 8px;
  border: 1px solid #dcdfe6;
  cursor: pointer;
  transition: all 0.15s;
}
.date-item:hover { border-color: var(--color-primary); }
.date-item.active {
  background: var(--color-primary);
  color: #fff;
  border-color: var(--color-primary);
}
.date-week { font-size: 12px; }
.date-day { font-size: 16px; font-weight: 600; }
.slot-list { display: flex; flex-direction: column; gap: 8px; margin-top: 12px; }
.slot-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border: 1px solid #ebeef5;
  border-radius: 6px;
}
.slot-time { font-weight: 600; margin-right: 12px; }
.slot-remain { font-size: 13px; color: #909399; }
.slot-remain.low { color: #f56c6c; font-weight: 600; }
</style>
