<template>
  <div>
    <Chart />
  </div>
</template>

<script>
export default {
  components: {
    Chart: () => import('./components/Chart.vue')
  }
}
</script>
