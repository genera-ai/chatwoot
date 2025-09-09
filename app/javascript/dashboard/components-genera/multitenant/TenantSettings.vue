<template>
  <div class="genera-tenant-settings">
    <div class="space-y-6">
      <!-- Workspace Information -->
      <div class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
            Workspace Information
          </h3>
          
          <form @submit.prevent="updateWorkspaceInfo" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label for="workspace-name" class="block text-sm font-medium text-gray-700">
                  Workspace Name
                </label>
                <input
                  id="workspace-name"
                  v-model="workspaceForm.name"
                  type="text"
                  class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-genera-primary focus:border-genera-primary sm:text-sm"
                  placeholder="Enter workspace name"
                />
              </div>
              
              <div>
                <label for="workspace-domain" class="block text-sm font-medium text-gray-700">
                  Custom Domain
                </label>
                <input
                  id="workspace-domain"
                  v-model="workspaceForm.domain"
                  type="text"
                  class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-genera-primary focus:border-genera-primary sm:text-sm"
                  placeholder="your-domain.com"
                />
              </div>
            </div>
            
            <div>
              <label for="workspace-description" class="block text-sm font-medium text-gray-700">
                Description
              </label>
              <textarea
                id="workspace-description"
                v-model="workspaceForm.description"
                rows="3"
                class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-genera-primary focus:border-genera-primary sm:text-sm"
                placeholder="Describe your workspace"
              ></textarea>
            </div>
            
            <div class="flex justify-end">
              <button
                type="submit"
                :disabled="isUpdating"
                class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {{ isUpdating ? 'Updating...' : 'Update Workspace' }}
              </button>
            </div>
          </form>
        </div>
      </div>
      
      <!-- Billing Information -->
      <div class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
            Billing Information
          </h3>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <h4 class="text-sm font-medium text-gray-700 mb-2">Current Plan</h4>
              <div class="bg-genera-primary/10 border border-genera-primary/20 rounded-md p-4">
                <p class="text-lg font-semibold text-genera-primary">{{ currentPlan.name }}</p>
                <p class="text-sm text-gray-600">{{ currentPlan.description }}</p>
                <p class="text-2xl font-bold text-genera-primary mt-2">${{ currentPlan.price }}/mo</p>
              </div>
            </div>
            
            <div>
              <h4 class="text-sm font-medium text-gray-700 mb-2">Usage This Month</h4>
              <div class="space-y-3">
                <div>
                  <div class="flex justify-between text-sm">
                    <span>Messages</span>
                    <span>{{ usage.messages }} / {{ currentPlan.limits.messages }}</span>
                  </div>
                  <div class="w-full bg-gray-200 rounded-full h-2 mt-1">
                    <div 
                      class="bg-genera-primary h-2 rounded-full" 
                      :style="{ width: `${(usage.messages / currentPlan.limits.messages) * 100}%` }"
                    ></div>
                  </div>
                </div>
                
                <div>
                  <div class="flex justify-between text-sm">
                    <span>Agents</span>
                    <span>{{ usage.agents }} / {{ currentPlan.limits.agents }}</span>
                  </div>
                  <div class="w-full bg-gray-200 rounded-full h-2 mt-1">
                    <div 
                      class="bg-genera-primary h-2 rounded-full" 
                      :style="{ width: `${(usage.agents / currentPlan.limits.agents) * 100}%` }"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Security Settings -->
      <div class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
            Security Settings
          </h3>
          
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div>
                <h4 class="text-sm font-medium text-gray-700">Two-Factor Authentication</h4>
                <p class="text-sm text-gray-500">Add an extra layer of security to your workspace</p>
              </div>
              <button class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90">
                Enable 2FA
              </button>
            </div>
            
            <div class="flex items-center justify-between">
              <div>
                <h4 class="text-sm font-medium text-gray-700">API Access</h4>
                <p class="text-sm text-gray-500">Manage API keys and access tokens</p>
              </div>
              <button class="border border-gray-300 text-gray-700 px-4 py-2 rounded-md text-sm font-medium hover:bg-gray-50">
                Manage API Keys
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'

const isUpdating = ref(false)

const workspaceForm = reactive({
  name: 'My Workspace',
  domain: 'my-workspace.genera-atende.com',
  description: 'A workspace for my team'
})

const currentPlan = ref({
  name: 'Professional',
  description: 'Perfect for growing businesses',
  price: 29,
  limits: {
    messages: 10000,
    agents: 5
  }
})

const usage = ref({
  messages: 3247,
  agents: 3
})

const updateWorkspaceInfo = async () => {
  isUpdating.value = true
  
  try {
    // TODO: Implement API call to update workspace
    await new Promise(resolve => setTimeout(resolve, 1000)) // Simulate API call
    console.log('Workspace updated:', workspaceForm)
  } catch (error) {
    console.error('Error updating workspace:', error)
  } finally {
    isUpdating.value = false
  }
}
</script>

<style scoped>
.genera-tenant-settings {
  @apply max-w-4xl mx-auto;
}
</style>
