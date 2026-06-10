<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { reviewApi } from '@/api/review'
import { hospitalApi } from '@/api/hospital'
import StarRating from '@/components/StarRating.vue'

const reviews = ref([])
const total = ref(0)
const current = ref(1)
const loading = ref(false)
const dialogVisible = ref(false)
const form = ref({ hospitalId: null, doctorId: null, rating: 0, content: '' })
const hospitals = ref([])

onMounted(async () => {
  const hRes = await hospitalApi.page({ current: 1, pageSize: 999 })
  if (hRes.success) hospitals.value = hRes.data?.records || []
  loadReviews()
})

async function loadReviews() {
  loading.value = true
  try {
    const res = await reviewApi.page({ current: current.value, pageSize: 10 })
    if (res.success) {
      reviews.value = (res.data?.records || []).map(r => ({ ...r, _liked: false }))
      total.value = res.data?.total || 0
    }
  } finally { loading.value = false }
}

function onPageChange(page) {
  current.value = page
  loadReviews()
}

async function toggleLike(r) {
  try {
    const res = await reviewApi.like(r.id)
    if (res.success) {
      r._liked = !r._liked
      r.liked = (r.liked || 0) + (r._liked ? 1 : -1)
    }
  } catch {}
}

function openAdd() {
  form.value = { hospitalId: null, doctorId: null, rating: 0, content: '' }
  dialogVisible.value = true
}

async function handleSave() {
  if (!form.value.hospitalId || !form.value.rating || !form.value.content)
    return ElMessage.warning('请填写完整')
  loading.value = true
  try {
    const res = await reviewApi.save(form.value)
    if (res.success) { ElMessage.success('发表成功'); dialogVisible.value = false; loadReviews() }
  } finally { loading.value = false }
}
</script>

<template>
  <div class="page-container">
    <div class="card">
      <div class="flex-between">
        <h2>我的评价</h2>
        <el-button type="primary" @click="openAdd">发表评价</el-button>
      </div>

      <el-empty v-if="!loading && !reviews.length" description="暂无评价" />
      <div v-for="r in reviews" :key="r.id" class="review-item">
        <StarRating :model-value="r.rating ? r.rating / 10 : 0" />
        <p>{{ r.content }}</p>
        <div class="review-actions">
          <span class="time">{{ r.createTime }}</span>
          <span class="like-btn" :class="{ liked: r._liked }" @click="toggleLike(r)">
            <span v-if="r._liked">❤️</span>
            <span v-else>🤍</span>
            {{ r.liked || 0 }}
          </span>
        </div>
      </div>

      <div class="pagination-wrap" v-if="total > 10">
        <el-pagination
          v-model:current-page="current"
          :total="total"
          :page-size="10"
          layout="prev, pager, next"
          @current-change="onPageChange"
        />
      </div>

      <el-dialog v-model="dialogVisible" title="发表评价" width="500px">
        <el-form :model="form">
          <el-form-item label="医院">
            <el-select v-model="form.hospitalId" filterable placeholder="选择医院" style="width:100%">
              <el-option v-for="h in hospitals" :key="h.id" :label="h.name" :value="h.id" />
            </el-select>
          </el-form-item>
          <el-form-item label="评分">
            <StarRating v-model="form.rating" />
          </el-form-item>
          <el-form-item label="评价">
            <el-input v-model="form.content" type="textarea" :rows="4" maxlength="500" show-word-limit />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" :loading="loading" @click="handleSave">提交</el-button>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<style scoped>
.review-item {
  padding: 16px 0;
  border-bottom: 1px solid #ebeef5;
}
.review-item p { margin: 8px 0; font-size: 14px; }
.review-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.time { font-size: 12px; color: #909399; }
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
  margin-top: 24px;
}
</style>
