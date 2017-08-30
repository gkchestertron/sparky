import axios from 'axios'

export default function register() {
  return axios.post('./register', {
    firstName : this.firstName,
    lastName  : this.lastName,
    email     : this.email,
    password  : this.password
  })
}
