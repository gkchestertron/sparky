const path = require('path')
const config = require(path.resolve('./config/server'))

const nodemailer = require('nodemailer')

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: config.GMAIL_USERNAME,
    pass: config.GMAIL_PASSWORD
  }
})

module.exports = function simpleMail(options) {
  const mailOptions = Object.assign({}, {
    from: config.GMAIL_USERNAME,
  }, options)

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, function(error, info){
      if (error)
        return reject(error)
      return resolve(info)
    })
  })
}
