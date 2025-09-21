angular.module('rmWeeklySchedule', []).directive 'rmWeeklySchedule', [ ->
    restrict: 'E'
    template: '<div class="rmws-hour-labels"></div>
               <div class="rmws-days">
                   <div class="rmws-day"></div>
                   <div class="rmws-day"></div>
                   <div class="rmws-day"></div>
                   <div class="rmws-day"></div>
                   <div class="rmws-day"></div>
                   <div class="rmws-day"></div>
                   <div class="rmws-day"></div>
               </day>'
    link: linkFunc
]

slot_height = null
slots_per_hour = null

move_action =
    e: null
    el: null
    cursor_offset: null

resize_bottom_action =
    e: null
    el: null

resize_top_action =
    e: null
    el: null
    start_offset_bottom: null
    start_height: null

resize_top = (e) ->
    e.preventDefault()

    start = resize_top_action.e.pageY - resize_top_action.el.parent().offset().top
    end = e.pageY - resize_top_action.el.parent().offset().top

    if end >= resize_top_action.start_offset_bottom - resize_top_action.el.parent().offset().top
        return

    offset = Math.floor(end / slot_height) * slot_height

    console.log resize_top_action.start_height, offset

    resize_top_action.el.css
        height: resize_top_action.start_offset_bottom - offset - 50
        top: Math.abs(offset)

    updateTimeLabel(resize_top_action.el)

resize_bottom = (e) ->
    e.preventDefault()

    start = resize_bottom_action.e.pageY
    end = e.pageY

    if end <= resize_bottom_action.el.offset().top
        return

    offset = end - resize_bottom_action.el.offset().top
    height = Math.ceil(offset / slot_height) * slot_height - 1

    console.log start, end, height

    resize_bottom_action.el.css
        height: Math.abs(height)

    updateTimeLabel(resize_bottom_action.el)

move = (e) ->
    if move_action.el and move_action.el isnt $(e.toElement) and not $(e.toElement).hasClass 'rmws-event'
        e.preventDefault()
        move_action.el.appendTo $(e.toElement).parent()

    end = e.pageY - move_action.el.parent().offset().top - move_action.cursor_offset

    offset = Math.floor(end / slot_height) * slot_height

    move_action.el.css
        top: if offset > 0 then offset else 0

    updateTimeLabel(move_action.el)

updateTimeLabel = (el) ->
    hours = el.position().top / (slot_height * slots_per_hour)
    hour = Math.floor(hours)
    minutes = Math.round(60 * (hours - hour))
    minutes = if minutes > 9 then minutes else '0' + minutes

    hours = (el.position().top + el.outerHeight() + 1) / (slot_height * slots_per_hour)
    end_hour = Math.floor(hours)
    end_minutes = Math.round(60 * (hours - end_hour))
    end_minutes = if end_minutes > 9 then end_minutes else '0' + end_minutes

    if not el.find('.rmws-time').length
        el.prepend $('<div></div>', class: 'rmws-time')

    el.find('.rmws-time').text("#{hour}:#{minutes}—#{end_hour}:#{end_minutes}")


linkFunc = (scope, element, attrs) ->
    slots_per_hour = 60 / attrs.interval

    $hour_labels = $ '.rmws-hour-labels'

    for i in [0..23]
      $hour_labels.append $('<div></div>', class: 'rmws-hour-label', text: i + ':00')

    $('.rmws-day').each (i) ->
      $day = $ this

      switch i
        when 0 then dow = 'Monday'
        when 1 then dow = 'Tuesday'
        when 2 then dow = 'Wednesday'
        when 3 then dow = 'Thursday'
        when 4 then dow = 'Friday'
        when 5 then dow = 'Saturday'
        when 6 then dow = 'Sunday'

      $day.append $('<div></div>', class: 'rmws-day-label', text: dow)

      $slots = $('<div></div>', class: 'rmws-slots')

      for i in [1..24*slots_per_hour]
        $slots.append $('<div></div>', class: 'rmws-slot')

      $day.append($slots)

    slot_height = $('.rmws-slot').outerHeight()

    $(".rmws-hour-label").height(slot_height * slots_per_hour)

    $(".rmws-slot:nth-child(#{slots_per_hour}n)").css 'border-bottom', '1px solid #d0d0d0';

    mousedown =
      e: null
      el: null

    $('.rmws-slots').on 'mousedown', (e) ->
      if $(e.toElement).hasClass 'rmws-event'
        return

      mousedown.e = e

    $('.rmws-slots').on 'mousemove', (e) ->
      if mousedown.el or move_action.el or resize_top_action.el or resize_bottom_action.el
        e.preventDefault()

      if resize_bottom_action.e
        resize_bottom(e)
        return

      if resize_top_action.e
        resize_top(e)
        return

      if move_action.e
        move(e)
        return

      if not mousedown.e
        return

      e.preventDefault()

      if not mousedown.el
        mousedown.el = $('<div></div>', class: 'rmws-event', text: '80’s')
        updateTimeLabel(mousedown.el)
        mousedown.el.append $('<div></div>', class: 'rmws-close')
        mousedown.el.append $('<div></div>', class: 'rmws-handle rmws-handle-top')
        mousedown.el.append $('<div></div>', class: 'rmws-handle rmws-handle-bottom')
        mousedown.el.appendTo $(mousedown.e.target).parent()

      if $(e.toElement).hasClass('rmws-event') and e.toElement != mousedown.el[0]
        return

      distance = e.pageY - mousedown.e.pageY

      if distance < 0
        offset = Math.ceil((mousedown.e.pageY - $(this).offset().top + 1) / slot_height) * slot_height + 2
        height = Math.floor(distance / slot_height) * slot_height + 1
      else
        offset = Math.floor((mousedown.e.pageY - $(this).offset().top + 1) / slot_height) * slot_height
        height = Math.ceil(distance / slot_height) * slot_height - 1

      if height <= 0
        offset += height - 3

      mousedown.el.css
        top: offset
        height: Math.abs(height)

      updateTimeLabel(mousedown.el)

    $('body').on 'mouseup', ->
      if mousedown.el?.height() == 0
        mousedown.el.remove()

      resize_bottom_action.el?.css 'cursor', 'default'
      resize_top_action.el?.css 'cursor', 'default'

      mousedown.e = null
      mousedown.el = null

      move_action.e = null
      move_action.el = null

      resize_bottom_action.e = null
      resize_bottom_action.e = null
      resize_top_action.e = null
      resize_top_action.e = null

    $('.rmws-days').on 'mousedown', '.rmws-event', (e) ->
        console.log 'move'
        move_action.e = e
        move_action.el = $ this
        move_action.cursor_offset = e.pageY - move_action.el.offset().top

    $('.rmws-days').on 'mouseup', '.rmws-event', (e) ->
        move_action.e = null
        move_action.el = null

    $('.rmws-days').on 'mousedown', '.rmws-handle-bottom', (e) ->
        e.stopPropagation()
        resize_bottom_action.e = e
        resize_bottom_action.el = $(this).parent()
        resize_bottom_action.el.css 'cursor', 'row-resize'

    $('.rmws-days').on 'mousedown', '.rmws-handle-top', (e) ->
        e.stopPropagation()
        resize_top_action.e = e
        resize_top_action.el = $(this).parent()
        resize_top_action.el.css 'cursor', 'row-resize'
        resize_top_action.start_offset_bottom = $(this).parent().offset().top + $(this).parent().height()
        resize_top_action.start_height = $(this).parent().height()

    $('.rmws-days').on 'click', '.rmws-close', (e) ->
        $(this).parent().remove()