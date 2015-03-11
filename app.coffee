express = require('express')
app = express()
loki = require('lokijs')
crypto = require("crypto")
yaml = require('js-yaml')
fs   = require('fs')
traitify = require("traitify")
cors = require('cors')
app.use(cors())

db = new loki('traitify_assessment_generator.json')
config = yaml.safeLoad(fs.readFileSync('./config.yml', 'utf8'))

tempKeys = db.addCollection("TemporaryKeys")

app.get('/temp_key', (req, res)->
  rawKey = crypto.randomBytes(20).toString('hex')
  environmentName = Object.keys(config).filter((index)->
    if index != 'server'
      config[index].public_key == req.query.public_key
  )
  environment = config[environmentName[0]]
  secret_key = environment.secret_key
  key = tempKeys.insert({tempKey: rawKey, secretKey: secret_key})
  url = "#{config.default.redirect_url}?temp_key=#{key.tempKey}"
  res.redirect(url)
)
app.post("/assessments", (req, res)->
  tempKey = tempKeys.findOne({tempKey: req.query.temp_key})
  if tempKey
    traitify.setHost(config.default.traitify_host)
    traitify.setVersion(config.default.traitify_version)
    traitify.setSecretKey(tempKey.secretKey)
    traitify.createAssessment(config.default.traitify_deck, (assessment)->
      tempKeys.remove(tempKey)
      res.send(assessment)
    )
  else
    res.send({error: "Your Temporary Key Was Invalid"})
)
app.listen(config.server.port)
