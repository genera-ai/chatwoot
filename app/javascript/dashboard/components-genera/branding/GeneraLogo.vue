<template>
  <div class="genera-logo">
    <img 
      :src="logoUrl" 
      :alt="companyName"
      class="h-8 w-auto"
    />
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  size: {
    type: String,
    default: 'medium'
  },
  variant: {
    type: String,
    default: 'default'
  }
})

const logoUrl = computed(() => {
  // TODO: Implementar lógica para diferentes variantes do logo
  return '/genera-logo.png'
})

const companyName = 'Genera Atende'
</script>

<style scoped>
.genera-logo {
  @apply flex items-center;
}
</style>
