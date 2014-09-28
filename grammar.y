%lex

%%

[\n\r]+           return 'NEWLINE'
\s+               /* skip whitespace */
'='               return 'EQ'
'|'               return 'PIPE'
'/'               return 'SLASH'
','               return 'COMMA'
'>'               return 'GT'
[0-9]+            return 'NUMBER'
"\"".*"\""        return 'STRING'
\w+               return 'WORD'
<<EOF>>           return 'EOF'

/lex

%start program

%%

program
  : lines {
    return {
      type: 'Program',
      body: $1
    }
  }
  ;

lines
  : line {
    $$ = [$1]
  }
  | lines line {
    $$ = $1.concat($2)
  }
  ;

line
  : statement eol {
    $$ = $1
  }
  ;

eol
  : NEWLINE
  | EOF
  | NEWLINE EOF
  ;

statement
  : expressionStatement
  | variableDeclaration
  | redirectStatement
  ;

redirectStatement
  : expression GT expression {
    $$ = {
      type: 'VariableDeclaration',
      declarations: [{
        type : 'VariableDeclarator',
        id   : $3,
        init : $1
      }],
      kind: 'var'
    }
  }
  ;

variableDeclaration
  : expression EQ expression {
    $$ = {
      type: 'VariableDeclaration',
      declarations: [{
        type : 'VariableDeclarator',
        id   : $1,
        init : $3
      }],
      kind: 'var'
    }
  }
  ;

expressionStatement
  : expression {
    $$ = {
      type: 'ExpressionStatement',
      expression: $1
    }
  }
  ;

expressionList
  : expression {
    $$ = [$1]
  }
  | expressionList COMMA expressionList {
    $$ = $1.concat($3)
  }
  ;

expression
  : literal
  | identifier
  | callExpression
  | pipeExpression
  ;

pipeExpression
  : expression PIPE expression {
    $$ = {
      "type": "CallExpression",
      "callee": {
        "type": "MemberExpression",
        "computed": false,
        "object": $1,
        "property": {
          "type": "Identifier",
          "name": "pipe"
        }
      },
      "arguments": [
        $3
      ]
    }
  }
  ;

callExpression
  : identifier expressionList {
    $$ = {
      type      : 'CallExpression',
      callee    : $1,
      arguments : $2
    }
  }
  ;

literal
  : NUMBER {
    $$ = {
      type  : 'Literal',
      value : $1
    }
  }
  | STRING {
    $$ = {
      type  : 'Literal',
      value : $1.substr(1, $1.length-2),
      raw   : $1
    }
  }
  | repository
  ;

repository
  : WORD SLASH WORD {
    $$ = {
      type: 'Literal',
      value: ($1 + $2 + $3)
    }
  }
  ;

identifier
  : WORD {
    $$ = {
      type: 'Identifier',
      name: $1
    }
  }
  ;
