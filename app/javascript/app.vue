<template>
  <div>
    <div class="ml4">
      <div class="flex">
        <h5>Mode</h5>
        <div class="flex items-center ml3">
          <label for="liveMode" class="w3">
            <input type="radio" value="live" id="liveMode" v-model="mode">
            Live
          </label>

          <label for="historicalMode" class="w4">
            <input type="radio" id="historicalMode" value="historical" v-model="mode">
            History
          </label>
        </div>
      </div>
    </div>
    <LiveChart v-if="isLiveMode"/>
  </div>
</template>

<script>
export default {
  components: {
    LiveChart: () => import("./components/LiveChart.vue")
  },
  data() {
    return {
      mode: "live"
    };
  },
  computed: {
    isLiveMode() {
      return this.$data.mode === "live";
    },
    isHistoricalMode() {
      return this.$data.mode === 'historical'
    }
  }
};
</script>
