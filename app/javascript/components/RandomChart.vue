<template>
  <div class="small">
    <line-chart :chart-data="datacollection" :options="options"></line-chart>
  </div>
</template>

<script>
import LineChart from './LineChart.js';
import moment from 'moment';

const Color = require("color")

const chartColors = {
	red: 'rgb(255, 99, 132)',
	orange: 'rgb(255, 159, 64)',
	yellow: 'rgb(255, 205, 86)',
	green: 'rgb(75, 192, 192)',
	blue: 'rgb(54, 162, 235)',
	purple: 'rgb(153, 102, 255)',
	grey: 'rgb(201, 203, 207)'
};

export default {
  components: {
    LineChart
  },
  data () {
    return {
      datacollection: null,
      options: {
        scales: {
          xAxes: [{
            type: 'time',
            distribution: 'series',
            ticks: {
              source: 'labels'
            }
          }],
          yAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'Closing price ($)'
            }
          }]
        },
        tooltips: {
          position: 'nearest',
          mode: 'index',
          intersect: false,
        },
      }
    }
  },
  mounted () {
    this.fillData()
  },
  methods: {
    fillData () {
      var dateFormat = 'MMMM DD YYYY';
      var date = moment('April 01 2017', dateFormat);
      var data = [this.randomBar(date, 1)];
      var labels = [date];
      while (data.length < 60) {
        date = date.clone().add(1, 'd');
        if (date.isoWeekday() <= 5) {
          data.push(this.randomBar(date, data[data.length - 1].y));
          labels.push(date);
        }
      }

      this.datacollection = {
        labels: labels,
        datasets: [{
          label: 'IDR',
          backgroundColor: Color(chartColors.red).alpha(0.5).rgbString(),
          borderColor: chartColors.red,
          data: data,
          type: 'line',
          pointRadius: 0,
          fill: false,
          lineTension: 0,
          borderWidth: 2
        }]
      }
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
    }
  }
}
</script>

<style>
  .small {
    max-width: 960px;
    margin:  150px auto;
  }
</style>