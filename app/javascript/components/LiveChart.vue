<template>
  <div class="small">
    <line-chart :chart-data="datacollection" :options="options"></line-chart>
  </div>
</template>

<script>
import moment from "moment";
import { forEach, keys, sample } from "lodash-es";
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

export default {
  components: {
    LineChart
  },
  data() {
    return {
      datacollection: null,
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
          ],
          yAxes: [
            {
              scaleLabel: {
                display: true,
                labelString: "Closing price ($)"
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
      labels: [],
      quotes: {
        USD: [],
        BRL: [],
        EUR: [],
        AUD: []
      }
    };
  },
  mounted() {
    this.fetchLiveData(this.fillData);
  },
  methods: {
    fillData(rates) {
      const labels = [];
      forEach(rates, rate => {
        const timestamp = moment(rate.timestamp);
        forEach(rate.quotes, quote => {
          this.$data.quotes[quote.iso].push(quote.rate);
        });
        labels.push(timestamp);
      });
      this.$set(this.$data, "labels", labels);

      const datasets = [];

      forEach(keys(this.$data.quotes), rateCode => {
        const color = chartColors[sample(keys(chartColors))];
        const item = {
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
        datasets.push(item);
      });

      this.datacollection = {
        labels: labels,
        datasets: datasets
      };
    },
    randomNumber(min, max) {
      return Math.random() * (max - min) + min;
    },
    randomBar(date, lastClose) {
      var open = this.randomNumber(lastClose * -1, lastClose * 1);
      var close = this.randomNumber(open - 1, open + 1);
      return {
        t: date.valueOf(),
        y: close
      };
    },
    fetchLiveData(callback) {
      this.$http
        .get("/api/rates/live.json")
        .then(response => callback(response.body))
        .catch(error => console.error(error));
    }
  }
};
</script>

<style>
.small {
  max-width: 600px;
}
</style>