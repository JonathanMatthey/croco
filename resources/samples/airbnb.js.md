Airbnb JavaScript Style Guide() {
=========================

*A mostly reasonable approach to JavaScript*

## <a name='TOC'>Table of Contents</a>
----


  1. [Types](#types)
  1. [Objects](#objects)
  1. [Arrays](#arrays)
  1. [Strings](#strings)
  1. [Functions](#functions)
  1. [Properties](#properties)
  1. [Variables](#variables)
  1. [Hoisting](#hoisting)
  1. [Conditional Expressions & Equality](#conditionals)
  1. [Blocks](#blocks)
  1. [Comments](#comments)
  1. [Whitespace](#whitespace)
  1. [Commas](#commas)
  1. [Semicolons](#semicolons)
  1. [Type Casting & Coercion](#type-coercion)
  1. [Naming Conventions](#naming-conventions)
  1. [Accessors](#accessors)
  1. [Constructors](#constructors)
  1. [Events](#events)
  1. [Modules](#modules)
  1. [jQuery](#jquery)
  1. [ES5 Compatibility](#es5)
  1. [Testing](#testing)
  1. [Performance](#performance)
  1. [Resources](#resources)
  1. [In the Wild](#in-the-wild)
  1. [Translation](#translation)
  1. [The JavaScript Style Guide Guide](#guide-guide)
  1. [Contributors](#contributors)
  1. [License](#license)


## <a name='types'>Types</a>
----

**Primitives**: When you access a primitive type you work directly on its value

+ `string`
+ `number`
+ `boolean`
+ `null`
+ `undefined`

++++ var foo = 1,
++++     bar = foo;
++++
++++ bar = 9;
++++
++++ console.log(foo, bar); // => 1, 9

**Complex**: When you access a complex type you work on a reference to its value

+ `object`
+ `array`
+ `function`

++++ var foo = [1, 2],
++++     bar = foo;
++++
++++ bar[0] = 9;
++++
++++ console.log(foo[0], bar[0]); // => 9, 9

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='objects'>Objects</a>
----

Use the literal syntax for object creation.

---- var item = new Object();

++++ var item = {};

Don't use [reserved words](http://es5.github.io/#x7.6.1) as keys. It won't work in IE8. [More info](https://github.com/airbnb/javascript/issues/61)

---- var superman = {
----   default: { clark: 'kent' },
----   private: true
---- };

++++ var superman = {
++++   defaults: { clark: 'kent' },
++++   hidden: true
++++ };

Use readable synonyms in place of reserved words.

---- var superman = {
----   class: 'alien'
---- };

---- var superman = {
----   klass: 'alien'
---- };

++++ var superman = {
++++   type: 'alien'
++++ };

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='arrays'>Arrays</a>
----

Use the literal syntax for array creation

---- var items = new Array();

++++ var items = [];

If you don't know array length use Array#push.

    var someStack = [];


---- someStack[someStack.length] = 'abracadabra';

++++ someStack.push('abracadabra');

When you need to copy an array use Array#slice. [jsPerf](http://jsperf.com/converting-arguments-to-an-array/7)

    var len = items.length,
        itemsCopy = [],
        i;

---- for (i = 0; i < len; i++) {
----   itemsCopy[i] = items[i];
---- }

++++ itemsCopy = items.slice();

To convert an array-like object to an array, use Array#slice.

    function trigger() {
      var args = Array.prototype.slice.call(arguments);
      ...
    }
----


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='strings'>Strings</a>
----

Use single quotes `''` for strings

---- var name = "Bob Parr";

++++ var name = 'Bob Parr';

---- var fullName = "Bob " + this.lastName;

++++ var fullName = 'Bob ' + this.lastName;

Strings longer than 80 characters should be written across multiple lines using string concatenation.
Note: If overused, long strings with concatenation could impact performance. [jsPerf](http://jsperf.com/ya-string-concat) & [Discussion](https://github.com/airbnb/javascript/issues/40)

---- var errorMessage = 'This is a super long error that was thrown because of Batman. When you stop to think about how Batman had anything to do with this, you would get nowhere fast.';

---- var errorMessage = 'This is a super long error that \
---- was thrown because of Batman. \
---- When you stop to think about \
---- how Batman had anything to do \
---- with this, you would get nowhere \
---- fast.';


++++ var errorMessage = 'This is a super long error that ' +
++++   'was thrown because of Batman.' +
++++   'When you stop to think about ' +
++++   'how Batman had anything to do ' +
++++   'with this, you would get nowhere ' +
++++   'fast.';

When programatically building up a string, use Array#join instead of string concatenation. Mostly for IE: [jsPerf](http://jsperf.com/string-vs-array-concat/2).

    var items,
        messages,
        length, i;

    messages = [{
        state: 'success',
        message: 'This one worked.'
    },{
        state: 'success',
        message: 'This one worked as well.'
    },{
        state: 'error',
        message: 'This one did not work.'
    }];

    length = messages.length;

---- function inbox(messages) {
----   items = '<ul>';
----
----   for (i = 0; i < length; i++) {
----     items += '<li>' + messages[i].message + '</li>';
----   }
----
----   return items + '</ul>';
---- }

++++ function inbox(messages) {
++++   items = [];
++++
++++   for (i = 0; i < length; i++) {
++++     items[i] = messages[i].message;
++++   }
++++
++++   return '<ul><li>' + items.join('</li><li>') + '</li></ul>';
++++ }


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='functions'>Functions</a>
----

Function expressions:

    // anonymous function expression
    var anonymous = function() {
      return true;
    };

    // named function expression
    var named = function named() {
      return true;
    };

    // immediately-invoked function expression (IIFE)
    (function() {
      console.log('Welcome to the Internet. Please follow me.');
    })();

Never declare a function in a non-function block (if, while, etc). Assign the function to a variable instead. Browsers will allow you to do it, but they all interpret it differently, which is bad news bears.
**Note:** ECMA-262 defines a `block` as a list of statements. A function declaration is not a statement. [Read ECMA-262's note on this issue](http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf#page=97).

---- if (currentUser) {
----   function test() {
----     console.log('Nope.');
----   }
---- }

++++ if (currentUser) {
++++   var test = function test() {
++++     console.log('Yup.');
++++   };
++++ }

Never name a parameter `arguments`, this will take precedence over the `arguments` object that is given to every function scope.

---- function nope(name, options, arguments) {
----   // ...stuff...
---- }

++++ function yup(name, options, args) {
++++   // ...stuff...
++++ }



**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='properties'>Properties</a>
----

Use dot notation when accessing properties.

    var luke = {
      jedi: true,
      age: 28
    };

---- var isJedi = luke['jedi'];

++++ var isJedi = luke.jedi;

Use subscript notation `[]` when accessing properties with a variable.

    var luke = {
      jedi: true,
      age: 28
    };

    function getProp(prop) {
      return luke[prop];
    }

    var isJedi = getProp('jedi');


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='variables'>Variables</a>
----

Always use `var` to declare variables. Not doing so will result in global variables. We want to avoid polluting the global namespace. Captain Planet warned us of that.

---- superPower = new SuperPower();

++++ var superPower = new SuperPower();

Use one `var` declaration for multiple variables and declare each variable on a newline.

---- var items = getItems();
---- var goSportsTeam = true;
---- var dragonball = 'z';

++++ var items = getItems(),
++++   goSportsTeam = true,
++++   dragonball = 'z';

Declare unassigned variables last. This is helpful when later on you might need to assign a variable depending on one of the previous assigned variables.

---- var i, len, dragonball,
----    items = getItems(),
----    goSportsTeam = true;

---- var i, items = getItems(),
----     dragonball,
----     goSportsTeam = true,
----     len;

++++ var items = getItems(),
++++     goSportsTeam = true,
++++     dragonball,
++++     length,
++++     i;

Assign variables at the top of their scope. This helps avoid issues with variable declaration and assignment hoisting related issues.

---- function() {
---- test();
---- console.log('doing stuff..');
----
---- //..other stuff..
----
---- var name = getName();
----
---- if (name === 'test') {
----   return false;
---- }
----
---- return name;

++++ function() {
++++   var name = getName();
++++
++++   test();
++++   console.log('doing stuff..');
++++
++++   //..other stuff..
++++
++++   if (name === 'test') {
++++     return false;
++++   }
++++
++++   return name;
++++ }

---- function() {
----   var name = getName();
----
----   if (!arguments.length) {
----     return false;
----   }
----
----   return true;
---- }

++++ function() {
++++   if (!arguments.length) {
++++     return false;
++++   }
++++
++++   var name = getName();
++++
++++   return true;
++++ }



**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='hoisting'>Hoisting</a>
----

Variable declarations get hoisted to the top of their scope, their assignment does not.

    // we know this wouldn't work (assuming there
    // is no notDefined global variable)
    function example() {
      console.log(notDefined); // => throws a ReferenceError
    }

    // creating a variable declaration after you
    // reference the variable will work due to
    // variable hoisting. Note: the assignment
    // value of `true` is not hoisted.
    function example() {
      console.log(declaredButNotAssigned); // => undefined
      var declaredButNotAssigned = true;
    }

    // The interpreter is hoisting the variable
    // declaration to the top of the scope.
    // Which means our example could be rewritten as:
    function example() {
      var declaredButNotAssigned;
      console.log(declaredButNotAssigned); // => undefined
      declaredButNotAssigned = true;
    }

Anonymous function expressions hoist their variable name, but not the function assignment.

    function example() {
      console.log(anonymous); // => undefined

      anonymous(); // => TypeError anonymous is not a function

      var anonymous = function() {
        console.log('anonymous function expression');
      };
    }

Named function expressions hoist the variable name, not the function name or the function body.

    function example() {
      console.log(named); // => undefined

      named(); // => TypeError named is not a function

      superPower(); // => ReferenceError superPower is not defined

      var named = function superPower() {
        console.log('Flying');
      };


      // the same is true when the function name
      // is the same as the variable name.
      function example() {
        console.log(named); // => undefined

        named(); // => TypeError named is not a function

        var named = function named() {
          console.log('named');
        };
      }
    }

Function declarations hoist their name and the function body.

    function example() {
      superPower(); // => Flying

      function superPower() {
        console.log('Flying');
      }
    }

For more information refer to [JavaScript Scoping & Hoisting](http://www.adequatelygood.com/2010/2/JavaScript-Scoping-and-Hoisting) by [Ben Cherry](http://www.adequatelygood.com/)



**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='conditionals'>Conditional Expressions & Equality</a>
----

Use `===` and `!==` over `==` and `!=`.
Conditional expressions are evaluated using coercion with the `ToBoolean` method and always follow these simple rules:

+ **Objects** evaluate to **true**
+ **Undefined** evaluates to **false**
+ **Null** evaluates to **false**
+ **Booleans** evaluate to **the value of the boolean**
+ **Numbers** evalute to **false** if **+0, -0, or NaN**, otherwise **true**
+ **Strings** evaluate to **false** if an empty string `''`, otherwise **true**

     if ([0]) {
       // true
       // An array is an object, objects evaluate to true
     }

Use shortcuts.

---- if (name !== '') {
----   // ...stuff...
---- }

++++ if (name) {
++++   // ...stuff...
++++ }

---- if (collection.length > 0) {
----   // ...stuff...
---- }

++++ if (collection.length) {
++++  // ...stuff...
++++ }

For more information see [Truth Equality and JavaScript](http://javascriptweblog.wordpress.com/2011/02/07/truth-equality-and-javascript/#more-2108) by Angus Croll



**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='blocks'>Blocks</a>
----


Use braces with all multi-line blocks.

---- if (test)
----   return false;

++++ if (test) return false;

++++ if (test) {
++++   return false;
++++ }

---- function() { return false; }

++++ function() {
++++   return false;
++++ }


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='comments'>Comments</a>
----

Use `/** ... */` for multiline comments. Include a description, specify types and values for all parameters and return values.

---- // make() returns a new element
---- // based on the passed in tag name
---- //
---- // @param <String> tag
---- // @return <Element> element
---- function make(tag) {
----   // ...stuff...
----   return element;
---- }

++++ /**
++++  * make() returns a new element
++++  * based on the passed in tag name
++++  *
++++  * @param <String> tag
++++  * @return <Element> element
++++  */
++++ function make(tag) {
++++   // ...stuff...
++++   return element;
++++ }

Use `//` for single line comments. Place single line comments on a newline above the subject of the comment. Put an emptyline before the comment.

    var active = true;  // is current tab

++++ // is current tab
++++ var active = true;

---- function getType() {
----   console.log('fetching type...');
----   // set the default type to 'no type'
----   var type = this._type || 'no type';
----
----   return type;
---- }

++++ function getType() {
++++   console.log('fetching type...');
++++
++++   // set the default type to 'no type'
++++   var type = this._type || 'no type';
++++
++++   return type;
++++ }

Prefixing your comments with `FIXME` or `TODO` helps other developers quickly understand if you're pointing out a problem that needs to be revisited, or if you're suggesting a solution to the problem that needs to be implemented. These are different than regular comments because they are actionable. The actions are `FIXME -- need to figure this out` or `TODO -- need to implement`.

Use `// FIXME:` to annotate problems

    function Calculator() {

      // FIXME: shouldn't use a global here
      total = 0;

      return this;
    }

Use `// TODO:` to annotate solutions to problems

    function Calculator() {

      // TODO: total should be configurable by an options param
      this.total = 0;

      return this;
    }


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='whitespace'>Whitespace</a>
----

Use soft tabs set to 2 spaces

---- function() {
---- ∙∙∙∙var name;
---- }

---- function() {
---- ∙var name;
---- }

++++ function() {
++++ ∙∙var name;
++++ }

Place 1 space before the leading brace.

---- function test(){
----   console.log('test');
---- }

++++ function test() {
++++   console.log('test');
++++ }

---- dog.set('attr',{
----   age: '1 year',
----   breed: 'Bernese Mountain Dog'
---- });

++++ dog.set('attr', {
++++   age: '1 year',
++++   breed: 'Bernese Mountain Dog'
++++ });

Place an empty newline at the end of the file.

---- (function(global) {
----   // ...stuff...
---- })(this);

++++ (function(global) {
++++   // ...stuff...
++++ })(this);


Use indentation when making long method chains.

---- $('#items').find('.selected').highlight().end().find('.open').updateCount();

++++ $('#items')
++++   .find('.selected')
++++     .highlight()
++++     .end()
++++   .find('.open')
++++     .updateCount();

---- var leds = stage.selectAll('.led').data(data).enter().append('svg:svg').class('led', true)
----     .attr('width',  (radius + margin) * 2).append('svg:g')
----     .attr('transform', 'translate(' + (radius + margin) + ',' + (radius + margin) + ')')
----     .call(tron.led);

++++ var leds = stage.selectAll('.led')
++++     .data(data)
++++   .enter().append('svg:svg')
++++     .class('led', true)
++++     .attr('width',  (radius + margin) * 2)
++++   .append('svg:g')
++++     .attr('transform', 'translate(' + (radius + margin) + ',' + (radius + margin) + ')')
++++     .call(tron.led);

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='commas'>Commas</a>
----

Leading commas: **Nope.**

---- var once
----   , upon
----   , aTime;

++++ var once,
++++     upon,
++++     aTime;

---- var hero = {
----     firstName: 'Bob'
----   , lastName: 'Parr'
----   , heroName: 'Mr. Incredible'
----   , superPower: 'strength'
---- };

++++ var hero = {
++++   firstName: 'Bob',
++++   lastName: 'Parr',
++++   heroName: 'Mr. Incredible',
++++   superPower: 'strength'
++++ };

Additional trailing comma: **Nope.** This can cause problems with IE6/7 and IE9 if it's in quirksmode. Also, in some implementations of ES3 would add length to an array if it had an additional trailing comma. This was clarified in ES5 ([source](http://es5.github.io/#D)):

  > Edition 5 clarifies the fact that a trailing comma at the end of an ArrayInitialiser does not add to the length of the array. This is not a semantic change from Edition 3 but some implementations may have previously misinterpreted this.

---- var hero = {
----   firstName: 'Kevin',
----   lastName: 'Flynn',
---- };

---- var heroes = [
----   'Batman',
----   'Superman',
---- ];

++++ var hero = {
++++   firstName: 'Kevin',
++++   lastName: 'Flynn'
++++ };

++++ var heroes = [
++++   'Batman',
++++   'Superman'
++++ ];


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='semicolons'>Semicolons</a>
----

**Yup.**

---- (function() {
----   var name = 'Skywalker'
----   return name
---- })()

++++ (function() {
++++   var name = 'Skywalker';
++++   return name;
++++ })();

++++ ;(function() {
++++   var name = 'Skywalker';
++++   return name;
++++ })();


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='type-coercion'>Type Casting & Coercion</a>
----

Perform type coercion at the beginning of the statement.

Strings:

     //  => this.reviewScore = 9;

---- var totalScore = this.reviewScore + '';

++++ var totalScore = '' + this.reviewScore;

---- var totalScore = '' + this.reviewScore + ' total score';

++++ var totalScore = this.reviewScore + ' total score';

Use `parseInt` for Numbers and always with a radix for type casting.

     var inputValue = '4';

---- var val = new Number(inputValue);

---- var val = +inputValue;

---- var val = inputValue >> 0;

---- var val = parseInt(inputValue);

++++ var val = Number(inputValue);

++++ var val = parseInt(inputValue, 10);

If for whatever reason you are doing something wild and `parseInt` is your bottleneck and need to use Bitshift for [performance reasons](http://jsperf.com/coercion-vs-casting/3), leave a comment explaining why and what you're doing.

++++ /**
++++  * parseInt was the reason my code was slow.
++++  * Bitshifting the String to coerce it to a
++++  * Number made it a lot faster.
++++  */
++++ var val = inputValue >> 0;

Booleans:

     var age = 0;

---- var hasAge = new Boolean(age);

++++ var hasAge = Boolean(age);

++++ var hasAge = !!age;


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='naming-conventions'>Naming Conventions</a>
----

Avoid single letter names. Be descriptive with your naming.

---- function q() {
----   // ...stuff...
---- }

++++ function query() {
++++   // ..stuff..
++++ }

Use camelCase when naming objects, functions, and instances

---- var OBJEcttsssss = {};
---- var this_is_my_object = {};
---- var this-is-my-object = {};
---- function c() {};
---- var u = new user({
----   name: 'Bob Parr'
---- });

++++ var thisIsMyObject = {};
++++ function thisIsMyFunction() {};
++++ var user = new User({
++++   name: 'Bob Parr'
++++ });

Use PascalCase when naming constructors or classes

---- function user(options) {
----   this.name = options.name;
---- }

     var bad = new user({
       name: 'nope'
     });

++++ function User(options) {
++++   this.name = options.name;
++++ }

     var good = new User({
       name: 'yup'
     });

Use a leading underscore `_` when naming private properties

---- this.__firstName__ = 'Panda';
---- this.firstName_ = 'Panda';

++++ this._firstName = 'Panda';

When saving a reference to `this` use `_this`.

---- function() {
----   var self = this;
----   return function() {
----     console.log(self);
----   };
---- }

---- function() {
----   var that = this;
----   return function() {
----     console.log(that);
----   };
---- }

++++ function() {
++++   var _this = this;
++++   return function() {
++++     console.log(_this);
++++   };
++++ }

Name your functions. This is helpful for stack traces.

---- var log = function(msg) {
----   console.log(msg);
---- };

++++ var log = function log(msg) {
++++   console.log(msg);
++++ };


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='accessors'>Accessors</a>
----

Accessor functions for properties are not required
If you do make accessor functions use getVal() and setVal('hello')

---- dragon.age();

++++ dragon.getAge();

---- dragon.age(25);

++++ dragon.setAge(25);

If the property is a boolean, use isVal() or hasVal()

---- if (!dragon.age()) {
----   return false;
---- }

++++ if (!dragon.hasAge()) {
++++   return false;
++++ }

It's okay to create get() and set() functions, but be consistent.

    function Jedi(options) {
      options || (options = {});
      var lightsaber = options.lightsaber || 'blue';
      this.set('lightsaber', lightsaber);
    }

    Jedi.prototype.set = function(key, val) {
      this[key] = val;
    };

    Jedi.prototype.get = function(key) {
      return this[key];
    };


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='constructors'>Constructors</a>
----

Assign methods to the prototype object, instead of overwriting the prototype with a new object. Overwriting the prototype makes inheritance impossible: by resetting the prototype you'll overwrite the base!

    function Jedi() {
      console.log('new jedi');
    }

---- Jedi.prototype = {
----   fight: function fight() {
----     console.log('fighting');
----   },
----
----   block: function block() {
----     console.log('blocking');
----   }
---- };

++++ Jedi.prototype.fight = function fight() {
++++   console.log('fighting');
++++ };
++++
++++ Jedi.prototype.block = function block() {
++++   console.log('blocking');
++++ };

Methods can return `this` to help with method chaining.

---- Jedi.prototype.jump = function() {
----   this.jumping = true;
----   return true;
---- };
----
---- Jedi.prototype.setHeight = function(height) {
----   this.height = height;
---- };
----
---- var luke = new Jedi();
---- luke.jump(); // => true
---- luke.setHeight(20) // => undefined

++++ Jedi.prototype.jump = function() {
++++   this.jumping = true;
++++   return this;
++++ };
++++
++++ Jedi.prototype.setHeight = function(height) {
++++   this.height = height;
++++   return this;
++++ };
++++
++++ var luke = new Jedi();
++++ luke.jump()
++++   .setHeight(20);

It's okay to write a custom toString() method, just make sure it works successfully and causes no side effects.

    function Jedi(options) {
      options || (options = {});
      this.name = options.name || 'no name';
    }

    Jedi.prototype.getName = function getName() {
      return this.name;
    };

    Jedi.prototype.toString = function toString() {
      return 'Jedi - ' + this.getName();
    };


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='events'>Events</a>
----

When attaching data payloads to events (whether DOM events or something more proprietary like Backbone events), pass a hash instead of a raw value. This allows a subsequent contributor to add more data to the event payload without finding and updating every handler for the event. For example, instead of:

---- $(this).trigger('listingUpdated', listing.id);
----
---- ...
----
---- $(this).on('listingUpdated', function(e, listingId) {
----   // do something with listingId
---- });

     // prefer:

++++ $(this).trigger('listingUpdated', { listingId : listing.id });
++++
++++ ...
++++
++++ $(this).on('listingUpdated', function(e, data) {
++++   // do something with data.listingId
++++ });


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='modules'>Modules</a>
----

The module should start with a `!`. This ensures that if a malformed module forgets to include a final semicolon there aren't errors in production when the scripts get concatenated. [Explanation](https://github.com/airbnb/javascript/issues/44#issuecomment-13063933)
The file should be named with camelCase, live in a folder with the same name, and match the name of the single export.
Add a method called noConflict() that sets the exported module to the previous version and returns this one.
Always declare `'use strict';` at the top of the module.

    // fancyInput/fancyInput.js

    !function(global) {
      'use strict';

      var previousFancyInput = global.FancyInput;

      function FancyInput(options) {
        this.options = options || {};
      }

      FancyInput.noConflict = function noConflict() {
        global.FancyInput = previousFancyInput;
        return FancyInput;
      };

      global.FancyInput = FancyInput;
    }(this);


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='jquery'>jQuery</a>
----

Prefix jQuery object variables with a `$`.

---- var sidebar = $('.sidebar');

++++ var $sidebar = $('.sidebar');

Cache jQuery lookups.

---- function setSidebar() {
----   $('.sidebar').hide();
----
----   // ...stuff...
----
----   $('.sidebar').css({
----     'background-color': 'pink'
----   });
---- }

++++ function setSidebar() {
++++   var $sidebar = $('.sidebar');
++++   $sidebar.hide();
++++
++++   // ...stuff...
++++
++++   $sidebar.css({
++++     'background-color': 'pink'
++++   });
++++ }

For DOM queries use Cascading `$('.sidebar ul')` or parent > child `$('.sidebar > ul')`. [jsPerf](http://jsperf.com/jquery-find-vs-context-sel/16)
Use `find` with scoped jQuery object queries.

---- $('.sidebar', 'ul').hide();

---- $('.sidebar').find('ul').hide();

++++ $('.sidebar ul').hide();

++++ $('.sidebar > ul').hide();

++++ // (slower)
++++ $sidebar.find('ul');

++++ // (faster)
++++ $($sidebar[0]).find('ul');


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='es5'>ECMAScript 5 Compatibility</a>
----

Refer to [Kangax](https://twitter.com/kangax/)'s ES5 [compatibility table](http://kangax.github.com/es5-compat-table/


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='testing'>Testing</a>
----

**Yup.**

    function() {
      return true;
    }


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='performance'>Performance</a>
----

  - [On Layout & Web Performance](http://kellegous.com/j/2013/01/26/layout-performance/)
  - [String vs Array Concat](http://jsperf.com/string-vs-array-concat/2)
  - [Try/Catch Cost In a Loop](http://jsperf.com/try-catch-in-loop-cost)
  - [Bang Function](http://jsperf.com/bang-function)
  - [jQuery Find vs Context, Selector](http://jsperf.com/jquery-find-vs-context-sel/13)
  - [innerHTML vs textContent for script text](http://jsperf.com/innerhtml-vs-textcontent-for-script-text)
  - [Long String Concatenation](http://jsperf.com/ya-string-concat)
  - Loading..


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='resources'>Resources</a>
----


**Read This**

  - [Annotated ECMAScript 5.1](http://es5.github.com/)

**Other Styleguides**

  - [Google JavaScript Style Guide](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml)
  - [jQuery Core Style Guidelines](http://docs.jquery.com/JQuery_Core_Style_Guidelines)
  - [Principles of Writing Consistent, Idiomatic JavaScript](https://github.com/rwldrn/idiomatic.js/)

**Other Styles**

  - [Naming this in nested functions](https://gist.github.com/4135065) - Christian Johansen
  - [Conditional Callbacks](https://github.com/airbnb/javascript/issues/52)

**Further Reading**

  - [Understanding JavaScript Closures](http://javascriptweblog.wordpress.com/2010/10/25/understanding-javascript-closures/) - Angus Croll

**Books**

  - [JavaScript: The Good Parts](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742) - Douglas Crockford
  - [JavaScript Patterns](http://www.amazon.com/JavaScript-Patterns-Stoyan-Stefanov/dp/0596806752) - Stoyan Stefanov
  - [Pro JavaScript Design Patterns](http://www.amazon.com/JavaScript-Design-Patterns-Recipes-Problem-Solution/dp/159059908X)  - Ross Harmes and Dustin Diaz
  - [High Performance Web Sites: Essential Knowledge for Front-End Engineers](http://www.amazon.com/High-Performance-Web-Sites-Essential/dp/0596529309) - Steve Souders
  - [Maintainable JavaScript](http://www.amazon.com/Maintainable-JavaScript-Nicholas-C-Zakas/dp/1449327680) - Nicholas C. Zakas
  - [JavaScript Web Applications](http://www.amazon.com/JavaScript-Web-Applications-Alex-MacCaw/dp/144930351X) - Alex MacCaw
  - [Pro JavaScript Techniques](http://www.amazon.com/Pro-JavaScript-Techniques-John-Resig/dp/1590597273) - John Resig
  - [Smashing Node.js: JavaScript Everywhere](http://www.amazon.com/Smashing-Node-js-JavaScript-Everywhere-Magazine/dp/1119962595) - Guillermo Rauch

**Blogs**

  - [DailyJS](http://dailyjs.com/)
  - [JavaScript Weekly](http://javascriptweekly.com/)
  - [JavaScript, JavaScript...](http://javascriptweblog.wordpress.com/)
  - [Bocoup Weblog](http://weblog.bocoup.com/)
  - [Adequately Good](http://www.adequatelygood.com/)
  - [NCZOnline](http://www.nczonline.net/)
  - [Perfection Kills](http://perfectionkills.com/)
  - [Ben Alman](http://benalman.com/)
  - [Dmitry Baranovskiy](http://dmitry.baranovskiy.com/)
  - [Dustin Diaz](http://dustindiaz.com/)
  - [nettuts](http://net.tutsplus.com/?s=javascript

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='in-the-wild'>In the Wild</a>
----

This is a list of organizations that are using this style guide. Send us a pull request or open an issue and we'll add you to the list.

  - **Airbnb**: [airbnb/javascript](https://github.com/airbnb/javascript)
  - **American Insitutes for Research**: [AIRAST/javascript](https://github.com/AIRAST/javascript)
  - **Compass Learning**: [compasslearning/javascript-style-guide](https://github.com/compasslearning/javascript-style-guide)
  - **ExactTarget**: [ExactTarget/javascript](https://github.com/ExactTarget/javascript)
  - **GeneralElectric**: [GeneralElectric/javascript](https://github.com/GeneralElectric/javascript)
  - **GoodData**: [gooddata/gdc-js-style](https://github.com/gooddata/gdc-js-style)
  - **Grooveshark**: [grooveshark/javascript](https://github.com/grooveshark/javascript)
  - **How About We**: [howaboutwe/javascript](https://github.com/howaboutwe/javascript)
  - **MinnPost**: [MinnPost/javascript](https://github.com/MinnPost/javascript)
  - **ModCloth**: [modcloth/javascript](https://github.com/modcloth/javascript)
  - **National Geographic**: [natgeo/javascript](https://github.com/natgeo/javascript)
  - **National Park Service**: [nationalparkservice/javascript](https://github.com/nationalparkservice/javascript)
  - **Razorfish**: [razorfish/javascript-style-guide](https://github.com/razorfish/javascript-style-guide)
  - **Shutterfly**: [shutterfly/javascript](https://github.com/shutterfly/javascript)
  - **Userify**: [userify/javascript](https://github.com/userify/javascript)
  - **Zillow**: [zillow/javascript](https://github.com/zillow/javascript)
  - **ZocDoc**: [ZocDoc/javascript](https://github.com/ZocDoc/javascript)

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='translation'>Translation</a>
----

This style guide is also available in other languages:

  - :de: **German**: [timofurrer/javascript-style-guide](https://github.com/timofurrer/javascript-style-guide)
  - :jp: **Japanese**: [mitsuruog/javacript-style-guide](https://github.com/mitsuruog/javacript-style-guide)
  - :br: **Portuguese**: [armoucar/javascript-style-guide](https://github.com/armoucar/javascript-style-guide)
  - :cn: **Chinese**: [adamlu/javascript-style-guide](https://github.com/adamlu/javascript-style-guide)

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='guide-guide'>The JavaScript Style Guide Guide</a>
----

  - [Reference](https://github.com/airbnb/javascript/wiki/The-JavaScript-Style-Guide-Guide)

**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='authors'>Contributors</a>
----

  - [View Contributors](https://github.com/airbnb/javascript/graphs/contributors)


**<a href="#TOC" class="toc">[⬆]</a>**

## <a name='license'>License</a>
----

(The MIT License)

Copyright (c) 2012 Airbnb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWAR

# };
