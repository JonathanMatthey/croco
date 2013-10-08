Croco
=====

**Croco** is a code convention documentation generator, written in
[Literate CoffeeScript](http://coffeescript.org/#literate).
It extends croco with specific code convention features.

Good code:
++++ function isthisCode() = { return "?"}

Bad code:
---- function Function-My_name  () = { return "?"}

Croco
=====

**Croco** is a quick-and-dirty documentation generator, written in
[Literate CoffeeScript](http://coffeescript.org/#literate).
It produces an HTML document that displays your comments intermingled with your
code. All prose is passed through
[Markdown](http://daringfireball.net/projects/markdown/syntax), and code is
passed through [Highlight.js](http://highlightjs.org/) syntax highlighting.
This page is the result of running Croco against its own
[source file](https://github.com/jashkenas/croco/blob/master/croco.litcoffee).

1. Install Croco with **npm**: `sudo npm install -g croco`

2. Run it against your code: `croco src/*.coffee`

There is no "Step 3". This will generate an HTML page for each of the named
source files, with a menu linking to the other pages, saving the whole mess
into a `docs` folder (configurable).

The [Croco source](http://github.com/manymengofishing/croco) is available on GitHub,
and is released under the [MIT license](http://opensource.org/licenses/MIT).

Croco can be used to process code written in any programming language. If it
doesn't handle your favorite yet, feel free to
[add it to the list](https://github.com/jashkenas/croco/blob/master/resources/languages.json).
Finally, the ["literate" style](http://coffeescript.org/#literate) of *any*
language is also supported — just tack an `.md` extension on the end:
`.coffee.md`, `.py.md`, and so on.


Main Documentation Generation Functions
---------------------------------------

Generate the documentation for our configured source file by copying over static
assets, reading all the source files in, splitting them up into prose+code
sections, highlighting each file in the appropriate language, and printing them
out in an HTML template.

    document = (options = {}, callback) ->
      config = configure options

      fs.mkdirs config.output, ->

        callback or= (error) -> throw error if error
        copyAsset  = (file, callback) ->
          fs.copy file, path.join(config.output, path.basename(file)), callback
        complete   = ->
          copyAsset config.css, (error) ->
            if error then callback error
            else if fs.existsSync config.public then copyAsset config.public, callback
            else callback()

        files = config.sources.slice()

        nextFile = ->
          source = files.shift()
          fs.readFile source, (error, buffer) ->
            return callback error if error

            code = buffer.toString()
            sections = parse source, code, config
            format source, sections, config
            write source, sections, config
            if files.length then nextFile() else complete()

        nextFile()

Given a string of source code, **parse** out each block of prose and the code that
follows it — by detecting which is which, line by line — and then create an
individual **section** for it. Each section is an object with `docsText` and
`codeText` properties, and eventually `docsHtml` and `codeHtml` as well.

    parse = (source, code, config = {}) ->
      lines    = code.split '\n'
      sections = []
      lang     = getLanguage source, config
      hasCode = docsText = codeText = codeType = prevLineCodeType = ''
      codeBlocks = []

      save = ->
        sections.push {docsText, codeBlocks}
        hasCode = docsText = codeText = ''
        codeBlocks = []

Our quick-and-dirty implementation of the literate programming style. Simply
invert the prose and code relationship on a per-line basis, and then continue as
normal below.

      if lang.literate
        isText = maybeCode = yes
        for line, i in lines
          lines[i] = if maybeCode and match = /^([-]{4}|[+]{4}|[ ]{4})/.exec line
            isText = no
            line
          else if maybeCode = /^\s*$/.test line
            if isText then lang.symbol else ''
          else
            isText = yes
            lang.symbol + ' ' + line

      for line in lines
        if line.match(lang.commentMatcher) and not line.match(lang.commentFilter)
          save() if hasCode
          docsText += (line = line.replace(lang.commentMatcher, '')) + '\n'
          save() if /^(---+|===+)$/.test line
        else
          hasCode = yes

          prevLineCodeType = codeType
          codeType = getCodeLineType line
          
          # empty prevLineCodeType means this is the first line
          if !!prevLineCodeType || ( !!prevLineCodeType && codeType != prevLineCodeType )
            # code type has switched, push that block out
            codeBlocks.push { 'codeType': prevLineCodeType, 'codeText': codeText }
            codeText = line[4..] + '\n'
          else
            codeText += line[4..] + '\n'

          console.log(line)

      save()

      sections

Get code line type, if it is prefixed with ---- it's bad code, ++++ is good code,
and '    ' is normal code

    getCodeLineType = (line) ->
      if /^([-]{4})/.test line
        'bad'
      else if /^([+]{4})/.test line
        'good'
      else
        'normal'

To **format** and highlight the now-parsed sections of code, we use **Highlight.js**
over stdio, and run the text of their corresponding comments through
**Markdown**, using [Marked](https://github.com/chjj/marked).

    format = (source, sections, config) ->
      language = getLanguage source, config
      codeText = ''

Tell Marked how to highlight code blocks within comments, treating that code
as either the language specified in the code block or the language of the file
if not specified.

      marked.setOptions {
        highlight: (code, lang) ->
          lang or= language.name

          if highlightjs.LANGUAGES[lang]
            highlightjs.highlight(lang, code).value
          else
            console.warn "croco: couldn't highlight code block with unknown language '#{lang}' in #{source}"
            code
      }

      for section, i in sections
        section.codeHtml = ''
        for codeBlock, j in section.codeBlocks
          codeText = highlightjs.highlight(language.name, codeBlock.codeText).value
          codeText = codeText.replace(/\s+$/, '')
          section.codeHtml += "<div class='highlight #{codeBlock.codeType}'><pre>#{codeText}</pre></div>"
        section.docsHtml = marked(section.docsText)

Once all of the code has finished highlighting, we can **write** the resulting
documentation file by passing the completed HTML sections into the template,
and rendering it to the specified output path.

    write = (source, sections, config) ->

      destination = (file) ->
        path.join(config.output, path.basename(file, path.extname(file)) + '.html')

The **title** of the file is either the first heading in the prose, or the
name of the source file.

      first = marked.lexer(sections[0].docsText)[0]
      hasTitle = first and first.type is 'heading' and first.depth is 1
      title = if hasTitle then first.text else path.basename source

      html = config.template {sources: config.sources, css: path.basename(config.css),
        title, hasTitle, sections, path, destination,}

      console.log "croco: #{source} -> #{destination source}"
      fs.writeFileSync destination(source), html


Configuration
-------------

Default configuration **options**. All of these may be extended by
user-specified options.

    defaults =
      layout:     'codeconv'
      output:     'docs'
      template:   null
      css:        null
      extension:  null
      languages:  {".js":{"name": "javascript", "symbol": "//"}}
      newProjectFiles:   ['airbnb.js.md','nytimes.js.md','javascript.js.md']

**Configure** this particular run of Croco. We might use a passed-in external
template, or one of the built-in **layouts**. We only attempt to process
source files for languages for which we have definitions.

    configure = (options) ->
      config = _.extend {}, defaults, _.pick(options, _.keys(defaults)...)

      config.languages = buildMatchers config.languages
      if options.template
        config.layout = null
      else
        dir = config.layout = path.join __dirname, 'resources', config.layout
        config.samplesDir   = path.join __dirname, 'resources', 'samples' 
        config.public       = path.join dir, 'public' if fs.existsSync path.join dir, 'public'
        config.template     = path.join dir, 'croco.jst'
        config.css          = options.css or path.join dir, 'croco.css'
      config.template = _.template fs.readFileSync(config.template).toString()

      if options.args
        config.sources = [options.args[0]]
        #.filter((source) ->
        #  lang = getLanguage source, config
        #  console.warn "croco: skipped unknown type (#{path.basename source})" unless lang
        #  lang
        #).sort()

      config


Helpers & Initial Setup
-----------------------

Require our external dependencies.

    _           = require 'underscore'
    fs          = require 'fs-extra'
    path        = require 'path'
    marked      = require 'marked'
    commander   = require 'commander'
    highlightjs = require 'highlight.js'

Enable nicer typography with marked.

    marked.setOptions smartypants: yes

Languages are stored in JSON in the file `resources/languages.json`.
Each item maps the file extension to the name of the language and the
`symbol` that indicates a line comment. To add support for a new programming
language to Croco, just add it to the file.

    languages = JSON.parse fs.readFileSync(path.join(__dirname, 'resources', 'languages.json'))

Build out the appropriate matchers and delimiters for each language.

    buildMatchers = (languages) ->
      for ext, l of languages

Does the line begin with a comment?

        l.commentMatcher = ///^\s*#{l.symbol}\s?///

Ignore [hashbangs](http://en.wikipedia.org/wiki/Shebang_%28Unix%29) and interpolations...

        l.commentFilter = /(^#![/]|^\s*#\{)/
      languages
    languages = buildMatchers languages

A function to get the current language we're documenting, based on the
file extension. Detect and tag "literate" `.ext.md` variants.

    getLanguage = (source, config) ->
      ext  = config.extension or path.extname(source) or path.basename(source)
      lang = config.languages[ext] or languages[ext]
      if lang and lang.name is 'markdown'
        codeExt = path.extname(path.basename(source, ext))
        if codeExt and codeLang = languages[codeExt]
          lang = _.extend {}, codeLang, {literate: yes}
      lang

Keep it DRY. Extract the croco **version** from `package.json`

    version = JSON.parse(fs.readFileSync(path.join(__dirname, 'package.json'))).version

Creates the bare coding convention project which consist of 
folder structures and example files

Copy all sample files in base dir 
- can you read the dir ? 

    createNewProject = (options = {}) ->
      config = configure options
      config.output = '.'

      files = config.newProjectFiles.slice()

      for file in files
        fs.copy path.join(config.samplesDir, file), path.join(config.output, path.basename(file))


Command Line Interface
----------------------

Finally, let's define the interface to run Croco from the command line.
Parse options using [Commander](https://github.com/visionmedia/commander.js).

    run = (args = process.argv) ->
      c = defaults
      commander.version(version)
        .usage('[options] command')
        #.option('-L, --languages [file]', 'use a custom languages.json', _.compose JSON.parse, fs.readFileSync)
        .option('-l, --layout [name]',    'choose a layout (codeconv, ... )', c.layout)
        .option('-o, --output [path]',    'output to a given folder', c.output)
        #.option('-c, --css [file]',       'use a custom css file', c.css)
        #.option('-t, --template [file]',  'use a custom .jst template', c.template)
        #.option('-e, --extension [ext]',  'assume a file extension for all inputs', c.extension)
        .parse(args)
        .name = "croco"

      commander
        .command('new')
        .description('creates a new coding convention project')
        .action ()->
          createNewProject()

      commander
        .command('generate')
        .description('run remote setup commands')
        .action ()->
          document commander

      if commander.args.length == 0
        console.log commander.helpInformation()
      else
        commander.parse args
      #else
      #  document commander


Public API
----------

    Croco = module.exports = {run, document, createNewProject, parse, format, version}
