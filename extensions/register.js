const path                = require('path')
const runPostGraphQLQuery = require(path.resolve('./vape/util/postgraphql/runPostGraphQLQuery'))

module.exports = {
  install(app) {
    app.post('/register', function (req, res, next) {
      runPostGraphQLQuery(`mutation ($input: RegisterPersonInput!) {
        registerPerson (input: $input) {
          person {
            fullName
          }
        }
      }`, {
        input: {
          firstName : req.body.firstName,
          lastName  : req.body.lastName,
          email     : req.body.email,
          password  : req.body.password
        }
      })
      .then(result => {
        console.log(result)
        res.send(result)
      })
      .catch(err => console.error(err))
    })
  }
}
