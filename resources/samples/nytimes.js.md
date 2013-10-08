NYTIMES Coding Convention
=========================

What what what ?

g o f u c k y o s e l f

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
    
