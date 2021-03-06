React = require 'react'
apiClient = require 'panoptes-client/lib/api-client'
talkClient = require 'panoptes-client/lib/talk-client'
{timeAgo} = require './lib/time'
DisplayRoles = require './lib/display-roles'
Avatar = require '../partials/avatar'
{Link} = require 'react-router'
{Markdown} = require 'markdownz'

PAGE_SIZE = require('./config').discussionPageSize

truncate = (string = '', ending = '', length = 80) ->
  return string if string.trim().length <= length
  string.trim().slice(0, (length - ending.length)) + ending

module.exports = React.createClass
  displayName: 'TalkLatestCommentLink'

  propTypes:
    project: React.PropTypes.object
    discussion: React.PropTypes.object
    title: React.PropTypes.bool
    preview: React.PropTypes.bool

  contextTypes:
    geordi: React.PropTypes.object
    router: React.PropTypes.object.isRequired

  getDefaultProps: ->
    title: false
    preview: false

  getInitialState: ->
    commentUser: null
    latestCommentText: ''
    roles: []

  logProfileClick: (profileItem) ->
    @context.geordi?.logEvent
      type: profileItem

  projectPrefix: ->
    if @props.project then 'project-' else ''

  lastPage: ->
    Math.ceil @props.discussion.comments_count / PAGE_SIZE

  componentWillMount: ->
    comment = @props.comment or @props.discussion?.latest_comment
    return unless comment?
    @updateRoles comment
    apiClient.type('users').get(comment.user_id).then (commentUser) =>
      @setState {commentUser}

  componentWillReceiveProps: (newProps) ->
    oldComment = @props.comment or @props.discussion?.latest_comment
    comment = newProps.comment or newProps.discussion?.latest_comment
    return if comment is oldComment or not comment?
    @updateRoles comment
    apiClient.type('users').get(comment.user_id).then (commentUser) =>
      @setState {commentUser}

  componentDidMount: ->
    latestCommentText = @refs?.markdownText?.textContent
    @setState({latestCommentText}) if latestCommentText

  discussionLink: (childtext = '', query = {}, className = '') ->
    if className is "latest-comment-time"
      logClick = @context.geordi?.makeHandler? 'discussion-time'
    locationObject =
      pathname: "/talk/#{@props.discussion.board_id}/#{@props.discussion.id}"
      query: query
    if @props.params?.owner and @props.params?.name
      {owner, name} = @props.params
      locationObject.pathname = "/projects/#{owner}/#{name}" + locationObject.pathname

    <Link className={className} onClick={logClick?.bind(this, childtext)} to={@context.router.createHref(locationObject)}>
      {childtext}
    </Link>

  updateRoles: (comment) ->
    talkClient
      .type 'roles'
      .get
        user_id: comment.user_id
        section: ['zooniverse', comment.section]
        is_shown: true
        page_size: 100
      .then (roles) =>
        @setState {roles}

  render: ->
    {discussion} = @props
    comment = @props.comment or discussion?.latest_comment
    return <div /> unless (discussion and comment)

    linkQuery = if @props.comment
      comment: comment.id
    else
      scrollToLastComment: true, page: @lastPage()

    baseLink = "/"
    if @props.project?
      baseLink += "projects/#{@props.project.slug}/"

    <div className="talk-latest-comment-link">
      <div className="talk-discussion-link">
        <div ref="markdownText" className="hidden-markdown">
          <Markdown content={comment.body} />
        </div>

        {if @state.commentUser?
          <Link className="user-profile-link" to="#{baseLink}users/#{@state.commentUser.login}" onClick={@logProfileClick.bind this, 'view-profile-author'}>
            <Avatar user={@state.commentUser} />{' '}{@state.commentUser.display_name}
          </Link>}

        {' '}
        <DisplayRoles roles={@state.roles} section={comment.section} />

        <span>
          {if discussion.title and @props.title
            @discussionLink(discussion.title, linkQuery)}{' '}
        </span>

        {@discussionLink(timeAgo(comment.created_at), linkQuery, "latest-comment-time")}

        {if @props.preview
          @discussionLink(" #{truncate(@state.latestCommentText, '...')}", linkQuery, "latest-comment-preview-link")}

      </div>
    </div>
