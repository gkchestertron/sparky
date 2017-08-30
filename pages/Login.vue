<template>
  <div class="col-md-8 col-md-offset-2">
    <b-alert dismissable variant="danger" :show="!!error">
      {{error}}
    </b-alert>
    <form @submit.prevent="login(this.email, this.password)">
      <b-form-input
        size="lg"
        v-model="email"
        type="text"
        placeholder="Enter your email"
      ></b-form-input>
      <b-form-input
        size="lg"
        v-model="password"
        type="password"
        placeholder="Enter your password"
      ></b-form-input>
      <b-button size="lg" type="submit">Login</b-button>
    </form>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        email: '',
        firstName: '',
        lastName: '',
        password: '',
        error: ''
      }
    },

    name: 'login'
  }
</script>

<style lang="stylus" scoped>
  .last-name
    @media(min-width 721px)
      padding-left 0px
  input
    margin-bottom 15px
</style>
