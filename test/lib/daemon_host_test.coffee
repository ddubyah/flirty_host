SandboxedModule = require 'sandboxed-module'


describe "DaemonHost", ->
  beforeEach ->
    @optimistSpy = sinon.spy()
    @flirtySpy = sinon.stub()
    @foreverizeSpy = sinon.spy()
    @listenStub = sinon.stub()
    @listenStub.yields null

    @flirtySpy.returns {
      listen: @listenStub
    }

    fakeForever = _fakeForeverize false
    fakeOptimist = _fakeOptimist()

    @DaemonHost = SandboxedModule.require '../../src/daemon_host', requires:
      './flirty/host': @flirtySpy
      'foreverize': fakeForever
      'optimist': fakeOptimist

  it "should call FlirtyHost", ->
    @DaemonHost.daemonize('./test')
    @flirtySpy.should.have.been.called

  describe "FlirtyHost", ->
    it "should be passed the proper options", ->
      @DaemonHost.daemonize()
      @flirtySpy.should.have.been.calledWithMatch './duff', {
        username: 'bert'
        password: 'earnie'
      }

  describe "The server", ->
    it "should listen on the proper port", ->
      @DaemonHost.daemonize()
      @listenStub.should.have.been.calledWithMatch 3838

_fakeForeverize = (isMaster = false)->
  return ->
    {
      isMaster: false
    }

_fakeOptimist = ->
  {
    alias: ->
      _fakeOptimist()
    default: ->
      _fakeOptimist()
    argv: 
      folder: './duff'
      port: '3838'
      username: 'bert'
      password: 'earnie'
  }
