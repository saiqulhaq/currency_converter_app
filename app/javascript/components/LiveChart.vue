<template>
  <div class="small">
    <line-chart :chart-data="dataCollection" :options="options"/>
  </div>
</template>

<script>
import moment from "moment";
import { forEach, keys, sample, map } from "lodash-es";
import promisePoller from "promise-poller";
import LineChart from "./LineChart.js";

const Color = require("color");

const chartColors = {
  red: "rgb(255, 99, 132)",
  orange: "rgb(255, 159, 64)",
  yellow: "rgb(255, 205, 86)",
  green: "rgb(75, 192, 192)",
  blue: "rgb(54, 162, 235)",
  purple: "rgb(153, 102, 255)",
  grey: "rgb(201, 203, 207)"
};

let poller;

export default {
  components: {
    LineChart
  },
  data() {
    return {
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
        strategy: 'exponential-backoff',
        min: 1000,
        max: 40000
      })
        .then(rates => this.fillData(rates))
        .catch(error => console.error(error));
    }, 600000);
  },
  destroyed() {
    clearInterval(poller);
  },
  methods: {
    fillData(rates) {
      const labels = map(rates, rate => {
        forEach(rate.quotes, quote => {
          this.$data.quotes[quote.iso].push(quote.rate);
        });
        return moment(rate.timestamp);
      });

      const datasets = map(keys(this.$data.quotes), rateCode => {
        const color = chartColors[sample(keys(chartColors))];
        return {
          label: rateCode,
          backgroundColor: Color(color)
            .alpha(0.5)
            .rgbString(),
          borderColor: color,
          data: this.$data.quotes[rateCode],
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
      return this.$http
        .get("/api/rates/live.json")
        .then(response => Promise.resolve(response.body))
        .catch(error => Promise.reject(error));
    }
  }
};
</script>

<style>
.small {
  max-width: 600px;
}
</style>