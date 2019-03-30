<template>
  <div class="container mt3">
    <line-chart :chart-data="dataCollection" :options="options"></line-chart>
  </div>
</template>

<script>
import moment from "moment";
import { forEach, map, keys, sample, sortBy } from "lodash-es";
import humps from "humps";
import LineChart from "./LineChart.js";
import currencyColor from "./currencyColor.js";

const queryString = require("query-string");

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
        tooltips: {
          position: "nearest",
          mode: "index",
          intersect: false
        }
      },
      quotes: {
        USD: [],
        SGD: [],
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
      const labels = map(rates, rate => {
        forEach(rate.quotes, quote => {
          this.$data.quotes[quote.iso].push(quote.rate);
        });
        return moment(rate.date)
          .format("DD MMM")
          .toString();
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
        .then(response => callback(sortBy(response.body, "date")))
        .catch(error => console.error(error));
    }
  }
};
</script>

<style lang="scss" scoped>
.container {
  max-width: 800px;
}
</style>