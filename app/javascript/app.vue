<template>
  <div>
    <LiveChart />
  </div>
</template>

<script>
export default {
  components: {
    LiveChart: () => import('./components/LiveChart.vue')
  }
}
</script>
