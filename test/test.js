var gen   = require('escodegen').generate
var esp   = require('esprima')
var index = require('../grammar.js')
var test  = require('tape').test

var tests = [
  'B = clone name/repo',
  'A = load "http://google.com"',
  'a | filter',
]

tests.forEach(function(line){
  test(line, function(t){
    var p = index.parse(line)

    console.error(JSON.stringify(p, null, 2))

    t.ok(p, 'does parse')
    var g = gen(p)

    console.error(g)

    t.ok(g, 'does generate')
    t.end()
  })
})
