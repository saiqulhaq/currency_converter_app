/* eslint no-console: 0 */
import Vue from 'vue'
import App from '../app.vue'
import VueResource from 'vue-resource'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('application'))
  Vue.use(VueResource)
  const app = new Vue({
    el,
    render: h => h(App)
  })
})
