import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // 用户端
  {
    path: '/', name: 'Home',
    meta: { title: '首页' },
    component: () => import('@/views/user/Home.vue')
  },
  {
    path: '/login', name: 'Login',
    meta: { title: '登录', breadcrumb: [{ title: '首页', path: '/' }, { title: '登录', path: '' }] },
    component: () => import('@/views/user/Login.vue')
  },
  {
    path: '/register', name: 'Register',
    meta: { title: '注册', breadcrumb: [{ title: '首页', path: '/' }, { title: '注册', path: '' }] },
    component: () => import('@/views/user/Register.vue')
  },
  {
    path: '/hospital', name: 'HospitalList',
    meta: { title: '医院列表', breadcrumb: [{ title: '首页', path: '/' }, { title: '医院列表', path: '' }] },
    component: () => import('@/views/user/HospitalList.vue')
  },
  {
    path: '/hospital/:id', name: 'HospitalDetail',
    meta: { title: '医院详情', breadcrumb: [{ title: '首页', path: '/' }, { title: '医院列表', path: '/hospital' }, { title: '医院详情', path: '' }] },
    component: () => import('@/views/user/HospitalDetail.vue')
  },
  {
    path: '/doctor/:id', name: 'DoctorDetail',
    meta: { title: '医生详情', breadcrumb: [{ title: '首页', path: '/' }, { title: '医生详情', path: '' }] },
    component: () => import('@/views/user/DoctorDetail.vue')
  },
  {
    path: '/appointment/create', name: 'AppointmentCreate',
    meta: { title: '预约挂号', breadcrumb: [{ title: '首页', path: '/' }, { title: '预约挂号', path: '' }] },
    component: () => import('@/views/user/AppointmentCreate.vue')
  },
  {
    path: '/appointment/list', name: 'AppointmentList',
    meta: { title: '我的预约', breadcrumb: [{ title: '首页', path: '/' }, { title: '我的预约', path: '' }] },
    component: () => import('@/views/user/AppointmentList.vue')
  },
  {
    path: '/patient', name: 'PatientProfile',
    meta: { title: '就诊人管理', breadcrumb: [{ title: '首页', path: '/' }, { title: '就诊人管理', path: '' }] },
    component: () => import('@/views/user/PatientProfile.vue')
  },
  {
    path: '/profile/edit', name: 'ProfileEdit',
    meta: { title: '个人信息', breadcrumb: [{ title: '首页', path: '/' }, { title: '个人信息', path: '' }] },
    component: () => import('@/views/user/ProfileEdit.vue')
  },
  {
    path: '/review/list', name: 'MyReviews',
    meta: { title: '我的评价', breadcrumb: [{ title: '首页', path: '/' }, { title: '我的评价', path: '' }] },
    component: () => import('@/views/user/MyReviews.vue')
  },
  {
    path: '/follow/list', name: 'MyFollows',
    meta: { title: '我的关注', breadcrumb: [{ title: '首页', path: '/' }, { title: '我的关注', path: '' }] },
    component: () => import('@/views/user/MyFollows.vue')
  },
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
