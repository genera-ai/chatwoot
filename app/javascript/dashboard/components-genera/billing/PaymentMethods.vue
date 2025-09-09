<template>
  <div class="genera-payment-methods">
    <div class="bg-white shadow rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg leading-6 font-medium text-gray-900">
            Payment Methods
          </h3>
          <button 
            @click="showAddModal = true"
            class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90"
          >
            Add Payment Method
          </button>
        </div>
        
        <!-- Payment Methods List -->
        <div class="space-y-4">
          <div 
            v-for="method in paymentMethods" 
            :key="method.id"
            class="flex items-center justify-between p-4 border border-gray-200 rounded-lg"
          >
            <div class="flex items-center">
              <div class="w-10 h-6 bg-gray-100 rounded flex items-center justify-center mr-3">
                <span class="text-xs font-medium text-gray-600">{{ method.brand }}</span>
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900">
                  **** **** **** {{ method.last4 }}
                </p>
                <p class="text-sm text-gray-500">
                  Expires {{ method.expMonth }}/{{ method.expYear }}
                </p>
              </div>
            </div>
            
            <div class="flex items-center space-x-2">
              <span 
                v-if="method.isDefault"
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
              >
                Default
              </span>
              <button 
                @click="setAsDefault(method.id)"
                :disabled="method.isDefault"
                class="text-sm text-genera-primary hover:text-genera-primary/80 disabled:text-gray-400 disabled:cursor-not-allowed"
              >
                Set as Default
              </button>
              <button 
                @click="removeMethod(method.id)"
                class="text-sm text-red-600 hover:text-red-800"
              >
                Remove
              </button>
            </div>
          </div>
        </div>
        
        <!-- Empty State -->
        <div v-if="paymentMethods.length === 0" class="text-center py-8">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No payment methods</h3>
          <p class="mt-1 text-sm text-gray-500">Get started by adding a payment method.</p>
        </div>
      </div>
    </div>
    
    <!-- Add Payment Method Modal (placeholder) -->
    <div v-if="showAddModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Add Payment Method</h3>
        <p class="text-sm text-gray-500 mb-4">Payment method integration will be implemented here.</p>
        <div class="flex justify-end space-x-3">
          <button 
            @click="showAddModal = false"
            class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200"
          >
            Cancel
          </button>
          <button 
            @click="showAddModal = false"
            class="px-4 py-2 text-sm font-medium text-white bg-genera-primary rounded-md hover:bg-genera-primary/90"
          >
            Add Method
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const showAddModal = ref(false)

const paymentMethods = ref([
  {
    id: 1,
    brand: 'VISA',
    last4: '4242',
    expMonth: '12',
    expYear: '2025',
    isDefault: true
  },
  {
    id: 2,
    brand: 'MC',
    last4: '5555',
    expMonth: '08',
    expYear: '2026',
    isDefault: false
  }
])

const setAsDefault = (methodId) => {
  paymentMethods.value.forEach(method => {
    method.isDefault = method.id === methodId
  })
}

const removeMethod = (methodId) => {
  if (confirm('Are you sure you want to remove this payment method?')) {
    paymentMethods.value = paymentMethods.value.filter(method => method.id !== methodId)
  }
}
</script>

<style scoped>
.genera-payment-methods {
  @apply max-w-4xl mx-auto;
}
</style>
