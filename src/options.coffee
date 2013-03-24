NEW_COMMENT_SETTING = "assistocat.newCommentButtons"

loadOptions = ->
  @newCommentOptions = $('#new-comment-options')[0]

  chrome.storage.sync.get NEW_COMMENT_SETTING, (data) ->
    buttons = data[NEW_COMMENT_SETTING]
    loadNewCommentButtons(buttons)

loadNewCommentButtons = (buttons = {}) ->
  for id, button of buttons
    addNewCommentButton button['title'], button['text'], button['closable']

addNewCommentButton = (title = "", text = "", closable = false) ->
  commentButton = $.parseHTML('<div class="new-comment-button"></div>')

  field = $.parseHTML('<div class="field"></div>')
  $(field).append $.parseHTML(
    """
      <label>Title:</label>
      <input class="title" value="#{title}">
    """
  )
  $(commentButton).append field

  field = $.parseHTML('<div class="field"></div>')
  $(field).append $.parseHTML(
    """
      <label>Text:</label>
      <textarea class="text">#{text}</textarea>
    """
  )
  $(commentButton).append field

  field = $.parseHTML('<div class="field"></div>')
  checkedAttr = if closable then "checked" else ""
  $(field).append $.parseHTML(
    """
      <label>Close Issue/Pull Request?
        <input class="closable" type="checkbox" #{checkedAttr}>
      </label>
    """
  )
  $(commentButton).append field

  field = $.parseHTML('<div class="field"></div>')
  $(field).append $.parseHTML("<a href='#' class='delete-button'>remove</a>")
  $(commentButton).append field

  field = $.parseHTML('<div class="line-separator"></div>')
  $(commentButton).append field

  $(@newCommentOptions).append commentButton

getNewCommentOptions = ->
  buttons = {}
  nodes = $('.new-comment-button')
  for node, i in nodes
    title = $(node).find(".title").val()
    text = $(node).find(".text").val()
    closable = $(node).find(".closable").prop('checked')

    b = {title: title, text: text, closable: closable}
    buttons["ac-new-comment-button-#{i}"] = b

  buttons

saveOptions = ->
  options = {}
  options[NEW_COMMENT_SETTING] = getNewCommentOptions()
  chrome.storage.sync.set(options, message)

message = ->
  $('.ac-message').slideDown(
    -> setTimeout (-> $('.ac-message').slideUp()), 3000
  )

$ ->
  loadOptions()

  $("#add-new-comment-button").click ->
    addNewCommentButton()

  $("#save-options").click ->
    saveOptions()

  $(document).on 'click', '.delete-button', ->
    $(this).parent().parent().remove()
    false
