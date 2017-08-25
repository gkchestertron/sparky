<template>
  <div class="col-md-6 col-offset-3">
    <b-card>
      <b-alert dismissable variant="danger" :show="!!error">
        {{error}}
      </b-alert>
      <form @submit.prevent="login">
        <b-form-input
          v-model="email"
          type="text"
          placeholder="Enter your email"
        ></b-form-input>
        <b-form-input
          v-model="password"
          type="password"
          placeholder="Enter your password"
        ></b-form-input>
        <b-button type="submit" variant="primary">Login</b-button>
      </form>
    </b-card>
  </div>
</template>

<script>
  import apollo from '../vape/ApolloClient'
  import gql from 'graphql-tag'

  export default {
    data() {
      return {
        email: '',
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

    name: 'login'
  }
</script>

<style lang="stylus" scoped>
  label
    color black
  input
    margin-bottom: 15px
</style>
