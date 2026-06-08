<script setup>
import { getHospitalGradient } from '@/utils/format'
defineProps({
  hospital: Object,
  showDistance: Boolean
})
</script>

<template>
  <div class="hospital-card">
    <div class="card-img">
      <div class="card-img-placeholder" :style="{ background: getHospitalGradient(hospital.id) }">
        <span class="card-img-emoji">🏥</span>
      </div>
    </div>
    <div class="card-body">
      <h3 class="name">{{ hospital.name }}</h3>
      <div class="tags">
        <el-tag size="small" type="primary">{{ hospital.level || '普通' }}</el-tag>
        <el-tag size="small" type="success" v-if="hospital.score">
          {{ (hospital.score / 10).toFixed(1) }}分
        </el-tag>
      </div>
      <p class="address">{{ hospital.area }} {{ hospital.address }}</p>
      <p class="extra">
        <span v-if="showDistance && hospital.distance">{{ hospital.distance }}km</span>
      </p>
    </div>
  </div>
</template>

<style scoped>
.hospital-card {
  display: flex;
  gap: 16px;
  padding: 16px;
  background: #fff;
  border-radius: 8px;
  cursor: pointer;
  transition: box-shadow 0.2s;
  border: 1px solid #ebeef5;
}
.hospital-card:hover {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}
.card-img {
  width: 120px;
  height: 90px;
  border-radius: 6px;
  overflow: hidden;
  flex-shrink: 0;
}
.card-img-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.card-img-placeholder .card-img-emoji {
  font-size: 32px;
  line-height: 1;
}
.card-body { flex: 1; }
.name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 6px;
}
.tags {
  display: flex;
  gap: 6px;
  margin-bottom: 6px;
}
.address {
  color: #909399;
  font-size: 13px;
}
.extra {
  color: #909399;
  font-size: 12px;
  margin-top: 4px;
}
</style>
