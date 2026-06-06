<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { followApi } from '@/api/follow'
import HospitalCard from '@/components/HospitalCard.vue'

const router = useRouter()
const follows = ref([])
const loading = ref(false)

onMounted(() => loadFollows())

async function loadFollows() {
  loading.value = true
  try {
    const res = await followApi.list({ type: 0, current: 1, pageSize: 999 })
    if (res.success) follows.value = res.data?.records || []
  } finally { loading.value = false }
}

async function handleUnfollow(id) {
  try {
    await ElMessageBox.confirm('确定取消关注？')
    const res = await followApi.unfollow(id, 0)
    if (res.success) { ElMessage.success('已取消'); loadFollows() }
  } catch {}
}

function goHospital(id) { router.push(`/hospital/${id}`) }
</script>

<template>
  <div class="page-container">
    <div class="card">
      <div class="flex-between"><h2>我的关注</h2></div>
      <el-empty v-if="!loading && !follows.length" description="暂无关注" />
      <div v-for="f in follows" :key="f.id" class="follow-item">
        <div class="info-area" @click="goHospital(f.followId)">
          <HospitalCard :hospital="f.hospital" v-if="f.hospital" />
        </div>
        <el-button type="danger" text @click="handleUnfollow(f.followId)">取消关注</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.follow-item {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 8px;
}
.info-area { flex: 1; cursor: pointer; }
</style>
