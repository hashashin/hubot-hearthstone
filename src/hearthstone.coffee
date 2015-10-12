# Description:
#   Returns a Hearthstone cards's stats
#
# Dependencies:
#   None
#
# Commands:
#   hubot hs <Hearthstone card> - Return <Hearthstone card>'s stats: name - mana - race - type - attack/hlth - descr
#   hubot hs more <Hearthstone card> - Return more of the <Hearthstone card>'s stats
#
# Author:
#   sylturner
#

module.exports = (robot) ->

  robot.getByName = (json, name) ->
    json.filter (card) ->
      card.name.toLowerCase() is name.toLowerCase()

  robot.response /hs (more )*(.+)/, (msg) ->
    more = msg.match[1]
    name = msg.match[2]
    additional = more != undefined
    robot.fetchCard msg, name, (card) ->
      robot.sendCard(card, msg, additional)

  robot.fetchCard = (msg, name, callback) ->
    msg.http('http://hearthstonecards.herokuapp.com/hearthstone.json').get() (err, res, body) ->
      data = JSON.parse(body)
      card = robot.getByName(data, name)
      callback(card)

  robot.sendCard = (card, msg, additional) ->
    if card.length > 0
      msg.send "#{card[0].name} - Mana: #{card[0].mana} - Race: #{card[0].race} - Type: #{card[0].type} - Attack/Health: #{card[0].attack}/#{card[0].health} - Descr: #{card[0].descr}"
      if additional
        msg.send "Flavor: #{card[0].flavorText} Rarity: #{card[0].rarity}"
        msg.send "http://hearthstonecards.herokuapp.com/cards/medium/#{card[0].image}.png"
    else
      msg.send "I can't find that card"
