<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const breadcrumbs = computed(() => route.meta?.breadcrumb || [])

function goTo(item) {
  if (item.path) {
    router.push(item.path)
  }
}
</script>

<template>
  <div v-if="breadcrumbs.length" class="breadcrumb-bar">
    <div class="breadcrumb-inner">
      <template v-for="(item, index) in breadcrumbs" :key="index">
        <span
          v-if="index > 0"
          class="separator"
        >›</span>
        <span
          :class="['crumb', { link: !!item.path, 'is-last': !item.path }]"
          @click="goTo(item)"
        >{{ item.title }}</span>
      </template>
    </div>
  </div>
</template>

<style scoped>
.breadcrumb-bar {
  background: #fff;
  border-bottom: 1px solid #e4e7ed;
}
.breadcrumb-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 10px 20px;
  font-size: 13px;
}
.separator {
  margin: 0 8px;
  color: #c0c4cc;
}
.crumb {
  color: #909399;
}
.crumb.link {
  color: var(--color-primary);
  cursor: pointer;
}
.crumb.link:hover {
  color: #1a6fcc;
}
.crumb.is-last {
  color: #333;
  font-weight: 600;
}
</style>
