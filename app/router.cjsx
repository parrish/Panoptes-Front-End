Router = {IndexRoute, IndexRedirect, Route, Redirect} = require 'react-router'
React = require 'react'

`import ProjectsPage from './pages/projects/index';`
`import FilteredProjectsList from './pages/projects/filtered-projects-list';`
`import CollectionPageWrapper from './collections/show';`
`import ProjectHomePage from './pages/project/home';`
`import AboutProject from './pages/project/about/index';`
`import { AboutProjectResearch, AboutProjectEducation, AboutProjectFAQ, AboutProjectResults } from './pages/project/about/simple-pages';`
`import AboutProjectTeam from './pages/project/about/team';`
`import UserSettingsList from './pages/admin/user-settings-list';`
`import ProjectStatusList from './pages/admin/project-status-list';`
`import ProjectStatus from './pages/admin/project-status';`
`import EditMediaPage from './pages/lab/media';`
`import UserProfilePage from './pages/profile/index';`
`import NotificationsPage from './pages/notifications';`

# <Redirect from="home" to="/" /> doesn't work.
ONE_UP_REDIRECT = React.createClass
  componentDidMount: ->
    givenPathSegments = @props.location.pathname.split '/'
    givenPathSegments.pop()
    pathOneLevelUp = givenPathSegments.join '/'
    @props.history.replace
      pathname: pathOneLevelUp,
      query: @props.location.query

  render: ->
    null

