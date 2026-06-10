<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { hospitalApi } from '@/api/hospital'
import { doctorApi } from '@/api/doctor'
import { reviewApi } from '@/api/review'
import { followApi } from '@/api/follow'
import DoctorCard from '@/components/DoctorCard.vue'
import StarRating from '@/components/StarRating.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const hospital = ref(null)
const doctors = ref([])
const loading = ref(true)

// 关注
const followed = ref(false)
const followLoading = ref(false)

// 评价
const reviews = ref([])
const reviewTotal = ref(0)
const reviewCurrent = ref(1)
const reviewLoading = ref(false)

onMounted(async () => {
  try {
    const res = await hospitalApi.getById(route.params.id)
    if (res.success) hospital.value = res.data
    const docRes = await doctorApi.byHospital(route.params.id, { current: 1 })
    if (docRes.success) doctors.value = docRes.data?.records || []
    loadReviews()
    checkFollow()
  } catch (_) {} finally { loading.value = false }
})

async function checkFollow() {
  if (!userStore.user) return
  try {
    const res = await followApi.isFollow(route.params.id, 1)
    if (res.success) followed.value = res.data
  } catch {}
}

async function toggleFollow() {
  if (!userStore.user) return router.push('/login')
  followLoading.value = true
  try {
    if (followed.value) {
      await followApi.unfollow(route.params.id, 1)
      followed.value = false
      ElMessage.success('已取消关注')
    } else {
      await followApi.follow(route.params.id, 1)
      followed.value = true
      ElMessage.success('已关注')
    }
  } catch {} finally { followLoading.value = false }
}

async function loadReviews() {
  reviewLoading.value = true
  try {
    const res = await reviewApi.byHospital(route.params.id, { current: reviewCurrent.value })
    if (res.success) {
      reviews.value = (res.data?.records || []).map(r => ({ ...r, _liked: false }))
      reviewTotal.value = res.data?.total || 0
    }
  } finally { reviewLoading.value = false }
}

async function toggleLike(r) {
  if (!userStore.user) return router.push('/login')
  try {
    const res = await reviewApi.like(r.id)
    if (res.success) {
      r._liked = !r._liked
      r.liked = (r.liked || 0) + (r._liked ? 1 : -1)
    }
  } catch {}
}

function onReviewPageChange(page) {
  reviewCurrent.value = page
  loadReviews()
}

function goDoctor(id) { router.push(`/doctor/${id}`) }
function goAppointment(doctorId) {
  router.push(`/appointment/create?doctorId=${doctorId}&hospitalId=${route.params.id}`)
}
</script>

<template>
  <div class="page-container" v-if="hospital">
    <el-skeleton :loading="loading" animated>
      <!-- 医院头部 -->
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
          <el-button
            :type="followed ? 'default' : 'danger'"
            size="large"
            :loading="followLoading"
            @click="toggleFollow"
          >
            {{ followed ? '❤️ 已关注' : '🤍 关注' }}
          </el-button>
          <el-button type="primary" size="large" @click="goDoctor(doctors[0]?.id)" :disabled="!doctors.length">
            立即预约
          </el-button>
        </div>
      </div>

      <!-- 医生列表 -->
      <section class="section">
        <h2 class="section-title">医生列表</h2>
        <div v-for="d in doctors" :key="d.id" @click="goDoctor(d.id)">
          <DoctorCard :doctor="d" />
        </div>
        <el-empty v-if="!doctors.length" description="暂无医生信息" />
      </section>

      <!-- 患者评价 -->
      <section class="section">
        <h2 class="section-title">患者评价</h2>
        <div v-if="reviewLoading" v-loading="reviewLoading" style="min-height:100px" />
        <div v-else>
          <div v-for="r in reviews" :key="r.id" class="review-item">
            <div class="review-user">
              <span class="review-name">{{ r.name || '匿名用户' }}</span>
              <StarRating :model-value="r.rating ? r.rating / 10 : 0" />
            </div>
            <p class="review-content">{{ r.content }}</p>
            <div class="review-actions">
              <span class="review-time">{{ r.createTime }}</span>
              <span class="like-btn" :class="{ liked: r._liked }" @click="toggleLike(r)">
                <span v-if="r._liked">❤️</span>
                <span v-else>🤍</span>
                {{ r.liked || 0 }}
              </span>
            </div>
          </div>
          <div class="pagination-wrap" v-if="reviewTotal > 10">
            <el-pagination
              v-model:current-page="reviewCurrent"
              :total="reviewTotal"
              :page-size="10"
              layout="prev, pager, next"
              @current-change="onReviewPageChange"
            />
          </div>
          <el-empty v-if="!reviews.length" description="暂无评价" />
        </div>
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
.header-right {
  display: flex;
  flex-direction: column;
  gap: 8px;
  flex-shrink: 0;
}
.section { margin-top: 24px; }
.section-title {
  font-size: 18px;
  margin-bottom: 12px;
  padding-left: 12px;
  border-left: 3px solid var(--color-primary);
}

/* 评价 */
.review-item {
  padding: 16px 0;
  border-bottom: 1px solid #ebeef5;
}
.review-user {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}
.review-name {
  font-weight: 600;
  font-size: 14px;
}
.review-content {
  margin: 8px 0;
  font-size: 14px;
  color: #333;
  line-height: 1.6;
}
.review-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.review-time { font-size: 12px; color: #909399; }
.like-btn {
  font-size: 14px;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: #909399;
  transition: color 0.2s;
  user-select: none;
}
.like-btn:hover { color: #f56c6c; }
.like-btn.liked { color: #f56c6c; font-weight: 600; }
.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
</style>
