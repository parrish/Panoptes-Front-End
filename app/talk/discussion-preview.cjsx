React = require 'react'
{Link} = require 'react-router'
resourceCount = require './lib/resource-count'
LatestCommentLink = require './latest-comment-link'
apiClient = require 'panoptes-client/lib/api-client'
getSubjectLocation = require '../lib/get-subject-location'

`import Thumbnail from '../components/thumbnail';`

module.exports = React.createClass
  displayName: 'TalkDiscussionPreview'

  propTypes:
    discussion: React.PropTypes.object

  contextTypes:
    geordi: React.PropTypes.object

  getInitialState: ->
    subject: null

  componentDidMount: ->
    @updateSubject @props.discussion

  componentWillReceiveProps: (newProps) ->
    @updateSubject newProps.discussion if newProps.discussion isnt @props.discussion

  updateSubject: (discussion)->
    if discussion.focus_id and discussion.focus_type is 'Subject'
      apiClient.type 'subjects'
        .get discussion.focus_id
        .then (subject) =>
          @setState {subject}

  logDiscussionClick: ->
    @context.geordi?.logEvent
      type: "view-discussion"

  discussionLink: ->
    {discussion} = @props

    if (@props.params?.owner and @props.params?.name) # get from url if possible
      {owner, name} = @props.params
      "/projects/#{owner}/#{name}/talk/#{discussion.board_id}/#{discussion.id}"

    else if @props.project # otherwise fetch from project
      [owner, name] = @props.project.slug.split('/')
      "/projects/#{owner}/#{name}/talk/#{discussion.board_id}/#{discussion.id}"

    else # link to zooniverse main talk
      "/talk/#{discussion.board_id}/#{discussion.id}"

  render: ->
    {params, discussion} = @props
    comment = @props.comment or discussion.latest_comment

    <div className="talk-discussion-preview">
      <div className="preview-content">

        {if @state.subject?
          subject = getSubjectLocation(@state.subject)
          <div className="subject-preview">
            <Link to={@discussionLink()} onClick={@logDiscussionClick.bind null, this}>
              <Thumbnail src={subject.src} format={subject.format} width={100} height={150} controls={false} />
            </Link>
          </div>
        }

        <h1>
          {<i className="fa fa-thumb-tack talk-sticky-pin"></i> if discussion.sticky}
          <Link to={@discussionLink()} onClick={@logDiscussionClick.bind null, this}>
            {discussion.title}
          </Link>
        </h1>

        <LatestCommentLink {...@props} project={@props.project} discussion={discussion} comment={@props.comment} preview={true} />

      </div>
      <div className="preview-stats">
        <p>
          <i className="fa fa-user"></i> {resourceCount(discussion.users_count, "Participants")}
        </p>
        <p>
          <i className="fa fa-comment"></i> {resourceCount(discussion.comments_count, "Comments")}
        </p>
      </div>
    </div>
