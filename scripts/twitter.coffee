# Description:
#   gets tweet from user
#
# Dependencies:
#   "twit": "1.1.6"
#   "underscore": "1.4.4"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   !twitter [<twitter username>] - Show last tweet from <twitter username> (default is your username)
#
# Author:
#   KevinTraver
#   Rob Allen
#

_ = require "underscore"
Twit = require "twit"
config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

module.exports = (robot) ->
  twit = undefined

  robot.hear /^!tw(?:itter)?\s?(\S*)/i, (msg) ->
    unless config.consumer_key
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return
    unless config.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return
    unless config.access_token
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN environment variable."
      return
    unless config.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return


    unless twit
      twit = new Twit config

    if msg.match[1] then username = msg.match[1] else username = msg.message.user.name.toLowerCase()

    twit.get "statuses/user_timeline",
      screen_name: escape(username)
      count: 1
      include_rts: false
      exclude_replies: true
    , (err, reply) ->
      return msg.send "Error: " + username if err
      return msg.send "Tweet by " + username + ": " +_.unescape(_.last(reply)['text']) if reply[0]['text']
