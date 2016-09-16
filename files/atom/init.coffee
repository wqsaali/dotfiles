# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"
atom.packages.onDidActivatePackage (pack) ->
  if pack.name == 'ex-mode'
    editor = atom.workspace.getActiveTextEditor()
    Ex = pack.mainModule.provideEx()
    Ex.registerCommand 'term', -> atom.commands.dispatch(atom.views.getView(editor), 'termrk:toggle')

aliasCommand = atom.packages.getLoadedPackage('alias-command').requireMainModule()
aliasCommand 'w',
  orig: 'core:save'
aliasCommand 'wall',
  orig: 'window:save-all'
aliasCommand 'q',
  orig: 'core:close'
aliasCommand 'wq',
  orig: ['core:save', 'core:close']
aliasCommand 'wqall',
  orig: ['core:save', 'window:close']
aliasCommand 'qall',
  orig: 'window:close'
aliasCommand ':',
  orig: 'go-to-line:toggle'
aliasCommand '%',
  orig: 'find-and-replace:show'
aliasCommand 'split',
  orig: 'pane:split-down'
aliasCommand 'vsplit',
  orig: 'pane:split-left'
aliasCommand 'diffthis',
  orig: 'split-diff:toggle'
aliasCommand 'git-blame',
  orig: 'blame:toggle'
