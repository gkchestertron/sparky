import login from './login'
import register from './register'

export default {
  install(Vue, options) {
    Vue.mixin({
      methods: {
        login: login,

        logout() {
          localStorage.removeItem('authToken')
          window.location.pathname = ''
        },

        register: register
      }
    })
  }
}
