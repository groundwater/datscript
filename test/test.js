var gen   = require('escodegen').generate
var esp   = require('esprima')
var index = require('../grammar.js')
var test  = require('tape').test

var tests = [
  'B = dathub name/repo',
  'C = github groundwater/demo',
  'A = load "http://google.com"',
  'a | filter',
  'x = a | filter | jump a ',
  'do x, y',
  'do x',
  'a | filter b > out',
  'a.x y',
  'a.x y, y',
]

tests.forEach(function(line){
  test(line, function(t){
    var p = index.parse(line)

    t.ok(p, 'does parse')

    try {
      var g = gen(p)
    } catch(e) {
      console.error(JSON.stringify(p, null, 2))
    }

    t.ok(g, 'does generate')
    t.end()
  })
})
