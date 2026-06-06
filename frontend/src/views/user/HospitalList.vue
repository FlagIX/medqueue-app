<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { departmentApi } from '@/api/department'
import { hospitalApi } from '@/api/hospital'
import HospitalCard from '@/components/HospitalCard.vue'

const route = useRoute()
const router = useRouter()
const departments = ref([])
const hospitals = ref([])
const total = ref(0)
const current = ref(1)
const selectedDept = ref(null)
const loading = ref(false)
const pageSize = 10

onMounted(async () => {
  const deptRes = await departmentApi.list()
  if (deptRes.success) departments.value = deptRes.data || []
  if (route.query.deptId) selectedDept.value = Number(route.query.deptId)
  await loadHospitals()
})

watch(() => route.query, () => {
  if (route.query.deptId) selectedDept.value = Number(route.query.deptId)
  current.value = 1
  loadHospitals()
})

async function loadHospitals() {
  loading.value = true
  try {
    const params = { current: current.value, pageSize }
    if (selectedDept.value) params.departmentId = selectedDept.value
    if (route.query.name) params.name = route.query.name
    const res = await hospitalApi.page(params)
    if (res.success) {
      hospitals.value = res.data?.records || []
      total.value = res.data?.total || 0
    }
  } finally { loading.value = false }
}

function onSelectDept(id) {
  selectedDept.value = id
  current.value = 1
  router.push({ query: { ...route.query, deptId: id || undefined } })
}

function onPageChange(page) {
  current.value = page
  loadHospitals()
}

function goHospital(id) { router.push(`/hospital/${id}`) }
</script>

<template>
  <div class="page-container hospital-list-page">
    <div class="sidebar">
      <h3>科室筛选</h3>
      <div class="dept-list">
        <div
          :class="['dept-item', { active: !selectedDept && !route.query.name }]"
          @click="onSelectDept(null)"
        >全部</div>
        <div
          v-for="d in departments"
          :key="d.id"
          :class="['dept-item', { active: selectedDept === d.id }]"
          @click="onSelectDept(d.id)"
        >{{ d.name }}</div>
      </div>
    </div>
    <div class="main-area">
      <div class="result-header">
        <span>共找到 <strong>{{ total }}</strong> 家医院</span>
      </div>
      <el-skeleton :loading="loading" animated :count="3">
        <div class="hospital-list">
          <div v-for="h in hospitals" :key="h.id" @click="goHospital(h.id)">
            <HospitalCard :hospital="h" />
          </div>
        </div>
      </el-skeleton>
      <div class="pagination-wrap" v-if="total > pageSize">
        <el-pagination
          v-model:current-page="current"
          :total="total"
          :page-size="pageSize"
          layout="prev, pager, next"
          @current-change="onPageChange"
        />
      </div>
      <el-empty v-if="!loading && hospitals.length === 0" description="暂无医院" />
    </div>
  </div>
</template>

<style scoped>
.hospital-list-page {
  display: flex;
  gap: 20px;
}
.sidebar {
  width: 200px;
  flex-shrink: 0;
}
.sidebar h3 {
  font-size: 15px;
  margin-bottom: 12px;
  padding-left: 8px;
  border-left: 3px solid var(--color-primary);
}
.dept-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.dept-item {
  padding: 8px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  color: #606266;
  transition: all 0.15s;
}
.dept-item:hover { background: #ecf5ff; color: var(--color-primary); }
.dept-item.active { background: var(--color-primary); color: #fff; }
.main-area { flex: 1; }
.result-header {
  font-size: 14px;
  color: #909399;
  margin-bottom: 16px;
}
.hospital-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 24px;
}
</style>
