<template>
  <div class="container">
    <h1 class="ph3">Live rate for {{ now }}</h1>
    <line-chart :chart-data="dataCollection" :options="options"/>
  </div>
</template>

<script>
import moment from "moment";
import { forEach, keys, sample, map } from "lodash-es";
import promisePoller from "promise-poller";
import LineChart from "./LineChart.js";
import humps from "humps";
import currencyColor from "./currencyColor.js";

const queryString = require("query-string");

let poller;
let clock;

export default {
  components: {
    LineChart
  },
  data() {
    return {
      now: moment().calendar(),
      dataCollection: null,
      options: {
        scales: {
          xAxes: [
            {
              type: "time",
              distribution: "series",
              ticks: {
                source: "labels"
              }
            }
          ]
        },
        tooltips: {
          position: "nearest",
          mode: "index",
          intersect: false
        }
      },
      quotes: {
        USD: [],
        BRL: [],
        EUR: [],
        AUD: []
      }
    };
  },
  mounted() {
    this.fetchLiveData()
      .then(rates => this.fillData(rates))
      .catch(error => console.error(error));
    poller = setInterval(() => {
      promisePoller({
        taskFn: () => this.fetchLiveData(),
        interval: 1000,
        retries: 5,
        timeout: 40000,
        strategy: "exponential-backoff",
        min: 1000,
        max: 40000
      })
        .then(rates => this.fillData(rates))
        .catch(error => console.error(error));
    }, 600000);
    clock = setInterval(() => {
      this.$set(this.$data, "now", moment().calendar());
    }, 1000);
  },
  destroyed() {
    clearInterval(poller);
    clearInterval(clock);
  },
  methods: {
    fillData(rates) {
      const labels = map(rates, rate => {
        forEach(rate.quotes, quote => {
          this.$data.quotes[quote.iso].push(quote.rate);
        });
        return moment(rate.timestamp);
      });

      const datasets = map(keys(this.$data.quotes), currencyCode => {
        const { backgroundColor, borderColor } = currencyColor(currencyCode);
        return {
          label: currencyCode,
          backgroundColor,
          borderColor,
          data: this.$data.quotes[currencyCode],
          type: "line",
          pointRadius: 0,
          fill: false,
          lineTension: 0,
          borderWidth: 2
        };
      });

      this.$set(this.$data, "dataCollection", {
        labels: labels,
        datasets: datasets
      });
    },
    fetchLiveData() {
      const params = queryString.stringify(
        humps.decamelizeKeys({
          utcOffset: moment().utcOffset()
        })
      );
      return this.$http
        .get(`/api/rates/live.json?${params}`)
        .then(response => Promise.resolve(response.body))
        .catch(error => Promise.reject(error));
    }
  }
};
</script>

<style lang="scss" scoped>
.container {
  max-width: 800px;
}
</style>
