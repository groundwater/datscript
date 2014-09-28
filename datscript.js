var vm = require('vm')

var grammar = require('./grammar.js')
var codegen = require('escodegen')

var environment = {}

function Stream(){

}

Stream.prototype.pipe = function(){}

environment.clone = function(){
  console.log('clone', arguments)

  return new Stream
}

environment.filter = function(){
  console.log('filter', arguments)
}

environment.load = function(){
  console.log('load', arguments)

  return new Stream
}

var context = vm.createContext(environment)

module.exports = function(script){
  var code = codegen.generate(grammar.parse(script))

  console.error(code)

  return vm.runInContext(code, context)
}
