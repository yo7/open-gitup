exec = require("child_process").exec
{CompositeDisposable} = require 'atom'

module.exports = OpenGitup =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
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
          exec('gitup', {cwd: path})
