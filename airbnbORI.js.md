R29 CodeConv
===============

Airbnb JavaScript Style Guide

A mostly reasonable approach to JavaScript


Types
-----

  **Primitives**: When you access a primitive type you work directly on its value

  + `string`
  + `number`
  + `boolean`
  + `null`
  + `undefined`

++++  var foo = 1,
++++      bar = foo;
++++
++++  bar = 9;
++++
++++  console.log(foo, bar); // => 1, 9
----  var BADLINE_HERE
      var NORMALLINE = 'BOOM!';
++++  function BackToGood(){}


  **Complex**: When you access a complex type you work on a reference to its value

  - `object`
  - `array`
  - `function`

++++ var foo = [1, 2],
++++ bar = foo;
++++
++++ bar[0] = 9;
++++
++++ console.log(foo[0], bar[0]); // => 9, 9
    

Objects
-------

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
++++  type: 'alien'
++++ };

Arrays
------

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

++++ function trigger() {
++++   var args = Array.prototype.slice.call(arguments);
++++   ...
++++ }

Strings
-------

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
++++  'was thrown because of Batman.' +
++++  'When you stop to think about ' +
++++  'how Batman had anything to do ' +
++++  'with this, you would get nowhere ' +
++++  'fast.';

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



  Vertically align multiple variable denfitions

---- var name = "asda"''
---- var n = "asda"''
---- var myname = "asda"''

++++ var name   = "asda"''
++++ var n      = "asda"''
++++ var myname = "asda"''



