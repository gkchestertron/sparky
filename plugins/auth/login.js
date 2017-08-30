import apollo from '../../vape/ApolloClient'
import gql from 'graphql-tag'

export default function login(email, password) {
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
