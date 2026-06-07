import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // 用户端
  { path: '/', name: 'Home', component: () => import('@/views/user/Home.vue') },
  { path: '/login', name: 'Login', component: () => import('@/views/user/Login.vue') },
  { path: '/register', name: 'Register', component: () => import('@/views/user/Register.vue') },
  { path: '/hospital', name: 'HospitalList', component: () => import('@/views/user/HospitalList.vue') },
  { path: '/hospital/:id', name: 'HospitalDetail', component: () => import('@/views/user/HospitalDetail.vue') },
  { path: '/doctor/:id', name: 'DoctorDetail', component: () => import('@/views/user/DoctorDetail.vue') },
  { path: '/appointment/create', name: 'AppointmentCreate', component: () => import('@/views/user/AppointmentCreate.vue') },
  { path: '/appointment/list', name: 'AppointmentList', component: () => import('@/views/user/AppointmentList.vue') },
  { path: '/patient', name: 'PatientProfile', component: () => import('@/views/user/PatientProfile.vue') },
  { path: '/profile/edit', name: 'ProfileEdit', component: () => import('@/views/user/ProfileEdit.vue') },
  { path: '/review/list', name: 'MyReviews', component: () => import('@/views/user/MyReviews.vue') },
  { path: '/follow/list', name: 'MyFollows', component: () => import('@/views/user/MyFollows.vue') },
  // 管理端
  { path: '/admin/login', name: 'AdminLogin', component: () => import('@/views/admin/Login.vue') },
  { path: '/admin/dashboard', name: 'Dashboard', component: () => import('@/views/admin/Dashboard.vue') },
  { path: '/admin/hospital', name: 'HospitalManage', component: () => import('@/views/admin/HospitalManage.vue') },
  { path: '/admin/department', name: 'DepartmentManage', component: () => import('@/views/admin/DepartmentManage.vue') },
  { path: '/admin/doctor', name: 'DoctorManage', component: () => import('@/views/admin/DoctorManage.vue') },
  { path: '/admin/schedule', name: 'ScheduleManage', component: () => import('@/views/admin/ScheduleManage.vue') },
  { path: '/admin/appointment', name: 'AppointmentManage', component: () => import('@/views/admin/AppointmentManage.vue') },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const adminToken = localStorage.getItem('adminToken')
  const needAuth = !['Home', 'Login', 'Register', 'HospitalList', 'HospitalDetail', 'DoctorDetail'].includes(to.name)
  const isAdminRoute = to.path.startsWith('/admin')

  if (isAdminRoute && to.name !== 'AdminLogin') {
    if (!adminToken) return next('/admin/login')
  } else if (needAuth && to.name !== 'AdminLogin') {
    if (!token && !['/login', '/'].includes(to.path)) return next('/login')
  }
  next()
})

export default router
