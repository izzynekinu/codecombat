Aether.addGlobal 'Vector', require './world/vector'
Aether.addGlobal '_', _

module.exports.createAetherOptions = (options) ->
  throw new Error 'Specify a function name to create an Aether instance' unless options.functionName
  throw new Error 'Specify a code language to create an Aether instance' unless options.codeLanguage

  aetherOptions =
    functionName: options.functionName
    protectAPI: not options.skipProtectAPI
    includeFlow: Boolean options.includeFlow
    noVariablesInFlow: true
    skipDuplicateUserInfoInFlow: true  # Optimization that won't work if we are stepping with frames
    yieldConditionally: options.functionName is 'plan'
    simpleLoops: true
    globals: ['Vector', '_']
    problems:
      jshint_W040: {level: 'ignore'}
      jshint_W030: {level: 'ignore'}  # aether_NoEffect instead
      jshint_W038: {level: 'ignore'}  # eliminates hoisting problems
      jshint_W091: {level: 'ignore'}  # eliminates more hoisting problems
      jshint_E043: {level: 'ignore'}  # https://github.com/codecombat/codecombat/issues/813 -- since we can't actually tell JSHint to really ignore things
      jshint_Unknown: {level: 'ignore'}  # E043 also triggers Unknown, so ignore that, too
      aether_MissingThis: {level: 'error'}
    problemContext: options.problemContext
    #functionParameters: # TODOOOOO
    executionLimit: 3 * 1000 * 1000
    language: options.codeLanguage
  parameters = functionParameters[options.functionName]
  unless parameters
    console.warn "Unknown method #{options.functionName}: please add function parameters to lib/aether_utils.coffee."
    parameters = []
  if options.functionParameters and not _.isEqual options.functionParameters, parameters
    console.error "Update lib/aether_utils.coffee with the right function parameters for #{options.functionName} (had: #{parameters} but this gave #{options.functionParameters}."
    parameters = options.functionParameters
  aetherOptions.functionParameters = parameters.slice()
  #console.log 'creating aether with options', aetherOptions
  return aetherOptions

# TODO: figure out some way of saving this info dynamically so that we don't have to hard-code it: #1329
functionParameters =
  hear: ['speaker', 'message', 'data']
  makeBid: ['tileGroupLetter']
  findCentroids: ['centroids']
  isFriend: ['name']
  evaluateBoard: ['board', 'player']
  getPossibleMoves: ['board']
  minimax_alphaBeta: ['board', 'player', 'depth', 'alpha', 'beta']
  distanceTo: ['target']

  chooseAction: []
  plan: []
  initializeCentroids: []
  update: []
  getNearestEnemy: []
  die: []
