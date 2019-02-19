/* eslint no-console: 0 */
import "nprogress/nprogress.css";
import "tachyons";

import Vue from "vue";
import App from "../app.vue";
import VueResource from "vue-resource";
import NProgress from "nprogress";

Vue.use(VueResource);

Vue.http.interceptors.push(function() {
  NProgress.start();

  return function() {
    NProgress.done();
  };
});

document.addEventListener("DOMContentLoaded", () => {
  const el = document.body.appendChild(document.createElement("application"));
  const app = new Vue({
    el,
    render: h => h(App)
  });
});
