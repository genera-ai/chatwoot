<template>
  <div class="genera-user-management">
    <div class="bg-white shadow rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg leading-6 font-medium text-gray-900">
            Team Members
          </h3>
          <button 
            @click="showInviteModal = true"
            class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90"
          >
            Invite Member
          </button>
        </div>
        
        <!-- Users Table -->
        <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
          <table class="min-w-full divide-y divide-gray-300">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  User
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Role
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Last Active
                </th>
                <th class="relative px-6 py-3">
                  <span class="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="user in users" :key="user.id">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10">
                      <div class="h-10 w-10 rounded-full bg-genera-primary flex items-center justify-center">
                        <span class="text-sm font-medium text-white">
                          {{ user.name.charAt(0).toUpperCase() }}
                        </span>
                      </div>
                    </div>
                    <div class="ml-4">
                      <div class="text-sm font-medium text-gray-900">{{ user.name }}</div>
                      <div class="text-sm text-gray-500">{{ user.email }}</div>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span 
                    :class="[
                      'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                      user.role === 'admin' 
                        ? 'bg-red-100 text-red-800' 
                        : user.role === 'agent'
                        ? 'bg-blue-100 text-blue-800'
                        : 'bg-gray-100 text-gray-800'
                    ]"
                  >
                    {{ user.role.charAt(0).toUpperCase() + user.role.slice(1) }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span 
                    :class="[
                      'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                      user.status === 'active' 
                        ? 'bg-green-100 text-green-800' 
                        : 'bg-yellow-100 text-yellow-800'
                    ]"
                  >
                    {{ user.status.charAt(0).toUpperCase() + user.status.slice(1) }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ formatDate(user.lastActive) }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <div class="flex items-center space-x-2">
                    <button 
                      @click="editUser(user)"
                      class="text-genera-primary hover:text-genera-primary/80"
                    >
                      Edit
                    </button>
                    <button 
                      @click="removeUser(user)"
                      class="text-red-600 hover:text-red-800"
                    >
                      Remove
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- Empty State -->
        <div v-if="users.length === 0" class="text-center py-8">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No team members</h3>
          <p class="mt-1 text-sm text-gray-500">Get started by inviting your first team member.</p>
        </div>
      </div>
    </div>
    
    <!-- Invite Member Modal -->
    <div v-if="showInviteModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Invite Team Member</h3>
        
        <form @submit.prevent="inviteUser" class="space-y-4">
          <div>
            <label for="invite-email" class="block text-sm font-medium text-gray-700">
              Email Address
            </label>
            <input
              id="invite-email"
              v-model="inviteForm.email"
              type="email"
              required
              class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-genera-primary focus:border-genera-primary sm:text-sm"
              placeholder="colleague@example.com"
            />
          </div>
          
          <div>
            <label for="invite-role" class="block text-sm font-medium text-gray-700">
              Role
            </label>
            <select
              id="invite-role"
              v-model="inviteForm.role"
              class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-genera-primary focus:border-genera-primary sm:text-sm"
            >
              <option value="agent">Agent</option>
              <option value="admin">Admin</option>
            </select>
          </div>
          
          <div class="flex justify-end space-x-3">
            <button 
              type="button"
              @click="showInviteModal = false"
              class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200"
            >
              Cancel
            </button>
            <button 
              type="submit"
              :disabled="isInviting"
              class="px-4 py-2 text-sm font-medium text-white bg-genera-primary rounded-md hover:bg-genera-primary/90 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ isInviting ? 'Sending...' : 'Send Invite' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'

const showInviteModal = ref(false)
const isInviting = ref(false)

const inviteForm = reactive({
  email: '',
  role: 'agent'
})

const users = ref([
  {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin',
    status: 'active',
    lastActive: new Date('2024-01-15')
  },
  {
    id: 2,
    name: 'Jane Smith',
    email: 'jane@example.com',
    role: 'agent',
    status: 'active',
    lastActive: new Date('2024-01-14')
  },
  {
    id: 3,
    name: 'Bob Johnson',
    email: 'bob@example.com',
    role: 'agent',
    status: 'pending',
    lastActive: new Date('2024-01-10')
  }
])

const formatDate = (date) => {
  return new Intl.DateTimeFormat('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  }).format(date)
}

const editUser = (user) => {
  console.log('Edit user:', user)
  // TODO: Implement edit user functionality
}

const removeUser = (user) => {
  if (confirm(`Are you sure you want to remove ${user.name} from the workspace?`)) {
    users.value = users.value.filter(u => u.id !== user.id)
  }
}

const inviteUser = async () => {
  isInviting.value = true
  
  try {
    // TODO: Implement API call to invite user
    await new Promise(resolve => setTimeout(resolve, 1000)) // Simulate API call
    
    // Add to users list
    users.value.push({
      id: Date.now(),
      name: inviteForm.email.split('@')[0],
      email: inviteForm.email,
      role: inviteForm.role,
      status: 'pending',
      lastActive: new Date()
    })
    
    // Reset form and close modal
    inviteForm.email = ''
    inviteForm.role = 'agent'
    showInviteModal.value = false
  } catch (error) {
    console.error('Error inviting user:', error)
  } finally {
    isInviting.value = false
  }
}
</script>

<style scoped>
.genera-user-management {
  @apply max-w-6xl mx-auto;
}
</style>
