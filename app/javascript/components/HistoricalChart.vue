<template>
  <div class="small">
    <line-chart :chart-data="dataCollection" :options="options"></line-chart>
  </div>
</template>

<script>
import moment from "moment";
import { forEach, keys, sample } from "lodash-es";
import LineChart from "./LineChart.js";
import humps from "humps";

const queryString = require("query-string");
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
  props: {
    startDate: {
      required: true,
      type: Date
    },
    endDate: {
      required: true,
      type: Date
    }
  },
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
  watch: {
    startDate() {
      this.fetchAndDraw();
    },
    endDate() {
      this.fetchAndDraw();
    }
  },
  mounted() {
    this.fetchAndDraw();
  },
  methods: {
    fetchAndDraw() {
      this.fetchHistoricalData(this.fillData);
    },
    fillData(rates) {
      const labels = [];
      forEach(rates, rate => {
        const date = moment(rate.date);
        forEach(rate.quotes, quote => {
          this.$data.quotes[quote.iso].push(quote.rate);
        });
        labels.push(date);
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

      this.dataCollection = {
        labels: labels,
        datasets: datasets
      };
    },
    fetchHistoricalData(callback) {
      const { startDate, endDate } = this.$props;
      const query = queryString.stringify(
        humps.decamelizeKeys({
          startDate,
          endDate
        })
      );
      this.$http
        .get(`/api/rates/historical.json?${query}`)
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