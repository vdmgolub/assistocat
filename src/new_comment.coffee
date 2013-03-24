NEW_COMMENT_BUTTONS_ENABLED = true
BUTTONS = {
  "ac-new-comment-button-1": { title: "Looks good", text: "Looks good :+1:" }
}

newCommentForm = $('.js-new-comment-form')

initTargets = ->
  @actions = newCommentForm.find('.form-actions')
  @buttonsArea = @actions[0]
  @closeButton = @actions.find('.js-comment-and-button')[0]
  @commentButton = @actions.find('.primary')[0]
  @commentField = newCommentForm.find('textarea')[0]

addButtons = (div) ->
  $(@buttonsArea).prepend div
  tip = $(@buttonsArea).find('.tip').clone()
  $(@buttonsArea).find('.tip').remove()
  $(@buttonsArea).append tip.css('clear', 'both')

enableCommentButtons = ->
  initTargets()

  observer = new WebKitMutationObserver (mutations) ->
    mutations.forEach (mutation) ->
      do initTargets
      addButtons(@buttonsContainer) if $(@buttonsArea).has(@buttonsContainer).length == 0

  observer.observe @actions[0], childList: true

  comment = (event) =>
    button = BUTTONS[event.data.id]

    if button
      event.preventDefault()
      @commentField.value += button.text
      if button.closable then do @closeButton.click else do @commentButton.click
      $(@commentField).val('')

  createButton = (id, title, text, closable = false) ->
    btn = $.parseHTML("<a href='#' id='#{id}'>#{title}</a>")
    $(btn).addClass("button")
    $(btn).css(margin: '0px 5px 5px 0px')

    $(btn).on("click", { id: $(btn).attr('id') }, comment)

    btn

  insertButtons = (buttons = {}) ->
    @buttonsContainer = document.createElement 'div'
    $(@buttonsContainer).addClass("ac-new-comment-buttons")
    @buttonsContainer.setAttribute 'style', 'float: left; text-align: left; margin-bottom: 10px;'

    for id, button of buttons
      # filter buttons if PR is closed
      $(@buttonsContainer).append createButton(id, button.title, button.text, button.closable)

    addButtons(@buttonsContainer)

  loadData = ->
    insertButtons(BUTTONS)

  do loadData

enableCommentButtons(newCommentForm) if newCommentForm and NEW_COMMENT_BUTTONS_ENABLED
