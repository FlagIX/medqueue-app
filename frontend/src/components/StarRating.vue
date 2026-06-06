<script setup>
defineProps({
  modelValue: Number
})
const emit = defineEmits(['update:modelValue'])
</script>

<template>
  <el-rate
    :modelValue="modelValue"
    @update:modelValue="v => emit('update:modelValue', v)"
    :texts="['较差', '一般', '满意', '很好', '非常满意']"
    show-text
  />
</template>
