<script setup>
defineProps({
  hospital: Object,
  showDistance: Boolean
})
</script>

<template>
  <div class="hospital-card">
    <div class="card-img">
      <img :src="hospital.images?.split(',')[0] || '/placeholder.svg'" :alt="hospital.name" />
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
.card-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
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
