<script setup>
import HeaderBar from '@/components/HeaderBar.vue'
import BreadcrumbNav from '@/components/BreadcrumbNav.vue'
import FooterBar from '@/components/FooterBar.vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const isAdminPage = () => route.path.startsWith('/admin')
</script>

<template>
  <div id="app-container">
    <HeaderBar v-if="!isAdminPage()" />
    <BreadcrumbNav v-if="!isAdminPage()" />
    <main :class="{ 'admin-main': isAdminPage() }">
      <router-view />
    </main>
    <FooterBar v-if="!isAdminPage()" />
  </div>
</template>

<style scoped>
#app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
main {
  flex: 1;
}
.admin-main {
  background: #f0f2f5;
}
</style>
