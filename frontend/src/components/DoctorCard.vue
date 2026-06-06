<script setup>
defineProps({
  doctor: Object
})
</script>

<template>
  <div class="doctor-card">
    <div class="avatar">
      <el-avatar :size="56" :src="doctor.avatar" />
    </div>
    <div class="info">
      <div class="name-row">
        <span class="name">{{ doctor.name }}</span>
        <el-tag size="small">{{ doctor.title }}</el-tag>
      </div>
      <p class="stats">
        <span>评分 {{ doctor.score ? (doctor.score / 10).toFixed(1) : '暂无' }}</span>
        <span>累计挂号 {{ doctor.appointmentCount || 0 }}次</span>
      </p>
      <p class="intro">{{ doctor.introduction || '暂无简介' }}</p>
    </div>
  </div>
</template>

<style scoped>
.doctor-card {
  display: flex;
  gap: 16px;
  padding: 16px;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  cursor: pointer;
  transition: box-shadow 0.2s;
}
.doctor-card:hover {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}
.avatar { flex-shrink: 0; }
.info { flex: 1; }
.name-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}
.name { font-size: 15px; font-weight: 600; }
.stats {
  font-size: 13px;
  color: #909399;
  display: flex;
  gap: 16px;
  margin-bottom: 4px;
}
.intro {
  font-size: 13px;
  color: #606266;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
