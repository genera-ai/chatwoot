<script setup>
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();

const currentPlan = ref({
  name: 'Professional',
  description: 'Perfect for growing businesses',
  price: 29,
  limits: {
    messages: 10000,
    agents: 5,
    storage: 100,
  },
});

const usage = ref({
  messages: 3247,
  agents: 3,
  storage: 23,
});

const nextBillingDate = computed(() => {
  const date = new Date();
  date.setMonth(date.getMonth() + 1);
  return date.toLocaleDateString();
});

const nextBillingText = computed(() =>
  t('GENERA_ATENDE.BILLING.NEXT_BILLING', { date: nextBillingDate.value })
);
const planPrice = computed(() =>
  t('GENERA_ATENDE.BILLING.PRICE_PER_MONTH', { price: currentPlan.value.price })
);
</script>

<template>
  <div class="genera-billing-dashboard">
    <div class="bg-white shadow rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
          {{ $t('GENERA_ATENDE.BILLING.OVERVIEW') }}
        </h3>

        <!-- Current Plan -->
        <div class="mb-6">
          <h4 class="text-sm font-medium text-gray-500 mb-2">
            {{ $t('GENERA_ATENDE.BILLING.CURRENT_PLAN') }}
          </h4>
          <div
            class="bg-genera-primary/10 border border-genera-primary/20 rounded-md p-4"
          >
            <div class="flex items-center justify-between">
              <div>
                <p class="text-lg font-semibold text-genera-primary">
                  {{ currentPlan.name }}
                </p>
                <p class="text-sm text-gray-600">
                  {{ currentPlan.description }}
                </p>
              </div>
              <div class="text-right">
                <p class="text-2xl font-bold text-genera-primary">
                  {{ planPrice }}
                </p>
                <p class="text-sm text-gray-500">{{ nextBillingText }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Usage Stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div class="bg-gray-50 rounded-lg p-4">
            <p class="text-sm font-medium text-gray-500">
              {{ $t('GENERA_ATENDE.BILLING.MESSAGES_THIS_MONTH') }}
            </p>
            <p class="text-2xl font-bold text-gray-900">{{ usage.messages }}</p>
            <p class="text-sm text-gray-500">
              {{
                $t('GENERA_ATENDE.BILLING.OF_INCLUDED', {
                  count: currentPlan.limits.messages,
                })
              }}
            </p>
          </div>

          <div class="bg-gray-50 rounded-lg p-4">
            <p class="text-sm font-medium text-gray-500">
              {{ $t('GENERA_ATENDE.BILLING.ACTIVE_AGENTS') }}
            </p>
            <p class="text-2xl font-bold text-gray-900">{{ usage.agents }}</p>
            <p class="text-sm text-gray-500">
              {{
                $t('GENERA_ATENDE.BILLING.OF_INCLUDED', {
                  count: currentPlan.limits.agents,
                })
              }}
            </p>
          </div>

          <div class="bg-gray-50 rounded-lg p-4">
            <p class="text-sm font-medium text-gray-500">
              {{ $t('GENERA_ATENDE.BILLING.STORAGE_USED') }}
            </p>
            <p class="text-2xl font-bold text-gray-900">
              {{ usage.storage }}{{ $t('GENERA_ATENDE.BILLING.GB') }}
            </p>
            <p class="text-sm text-gray-500">
              {{
                $t('GENERA_ATENDE.BILLING.OF_INCLUDED', {
                  count:
                    currentPlan.limits.storage + $t('GENERA_ATENDE.BILLING.GB'),
                })
              }}
            </p>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex space-x-4">
          <button
            class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90"
          >
            {{ $t('GENERA_ATENDE.NAV.UPGRADE_PLAN') }}
          </button>
          <button
            class="border border-gray-300 text-gray-700 px-4 py-2 rounded-md text-sm font-medium hover:bg-gray-50"
          >
            {{ $t('GENERA_ATENDE.NAV.VIEW_INVOICES') }}
          </button>
          <button
            class="border border-gray-300 text-gray-700 px-4 py-2 rounded-md text-sm font-medium hover:bg-gray-50"
          >
            {{ $t('GENERA_ATENDE.NAV.PAYMENT_METHODS') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.genera-billing-dashboard {
  @apply max-w-4xl mx-auto;
}
</style>
