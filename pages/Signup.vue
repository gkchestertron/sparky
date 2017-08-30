<template>
  <div class="col-md-8 col-md-offset-2">
    <b-alert dismissable variant="danger" :show="!!error">
      {{error}}
    </b-alert>
    <form @submit.prevent="register">
      <div class="row">
        <div class="col-md-6">
          <b-form-input
            size="lg"
            v-model="firstName"
            type="text"
            placeholder="First name"
          ></b-form-input>
        </div>
        <div class="col-md-6 last-name">
          <b-form-input
            size="lg"
            v-model="lastName"
            type="text"
            placeholder="last name"
          ></b-form-input>
        </div>
      </div>
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
      <b-button size="lg" type="submit">Signup</b-button>
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

    name: 'signup'
  }
</script>

<style lang="stylus" scoped>
  .last-name
    @media(min-width 721px)
      padding-left 0px
  input
    margin-bottom 15px
</style>
