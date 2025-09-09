<template>
  <header class="genera-header bg-white shadow-sm border-b border-gray-200">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <div class="flex items-center">
          <GeneraLogo />
        </div>
        
        <!-- Navigation -->
        <nav class="hidden md:flex space-x-8">
          <a href="#" class="text-gray-700 hover:text-genera-primary px-3 py-2 text-sm font-medium">
            Dashboard
          </a>
          <a href="#" class="text-gray-700 hover:text-genera-primary px-3 py-2 text-sm font-medium">
            Billing
          </a>
          <a href="#" class="text-gray-700 hover:text-genera-primary px-3 py-2 text-sm font-medium">
            Settings
          </a>
        </nav>
        
        <!-- User Menu -->
        <div class="flex items-center space-x-4">
          <button class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90">
            Upgrade Plan
          </button>
          <div class="relative">
            <!-- User avatar/dropdown placeholder -->
            <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import GeneraLogo from './GeneraLogo.vue'
</script>

<style scoped>
.genera-header {
  @apply sticky top-0 z-50;
}
</style>
