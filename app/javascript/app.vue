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
        <div class="flex items-center" v-if="isHistoricalMode">
          <div>
            <label for="startDate">Start date</label>
            <Datepicker v-model="form.startDate"/>
          </div>
          <div class="ml2">
            <label for="endDate">End date</label>
            <Datepicker v-model="form.endDate"/>
          </div>
        </div>
      </div>
    </div>
    <LiveChart v-if="isLiveMode"/>
    <HistoricalChart v-else :startDate="form.startDate" :endDate="form.endDate" />
  </div>
</template>

<script>
import moment from 'moment';

export default {
  components: {
    LiveChart: () => import("./components/LiveChart.vue"),
    HistoricalChart: () => import('./components/HistoricalChart.vue'),
    Datepicker: () => import("vuejs-datepicker")
  },
  data() {
    const today = moment()
    return {
      mode: "live",
      form: {
        endDate: today.toDate(),
        startDate: today.subtract(1, 'week').toDate()
      }
    };
  },
  computed: {
    isLiveMode() {
      return this.$data.mode === "live";
    },
    isHistoricalMode() {
      return this.$data.mode === "historical";
    }
  }
};
</script>
