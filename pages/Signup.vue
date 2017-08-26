<template>
  <div class="col-md-8 col-md-offset-2">
    <b-alert dismissable variant="danger" :show="!!error">
      {{error}}
    </b-alert>
    <form @submit.prevent="login">
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
  import apollo from '../vape/ApolloClient'
  import gql from 'graphql-tag'

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

    methods: {
      login() {
        return apollo().mutate({
          mutation: gql`
            mutation ($email: String!, $password: String!) {
              authenticate(input: {
                email: $email,
                password: $password
              }) {
                clientMutationId
                jwtToken
              }
            }
          `,
          variables: {
            email    : this.email,
            password : this.password
          }
        })
        .then(result => {
          let authToken = null

          try {
            authToken = result.data.authenticate.jwtToken
          }
          catch (err) {
            console.error(err)
          }

          if (authToken) {
            localStorage.setItem('authToken', authToken)
            window.location.pathname = '/'
          }
          else {
            this.error = 'Invalid login'
          }
        })
        .catch(err => {
          console.log(err)
        })
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
