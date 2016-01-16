exec = require("child_process").exec
{CompositeDisposable} = require 'atom'

module.exports = OpenGitup =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'open-gitup:open': => @open()

  deactivate: ->
    @subscriptions.dispose()

  open: ->
    if editor = atom.workspace.getActiveTextEditor()
      filePath = editor.getPath()
      projectPaths = atom.project.getPaths()

      for path in projectPaths
        rPath = new RegExp(path, 'g')
        if !filePath || !projectPaths
          atom.notifications.addError('No repository found')
        else if filePath.match(rPath)
          exec("open -a GitUp.app '#{path}'")
