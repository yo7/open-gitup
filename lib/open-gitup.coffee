exec = require("child_process").exec
path = require('path')
fs = require('fs')
OpenGitupView = require './open-gitup-view'
{CompositeDisposable} = require 'atom'
{GitRepository} = require 'atom'

module.exports = OpenGitup =
  openGitupView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @openGitupView = new OpenGitupView(state.openGitupViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @openGitupView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'open-gitup:open': => @open()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @openGitupView.destroy()

  serialize: ->
    openGitupViewState: @openGitupView.serialize()

  open: ->
    projectPaths = atom.project.getPaths()
    # if projectPaths.length <= 1
    exec('gitup', {cwd: projectPaths[0]})
