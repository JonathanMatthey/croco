{spawn, exec} = require 'child_process'
fs            = require 'fs'
path          = require 'path'

option '-p', '--prefix [DIR]', 'set the installation prefix for `cake install`'
option '-w', '--watch', 'continually build the croco library'
option '-l', '--layout [LAYOUT]', 'specify the layout for Croco\'s docs'

task 'build', 'build the croco library', (options) ->
  coffee = spawn 'coffee', ['-c' + (if options.watch then 'w' else ''), '.']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()
  coffee.stderr.on 'data', (data) -> console.log data.toString().trim()

task 'install', 'install the `croco` command into /usr/local (or --prefix)', (options) ->
  base = options.prefix or '/usr/local'
  lib  = base + '/lib/croco'
  exec([
    'mkdir -p ' + lib
    'cp -rf bin README resources croco.js ' + lib
    'ln -sf ' + lib + '/bin/croco ' + base + '/bin/croco'
  ].join(' && '), (err, stdout, stderr) ->
   if err then console.error stderr
  )

task 'doc', 'rebuild the Croco documentation', (options) ->
  layout = options.layout or 'codeconv'
  exec([
    "bin/croco --layout #{layout} croco.litcoffee"
    "sed \"s/croco.css/resources\\/#{layout}\\/croco.css/\" < docs/croco.html > index.html"
    'rm -r docs'
  ].join(' && '), (err) ->
    throw err if err
  )

task 'loc', 'count the lines of code in Croco', ->
  code = fs.readFileSync('croco.litcoffee').toString()
  lines = code.split('\n').filter (line) -> /^    /.test line
  console.log "Croco LOC: #{lines.length}"
