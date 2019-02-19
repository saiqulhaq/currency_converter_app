<template>
  <div>
    <Navbar>
      <div slot="links">
        <div class="flex items-center ml5 white">
          <label for="liveMode" :class="[isLiveMode ? 'b' : '']">
            <input type="radio" value="live" class="dn" id="liveMode" v-model="mode">
            Live
          </label>
          
          <label for="historicalMode" class="ml4" :class="[isHistoricalMode ? 'b' : '']">
            <input type="radio" id="historicalMode" class="dn" value="historical" v-model="mode">
            History
          </label>
        </div>
      </div>
    </Navbar>

    <div class="mw8 center pb3 ph3">
      <div class="flex">
        <div class="flex items-center mt4 ph1" v-if="isHistoricalMode">
          <div class="mr2">Start date</div>
          <Datepicker v-model="form.startDate"/>
          <div class="ml4 mr2">End date</div>
          <Datepicker v-model="form.endDate"/>
        </div>
      </div>
      <LiveChart v-if="isLiveMode"/>
      <HistoricalChart v-else :startDate="form.startDate" :endDate="form.endDate"/>
    </div>
  </div>
</template>

<script>
import moment from "moment";

import Navbar from "./components/Navbar.vue";

export default {
  components: {
    LiveChart: () => import("./components/LiveChart.vue"),
    HistoricalChart: () => import("./components/HistoricalChart.vue"),
    Datepicker: () => import("vuejs-datepicker"),
    Navbar
  },
  data() {
    const today = moment();
    return {
      mode: "live",
      form: {
        endDate: today.toDate(),
        startDate: today.subtract(1, "week").toDate()
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
