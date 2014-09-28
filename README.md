# datscript

> This is an example of **datscript**,
> a data processing language for moving, manipulating, and organizing data.

**This is just a proof of concept** - *it doesn't function yet*

## run

in `demo.ds`
```
a = clone a/b
b = load "http://google.com"
a | filter "hello"
```

Execute the _datscript_

```bash
$ npm i -g datscript
$ datscript demo.ds
```

## how it all works

1. first, the grammar of the language is described in `grammar.y`
2. the grammar file uses [jison](https://zaach.github.io/jison/),
   which is a JavaScript implementation of [bison](https://www.gnu.org/software/bison/).
3. the grammar file contains both a **lexer** and a **parser**.
4. the parser must emit the [SpiderMonkey Parser API](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API)
   which is fed into [escodegen](https://github.com/Constellation/escodegen)
   to generate valid JavaScript syntax.
5. the resulting script is then fed into the [vm module](http://nodejs.org/api/vm.html)
   and executed in a sandbox with a special set of globals.

## goals

Overall, the goal of *datscript* is to create something people will use.
As such, it should do a good job of meeting the constraints of
non-experts who deal with lots of semi-structured data.

### constraints

- data might be dirty
- data may come from various sources, like spreadsheets, websites, csv files, etc
- people using *datscript* may be non-programmers

## development

1. generate a new `grammar.js` file with `npm run grammar.js`