module.exports =
  <Route path="/" component={require './partials/app'}>
    <IndexRoute component={require './pages/home'} />
    <Route path="home" component={ONE_UP_REDIRECT} />
    <Route path="home-for-user" component={require('./pages/home-for-user').default} />

    <Route path="about" component={require './pages/about'} ignoreScrollBehavior>
      <IndexRoute component={require './pages/about/about-home'} />
      <Route path="team" component={require './pages/about/team-page'} />
      <Route path="publications" component={require './pages/about/publications-page'} />
      <Route path="acknowledgements" component={require './pages/about/acknowledgements'} />
      <Route path="contact" component={require './pages/about/contact-page'} />
    </Route>

    <Route path="get-involved" component={require './pages/get-involved'} ignoreScrollBehavior>
      <IndexRoute component={require './pages/get-involved/volunteering-page'} />
      <Route path="education" component={require './pages/get-involved/education'} />
      <Route path="call-for-projects" component={require './pages/get-involved/call-for-projects'} />
      <Redirect from="callForProjects" to="call-for-projects" />
    </Route>

    <Route path="reset-password" component={require './pages/reset-password'} />

    <Route path="unsubscribe" component={require './pages/unsubscribe'} />

    <Route path="accounts" component={require './pages/sign-in'}>
      <Route path="sign-in" component={require './partials/sign-in-form'} />
      <Route path="register" component={require './partials/register-form'} />
    </Route>
    <Route path="privacy" component={require './pages/privacy-policy'} />
    <Route path="security" component={require './pages/security'} />

    <Route path="users/:profile_name" component={UserProfilePage}>
      <IndexRoute component={require './pages/profile/feed'} />
      <Route path="favorites" component={require('./pages/collections/favorites-list')} />
      <Route path="collections" component={require('./pages/collections/collections-list')} />
      <Route path="message" component={require './pages/profile/private-message'} />
      <Route path="stats" component={require './pages/profile/stats'} />
    </Route>

    <Route path="inbox" component={require './talk/inbox'} />
    <Route path="inbox/:conversation" component={require './talk/inbox-conversation'} />

    <Route path="settings" component={require './pages/settings'}>
      <IndexRoute component={require './pages/settings/account'} />
      <Route path="profile" component={require './pages/settings/profile' } />
      <Route path="email" component={require './pages/settings/email' } />
    </Route>

    <Route path="help" component={require './pages/lab/help'}>
      <IndexRoute component={require './pages/lab/help/how-to-page'} />
      <Route path="glossary" component={require './pages/lab/help/glossary'} />
      <Route path="lab-policies" component={require './pages/lab/help/lab-policies'} />
      <Route path="best-practices" component={require './pages/lab/best-practices'} />
    </Route>

    <Route path="projects" component={ProjectsPage}>
      <IndexRoute component={FilteredProjectsList} />
    </Route>

    <Route path="projects/:owner/:name" component={require './pages/project'}>
      <IndexRoute component={ProjectHomePage} />
      <Route path="home" component={ONE_UP_REDIRECT} />
      <Route path="classify" component={require './pages/project/classify'} />
      <Redirect from="research" to="about/research"/>
      <Redirect from="results" to="about/results"/>
      <Redirect from="faq" to="about/faq"/>
      <Redirect from="education" to="about/education"/>
      <Route path="about" component={AboutProject}>
        <IndexRedirect to="research" />
        <Route path="research" component={AboutProjectResearch} />
        <Route path="results" component={AboutProjectResults} />
        <Route path="faq" component={AboutProjectFAQ} />
        <Route path="education" component={AboutProjectEducation} />
        <Route path="team" component={AboutProjectTeam} />
      </Route>
      <Route path="notifications" component={NotificationsPage} />
      <Route path="talk" component={require './pages/project/talk'}>
        <IndexRoute component={require './talk/init'} />
        <Route path="recents" component={require './talk/recents'} />
        <Route path="not-found" component={require './pages/not-found'} />
        <Route path="search" component={require './talk/search'} />
        <Route path="moderations" component={require './talk/moderations'} />
        <Route path="subjects/:id" component={require './subjects'} />
        <Route path="recents/:board" component={require './talk/recents'} />
        <Route path="tags/:tag" component={require './talk/tags'} />
        <Route path=":board" component={require './talk/board'} />
        <Route path=":board/:discussion" component={require './talk/discussion'} />
      </Route>
      <Route path="stats" component={require './pages/project/stats'} />
      <Route path="favorites" component={require('./pages/collections/index')}>
        <IndexRoute component={require('./pages/collections/favorites-list')} />
        <Route path=":collection_owner" component={require('./pages/collections/favorites-list')} />
      </Route>

      <Route path="collections" component={require('./pages/collections/index')}>
         <IndexRoute component={require('./pages/collections/collections-list')} />
         <Route path=":collection_owner" component={require('./pages/collections/collections-list')} />
      </Route>

      <Route path="collections/:collection_owner/:collection_name" component={CollectionPageWrapper}>
        <IndexRoute component={require './collections/show-list'} />
        <Route path="settings" component={require './collections/settings'} />
        <Route path="collaborators" component={require './collections/collaborators'} />
        <Route path="talk" component={require './collections/show-list'} />
      </Route>
      <Route path="users/:profile_name" component={UserProfilePage}>
        <IndexRoute component={require './pages/profile/feed'} />
        <Route path="favorites" component={require('./pages/collections/favorites-list')} />
        <Route path="collections" component={require('./pages/collections/collections-list')} />
        <Route path="message" component={require './pages/profile/private-message'} />
      </Route>
    </Route>

    <Route path="notifications" component={NotificationsPage} />
    <Route path=":section/notifications" component={NotificationsPage} />

    <Route path="talk" component={require './talk'}>
      <IndexRoute component={require './talk/init'} />
      <Route path="recents" component={require './talk/recents'} />
      <Route path="not-found" component={require './pages/not-found'} />
      <Route path="search" component={require './talk/search'} />
      <Route path="moderations" component={require './talk/moderations'} />
      <Route path=":board" component={require './talk/board'} />
      <Route path="recents/:board" component={require './talk/recents'} />
      <Route name="talk-discussion" path=":board/:discussion" component={require './talk/discussion'} />
    </Route>

    <Route path="favorites" component={require('./pages/collections')}>
      <IndexRoute component={require('./pages/collections/favorites-list')} />
      <Route path=":collection_owner" component={require('./pages/collections/favorites-list')} />
    </Route>

    <Route path="collections" component={require('./pages/collections')}>
       <IndexRoute component={require('./pages/collections/collections-list')} />
       <Route path=":collection_owner" component={require('./pages/collections/collections-list')} />
    </Route>

    <Route path="collections/:collection_owner/:collection_name" component={CollectionPageWrapper}>
      <IndexRoute component={require './collections/show-list'} />
      <Route path="settings" component={require './collections/settings'} />
      <Route path="collaborators" component={require './collections/collaborators'} />
      <Route path="talk" component={require './collections/show-list'} />
    </Route>

    <Route path="lab" component={require './pages/lab'} />
    <Route path="lab/:projectID" component={require './pages/lab/project'}>
      <IndexRoute component={require './pages/lab/project-details'} />
      <Route path="about" component={require './pages/lab/about'}>
        <IndexRedirect to='research' />
        <Route path="research" component={require './pages/lab/about/research'} />
        <Route path="results" component={require './pages/lab/about/results'} />
        <Route path="faq" component={require './pages/lab/about/faq'} />
        <Route path="education" component={require './pages/lab/about/education'} />
        <Route path="team" component={require './pages/lab/about/team'} />
      </Route>
      <Route path="collaborators" component={require './pages/lab/collaborators'} />
      <Route path="media" component={EditMediaPage} />
      <Route path="workflow/:workflowID" component={require './pages/lab/workflow'} />
      <Route path="workflow/:workflowID/visualize" component={require './pages/lab/workflow-viewer'} />
      <Route path="workflow/:workflowID/visualise" component={require './pages/lab/workflow-viewer'} />
      <Route path="subject-set/:subjectSetID" component={require './pages/lab/subject-set'} />
      <Route path="visibility" component={require './pages/lab/visibility'} />
      <Route path="talk" component={require './pages/lab/talk'} />
      <Route path="data-exports" component={require './pages/lab/data-dumps'} />
      <Route path="tutorial" component={require './pages/lab/tutorial'} />
      <Route path="guide" component={require './pages/lab/field-guide'} />
      <Route path="mini-course" component={require './pages/lab/mini-course'} />
    </Route>
    <Route path="lab-policies" component={require './pages/lab/help/lab-policies'} />
    <Route path="lab-how-to" component={require './pages/lab/help'} />
    <Route path="glossary" component={require './pages/lab/help/glossary'} />

    <Route path="lab-best-practices" component={require './pages/lab/best-practices'}>
      <IndexRedirect to="introduction" />
      <Route path="introduction" component={require './pages/lab/best-practices/introduction'} />
      <Route path="great-project" component={require './pages/lab/best-practices/great-project'} />
      <Route path="launch-rush" component={require './pages/lab/best-practices/launch-rush'} />
      <Route path="the-long-haul" component={require './pages/lab/best-practices/the-long-haul'} />
      <Route path="resources" component={require './pages/lab/best-practices/resources'} />
    </Route>

    <Route path="admin" component={require './pages/admin'}>
      <IndexRoute component={UserSettingsList} />
      <Route path="project_status" component={ProjectStatusList} />
      <Route path="project_status/:owner/:name" component={ProjectStatus} />
    </Route>

    <Route path="todo" component={-> <div className="content-container"><i className="fa fa-cogs"></i> TODO</div>} />
    <Route path="dev/workflow-tasks-editor" component={require './components/workflow-tasks-editor'} />
    <Route path="dev/classifier" component={
      if process.env.NODE_ENV is 'production'
        require './pages/not-found'
      else
        require './pages/dev-classifier'
    } />
    <Route path="*" component={require './pages/not-found'} />
  </Route>
