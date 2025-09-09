<script setup>
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();

const showAddModal = ref(false);

const paymentMethods = ref([
  {
    id: 1,
    brand: 'VISA',
    last4: '4242',
    expMonth: '12',
    expYear: '2025',
    isDefault: true,
  },
  {
    id: 2,
    brand: 'MC',
    last4: '5555',
    expMonth: '08',
    expYear: '2026',
    isDefault: false,
  },
]);

const setAsDefault = methodId => {
  paymentMethods.value.forEach(method => {
    method.isDefault = method.id === methodId;
  });
};

const removeMethod = methodId => {
  // safe confirm wrapper
  const proceed = window.confirm(t('GENERA_ATENDE.PAYMENT.CONFIRM_REMOVE'));
  if (proceed) {
    paymentMethods.value = paymentMethods.value.filter(
      method => method.id !== methodId
    );
  }
};
</script>

<template>
  <div class="genera-payment-methods">
    <div class="bg-white shadow rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg leading-6 font-medium text-gray-900">
            {{ $t('GENERA_ATENDE.NAV.PAYMENT_METHODS') }}
          </h3>
          <button
            class="bg-genera-primary text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-genera-primary/90"
            @click="showAddModal = true"
          >
            {{ $t('GENERA_ATENDE.PAYMENT.ADD_METHOD') }}
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
              <div
                class="w-10 h-6 bg-gray-100 rounded flex items-center justify-center mr-3"
              >
                <span class="text-xs font-medium text-gray-600">{{
                  method.brand
                }}</span>
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900">
                  **** **** **** {{ method.last4 }}
                </p>
                <p class="text-sm text-gray-500">
                  {{
                    $t('GENERA_ATENDE.PAYMENT.EXPIRES', {
                      month: method.expMonth,
                      year: method.expYear,
                    })
                  }}
                </p>
              </div>
            </div>

            <div class="flex items-center space-x-2">
              <span
                v-if="method.isDefault"
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
              >
                {{ $t('GENERA_ATENDE.PAYMENT.DEFAULT') }}
              </span>
              <button
                :disabled="method.isDefault"
                class="text-sm text-genera-primary hover:text-genera-primary/80 disabled:text-gray-400 disabled:cursor-not-allowed"
                @click="setAsDefault(method.id)"
              >
                {{ $t('GENERA_ATENDE.PAYMENT.SET_DEFAULT') }}
              </button>
              <button
                class="text-sm text-red-600 hover:text-red-800"
                @click="removeMethod(method.id)"
              >
                {{ $t('GENERA_ATENDE.PAYMENT.REMOVE') }}
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="paymentMethods.length === 0" class="text-center py-8">
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"
            />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">
            {{ $t('GENERA_ATENDE.PAYMENT.EMPTY_TITLE') }}
          </h3>
          <p class="mt-1 text-sm text-gray-500">
            {{ $t('GENERA_ATENDE.PAYMENT.EMPTY_DESC') }}
          </p>
        </div>
      </div>
    </div>

    <!-- Add Payment Method Modal (placeholder) -->
    <div
      v-if="showAddModal"
      class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50"
    >
      <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        <h3 class="text-lg font-medium text-gray-900 mb-4">
          {{ $t('GENERA_ATENDE.PAYMENT.ADD_METHOD') }}
        </h3>
        <p class="text-sm text-gray-500 mb-4">
          {{ $t('GENERA_ATENDE.PAYMENT.INTEGRATION_PLACEHOLDER') }}
        </p>
        <div class="flex justify-end space-x-3">
          <button
            class="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200"
            @click="showAddModal = false"
          >
            {{ $t('GENERAL.CLOSE') }}
          </button>
          <button
            class="px-4 py-2 text-sm font-medium text-white bg-genera-primary rounded-md hover:bg-genera-primary/90"
            @click="showAddModal = false"
          >
            {{ $t('GENERA_ATENDE.PAYMENT.ADD_METHOD') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.genera-payment-methods {
  @apply max-w-4xl mx-auto;
}
</style>
