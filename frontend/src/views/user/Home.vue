<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { departmentApi } from '@/api/department'
import { hospitalApi } from '@/api/hospital'
import { getHospitalGradient } from '@/utils/format'

const deptEmoji = {
  '内科': '💊',
  '外科': '🔪',
  '儿科': '👶',
  '妇产科': '🤰',
  '眼科': '👁',
  '耳鼻喉科': '👃',
  '口腔科': '🦷',
  '皮肤科': '✋',
  '骨科': '🦴',
  '神经内科': '🧠'
}
const deptColors = [
  '#e3f2fd', '#fce4ec', '#e8f5e9', '#fff3e0', '#f3e5f5',
  '#e0f7fa', '#fff8e1', '#fbe9e7', '#e8eaf6', '#f1f8e9'
]
function getDeptEmoji(name) { return deptEmoji[name] || '🏥' }

const router = useRouter()
const departments = ref([])
const hospitals = ref([])
const loading = ref(false)

onMounted(async () => {
  try {
    const [deptRes, hospRes] = await Promise.all([
      departmentApi.list(),
      hospitalApi.page({ current: 1 })
    ])
    if (deptRes.success) departments.value = deptRes.data || []
    if (hospRes.success) hospitals.value = hospRes.data?.records || []
  } catch (_) {}
})

function goDepartment(id) { router.push(`/hospital?deptId=${id}`) }
function goHospital(id) { router.push(`/hospital/${id}`) }
</script>

<template>
  <div class="page-container">
    <!-- 搜索引导区 -->
    <section class="hero-section">
      <h1>一站式医疗预约挂号平台</h1>
      <p>在线预约挂号，轻松就医</p>
    </section>

    <!-- 科室导航 -->
    <section class="section">
      <h2 class="section-title">按科室挂号</h2>
      <div class="dept-grid">
        <div
          v-for="(d, idx) in departments"
          :key="d.id"
          class="dept-item"
          @click="goDepartment(d.id)"
        >
          <span
            class="dept-icon"
            :style="{ backgroundColor: deptColors[idx % deptColors.length] }"
          >{{ getDeptEmoji(d.name) }}</span>
          <span class="dept-name">{{ d.name }}</span>
        </div>
      </div>
    </section>

    <!-- 推荐医院 -->
    <section class="section">
      <h2 class="section-title">推荐医院</h2>
      <div v-if="hospitals.length" class="hospital-list">
        <div
          v-for="h in hospitals"
          :key="h.id"
          class="hospital-item"
          @click="goHospital(h.id)"
        >
          <div class="h-img-placeholder" :style="{ background: getHospitalGradient(h.id) }">
            <span class="h-img-emoji">🏥</span>
          </div>
          <div class="h-info">
            <h3>{{ h.name }}</h3>
            <p class="h-tags">
              <el-tag size="small" type="primary">{{ h.level || '综合' }}</el-tag>
              <el-tag size="small" type="success" v-if="h.score">
                {{ (h.score / 10).toFixed(1) }}分
              </el-tag>
            </p>
            <p class="h-addr">{{ h.area }} {{ h.address }}</p>
          </div>
        </div>
      </div>
      <el-empty v-else description="暂无医院数据" />
    </section>
  </div>
</template>

<style scoped>
.hero-section {
  text-align: center;
  padding: 48px 20px;
  background: linear-gradient(135deg, #2d8cf0 0%, #19be6b 100%);
  border-radius: 12px;
  color: #fff;
  margin-bottom: 32px;
}
.hero-section h1 {
  font-size: 32px;
  margin-bottom: 8px;
}
.hero-section p { font-size: 16px; opacity: 0.9; }
.section { margin-bottom: 32px; }
.section-title {
  font-size: 20px;
  margin-bottom: 16px;
  padding-left: 12px;
  border-left: 4px solid var(--color-primary);
}
.dept-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
  gap: 12px;
}
.dept-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 20px 12px;
  background: #fff;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  border: 1px solid #ebeef5;
}
.dept-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(45, 140, 240, 0.12);
  border-color: var(--color-primary);
}
.dept-icon {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  line-height: 1;
  flex-shrink: 0;
}
.dept-name { font-size: 13px; color: #333; }
.hospital-item {
  display: flex;
  gap: 16px;
  padding: 16px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 12px;
  cursor: pointer;
  border: 1px solid #ebeef5;
  transition: box-shadow 0.2s;
}
.hospital-item:hover { box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
.h-img-placeholder {
  width: 120px;
  height: 90px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.h-img-emoji {
  font-size: 32px;
  line-height: 1;
}
.h-info { flex: 1; }
.h-info h3 { font-size: 16px; margin-bottom: 6px; }
.h-tags { display: flex; gap: 6px; margin-bottom: 6px; }
.h-addr { color: #909399; font-size: 13px; }
</style>
