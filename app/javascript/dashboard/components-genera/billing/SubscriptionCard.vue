<template>
  <div class="genera-subscription-card bg-white rounded-lg shadow-sm border border-gray-200 p-6">
    <div class="flex items-start justify-between mb-4">
      <div>
        <h3 class="text-lg font-semibold text-gray-900">{{ plan.name }}</h3>
        <p class="text-sm text-gray-600">{{ plan.description }}</p>
      </div>
      <div class="text-right">
        <p class="text-2xl font-bold text-genera-primary">${{ plan.price }}</p>
        <p class="text-sm text-gray-500">per {{ plan.interval }}</p>
      </div>
    </div>
    
    <!-- Features List -->
    <ul class="space-y-2 mb-6">
      <li 
        v-for="feature in plan.features" 
        :key="feature"
        class="flex items-center text-sm text-gray-600"
      >
        <svg class="w-4 h-4 text-green-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
        {{ feature }}
      </li>
    </ul>
    
    <!-- Action Button -->
    <button 
      :class="buttonClasses"
      :disabled="isCurrentPlan"
      @click="handleAction"
    >
      {{ buttonText }}
    </button>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  plan: {
    type: Object,
    required: true
  },
  isCurrentPlan: {
    type: Boolean,
    default: false
  },
  isRecommended: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['select', 'upgrade', 'downgrade'])

const buttonClasses = computed(() => {
  if (props.isCurrentPlan) {
    return 'w-full bg-gray-100 text-gray-500 px-4 py-2 rounded-md text-sm font-medium cursor-not-allowed'
  }
  
  if (props.isRecommended) {
    return 'w-full bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90'
  }
  
  return 'w-full border border-gray-300 text-gray-700 px-4 py-2 rounded-md text-sm font-medium hover:bg-gray-50'
})

const buttonText = computed(() => {
  if (props.isCurrentPlan) return 'Current Plan'
  if (props.isRecommended) return 'Recommended'
  return 'Select Plan'
})

const handleAction = () => {
  if (props.isCurrentPlan) return
  
  emit('select', props.plan)
}
</script>

<style scoped>
.genera-subscription-card {
  @apply transition-all duration-200 hover:shadow-md;
}

.genera-subscription-card:hover {
  @apply transform -translate-y-1;
}
</style>
