<template>
  <div class="genera-workspace-selector">
    <div class="relative">
      <button 
        @click="showDropdown = !showDropdown"
        class="flex items-center justify-between w-full px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-genera-primary focus:border-genera-primary"
      >
        <div class="flex items-center">
          <div class="w-8 h-8 bg-genera-primary rounded-lg flex items-center justify-center mr-3">
            <span class="text-white text-sm font-semibold">
              {{ currentWorkspace.name.charAt(0).toUpperCase() }}
            </span>
          </div>
          <div class="text-left">
            <p class="font-medium">{{ currentWorkspace.name }}</p>
            <p class="text-xs text-gray-500">{{ currentWorkspace.plan }}</p>
          </div>
        </div>
        <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
        </svg>
      </button>
      
      <!-- Dropdown Menu -->
      <div 
        v-if="showDropdown"
        class="absolute z-10 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none"
      >
        <div 
          v-for="workspace in workspaces" 
          :key="workspace.id"
          @click="selectWorkspace(workspace)"
          :class="[
            'cursor-pointer select-none relative py-2 pl-3 pr-9',
            workspace.id === currentWorkspace.id 
              ? 'bg-genera-primary text-white' 
              : 'text-gray-900 hover:bg-gray-100'
          ]"
        >
          <div class="flex items-center">
            <div 
              :class="[
                'w-8 h-8 rounded-lg flex items-center justify-center mr-3',
                workspace.id === currentWorkspace.id 
                  ? 'bg-white/20' 
                  : 'bg-genera-primary/10'
              ]"
            >
              <span 
                :class="[
                  'text-sm font-semibold',
                  workspace.id === currentWorkspace.id 
                    ? 'text-white' 
                    : 'text-genera-primary'
                ]"
              >
                {{ workspace.name.charAt(0).toUpperCase() }}
              </span>
            </div>
            <div>
              <p 
                :class="[
                  'font-medium',
                  workspace.id === currentWorkspace.id ? 'text-white' : 'text-gray-900'
                ]"
              >
                {{ workspace.name }}
              </p>
              <p 
                :class="[
                  'text-xs',
                  workspace.id === currentWorkspace.id ? 'text-white/80' : 'text-gray-500'
                ]"
              >
                {{ workspace.plan }}
              </p>
            </div>
          </div>
          
          <!-- Checkmark for selected workspace -->
          <span 
            v-if="workspace.id === currentWorkspace.id"
            class="absolute inset-y-0 right-0 flex items-center pr-4"
          >
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
            </svg>
          </span>
        </div>
        
        <!-- Add Workspace Option -->
        <div 
          @click="createNewWorkspace"
          class="cursor-pointer select-none relative py-2 pl-3 pr-9 text-gray-900 hover:bg-gray-100 border-t border-gray-100"
        >
          <div class="flex items-center">
            <div class="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center mr-3">
              <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
              </svg>
            </div>
            <div>
              <p class="font-medium text-gray-900">Create New Workspace</p>
              <p class="text-xs text-gray-500">Start a new workspace</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  workspaces: {
    type: Array,
    default: () => []
  },
  currentWorkspaceId: {
    type: [String, Number],
    required: true
  }
})

const emit = defineEmits(['workspace-selected', 'create-workspace'])

const showDropdown = ref(false)

const currentWorkspace = computed(() => {
  return props.workspaces.find(w => w.id === props.currentWorkspaceId) || props.workspaces[0]
})

const selectWorkspace = (workspace) => {
  emit('workspace-selected', workspace)
  showDropdown.value = false
}

const createNewWorkspace = () => {
  emit('create-workspace')
  showDropdown.value = false
}

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (!event.target.closest('.genera-workspace-selector')) {
    showDropdown.value = false
  }
}

// Add event listener for outside clicks
if (typeof window !== 'undefined') {
  document.addEventListener('click', handleClickOutside)
}
</script>

<style scoped>
.genera-workspace-selector {
  @apply relative;
}
</style>
