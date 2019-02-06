<template>
  <div>
    <RandomChart />
  </div>
</template>

<script>
export default {
  components: {
    RandomChart: () => import('./components/RandomChart.vue')
  }
}
</script>
