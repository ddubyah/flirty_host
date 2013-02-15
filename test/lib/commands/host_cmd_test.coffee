prompt = require 'prompt'
child_process = require('child_process')
path = require 'path'

HostCmd = require '../../../src/commands/host_cmd'

describe "Host command", ->
  beforeEach ->
    childSpy = sinon.spy()
    sinon.stub child_process, 'spawn'
    sinon.stub prompt, 'get'

    @hostOptions = {
      folder: path.resolve('./')
      port: '3535'
      username: 'bert'
      password: 'earnie'
    }

    child_process.spawn.returns childSpy
    prompt.get.yields null, @hostOptions

  afterEach ->
    child_process.spawn.restore()
    prompt.get.restore()

  it "should spawn the daemon script", (done)->
    HostCmd @hostOptions, (err)->
      child_process.spawn.should.have.been.calledOnce
      done()

  describe "command line arguments", ->
    beforeEach (done)->
      HostCmd @hostOptions, (err)=>
        @spawnArgs = child_process.spawn.getCall(0).args
        done()

    it "should run the script with coffee", ->
      @spawnArgs[0].should.equal 'coffee'

    it "should pass the script path in the options array", ->
      @spawnArgs[1][0].should.equal require.resolve '../../../src/daemonHost'

    it "should pass options to the child process", ->
      optionIndex = 1
      for k, v of @hostOptions
        @spawnArgs[1][optionIndex].should.equal "--#{k}"
        @spawnArgs[1][optionIndex+1].should.equal v
        optionIndex += 2