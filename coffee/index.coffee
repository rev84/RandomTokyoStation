window.stations = []
window.timer = false

$().ready ->
  init()



init = ->
  new Audio('./sound/button55.wav')
  new Audio('./sound/decision24.wav')
  refresh()
  $('#start').on 'click', start
  $('#width, #height').on 'change', refresh
  # サイドバー出し入れボタン
  $('#side_bar_button').on 'click', ->
    switchSideBar()

refresh = ->
  w = Number $('#width').val()
  h = Number $('#height').val()

  window.stations = []
  for wIndex in [0...w]
    window.stations[wIndex] = []
    for hIndex in [0...h]
      window.stations[wIndex][hIndex] = []

  for s in STATIONS
    wIndex = if Math.floor((s.w)*w) is w then w-1 else Math.floor((s.w)*w)
    hIndex = if Math.floor((s.h)*h) is h then h-1 else Math.floor((s.h)*h)
    window.stations[wIndex][hIndex].push s.name


  $('#field').html('')
  table = $('<table>').addClass('board')
  for y in [0...h]
    tr = $('<tr>')
    for x in [0...w]
      tr.append(
        $('<td>').css({
          width  : ''+(100/w)+'%'
          height : ''+(100/h)+'%'
        }).attr('id', 'x'+x+'y'+y)
      )
    table.append tr
  $('#field').append table

start = ->
  ms = Number $('#ms').val()
  window.timer = setInterval(randomPick, ms)
  $('#start').html('ストップ')
  $('#start').off 'click'
  $('#start').on 'click', stop

stop = ->
  unless window.timer is false
    if $('#se').prop('checked')
      audio = new Audio('./sound/decision24.wav')
      audio.volume = 0.5
      audio.play()
    clearInterval window.timer
    window.timer = false
    $('#start').html('スタート')
    $('#start').off 'click'
    $('#start').on 'click', start

randomPick = ->
  $('#field td').html('').removeClass('picked')
  index = Utl.rand(0, STATIONS.length-1)

  one = getOne index
  $('#x'+one.x+'y'+one.y).addClass('picked').append(
    $('<span>').html(one.name)
  )
  if $('#se').prop('checked')
    audio = new Audio('./sound/button55.wav')
    audio.volume = 0.5
    audio.play()

getOne = (index)->
  total = 0
  for x in [0...window.stations.length]
    for y in [0...window.stations[x].length]
      if index < total+window.stations[x][y].length
        return {
          name:window.stations[x][y][index-total]
          x:x
          y:y
        }
      total += window.stations[x][y].length

switchSideBar = ->
  if $('#side_bar').css('display') is 'none'
    $('#side_bar').css('display', 'inline')
    $('#side_bar_button span').removeClass('glyphicon-fullscreen').addClass('glyphicon-remove-circle')
  else
    $('#side_bar').css('display', 'none')
    $('#side_bar_button span').removeClass('glyphicon-remove-circle').addClass('glyphicon-fullscreen')