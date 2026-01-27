[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatLog

# Class: ChatLog

Defined in: common/ChatLog.ts:12

This needs to be global to avoid TS2403 in case lib.dom.d.ts is present in the same build

## Constructors

### Constructor

> **new ChatLog**(): `ChatLog`

#### Returns

`ChatLog`

## Accessors

### enableLog

#### Get Signature

> **get** **enableLog**(): `boolean`

Defined in: common/ChatLog.ts:360

##### Returns

`boolean`

#### Set Signature

> **set** **enableLog**(`is`): `void`

Defined in: common/ChatLog.ts:356

##### Parameters

###### is

`boolean`

##### Returns

`void`

***

### enableTimestamp

#### Get Signature

> **get** **enableTimestamp**(): `boolean`

Defined in: common/ChatLog.ts:370

##### Returns

`boolean`

#### Set Signature

> **set** **enableTimestamp**(`is`): `void`

Defined in: common/ChatLog.ts:366

##### Parameters

###### is

`boolean`

##### Returns

`void`

***

### handler

#### Set Signature

> **set** **handler**(`h`): `void`

Defined in: common/ChatLog.ts:386

##### Parameters

###### h

[`PrintFunctionType`](../type-aliases/PrintFunctionType.md)

##### Returns

`void`

***

### tag

#### Get Signature

> **get** **tag**(): `string`

Defined in: common/ChatLog.ts:380

##### Returns

`string`

#### Set Signature

> **set** **tag**(`tag`): `void`

Defined in: common/ChatLog.ts:376

##### Parameters

###### tag

`string`

##### Returns

`void`

## Methods

### assert()

> **assert**(`value`, `message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:33

`console.assert()` writes a message if `value` is [falsy](https://developer.mozilla.org/en-US/docs/Glossary/Falsy) or omitted. It only
writes a message and does not otherwise affect execution. The output always
starts with `"Assertion failed"`. If provided, `message` is formatted using `util.format()`.

If `value` is [truthy](https://developer.mozilla.org/en-US/docs/Glossary/Truthy), nothing happens.

```js
console.assert(true, 'does nothing');

console.assert(false, 'Whoops %s work', 'didn\'t');
// Assertion failed: Whoops didn't work

console.assert();
// Assertion failed
```

#### Parameters

##### value

`any`

The value tested for being truthy.

##### message?

`string`

All arguments besides `value` are used as error message.

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v0.1.101

***

### clear()

> **clear**(): `void`

Defined in: common/ChatLog.ts:48

When `stdout` is a TTY, calling `console.clear()` will attempt to clear the
TTY. When `stdout` is not a TTY, this method does nothing.

The specific operation of `console.clear()` can vary across operating systems
and terminal types. For most Linux operating systems, `console.clear()`operates similarly to the `clear` shell command. On Windows, `console.clear()`will clear only the output in the
current terminal viewport for the Node.js
binary.

#### Returns

`void`

#### Since

v8.3.0

***

### count()

> **count**(`label?`): `void`

Defined in: common/ChatLog.ts:81

Maintains an internal counter specific to `label` and outputs to `stdout` the
number of times `console.count()` has been called with the given `label`.

```js
> console.count()
default: 1
undefined
> console.count('default')
default: 2
undefined
> console.count('abc')
abc: 1
undefined
> console.count('xyz')
xyz: 1
undefined
> console.count('abc')
abc: 2
undefined
> console.count()
default: 3
undefined
>
```

#### Parameters

##### label?

`string`

The display label for the counter.

#### Returns

`void`

#### Since

v8.3.0

***

### countReset()

> **countReset**(`label?`): `void`

Defined in: common/ChatLog.ts:103

Resets the internal counter specific to `label`.

```js
> console.count('abc');
abc: 1
undefined
> console.countReset('abc');
undefined
> console.count('abc');
abc: 1
undefined
>
```

#### Parameters

##### label?

`string`

The display label for the counter.

#### Returns

`void`

#### Since

v8.3.0

***

### debug()

> **debug**(`message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:112

The `console.debug()` function is an alias for [log](#log).

#### Parameters

##### message?

`any`

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v8.0.0

***

### dir()

> **dir**(`obj`, `options?`): `void`

Defined in: common/ChatLog.ts:120

Uses `util.inspect()` on `obj` and prints the resulting string to `stdout`.
This function bypasses any custom `inspect()` function defined on `obj`.

#### Parameters

##### obj

`any`

##### options?

`InspectOptions`

#### Returns

`void`

#### Since

v0.1.101

***

### dirxml()

> **dirxml**(...`data`): `void`

Defined in: common/ChatLog.ts:130

This method calls `console.log()` passing it the arguments received.
This method does not produce any XML formatting.

#### Parameters

##### data

...`any`[]

#### Returns

`void`

#### Since

v8.0.0

***

### error()

> **error**(`message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:152

Prints to `stderr` with newline. Multiple arguments can be passed, with the
first used as the primary message and all additional used as substitution
values similar to [`printf(3)`](http://man7.org/linux/man-pages/man3/printf.3.html) (the arguments are all passed to `util.format()`).

```js
const code = 5;
console.error('error #%d', code);
// Prints: error #5, to stderr
console.error('error', code);
// Prints: error 5, to stderr
```

If formatting elements (e.g. `%d`) are not found in the first string then `util.inspect()` is called on each argument and the resulting string
values are concatenated. See `util.format()` for more information.

#### Parameters

##### message?

`any`

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v0.1.100

***

### group()

> **group**(...`label`): `void`

Defined in: common/ChatLog.ts:162

Increases indentation of subsequent lines by spaces for `groupIndentation`length.

If one or more `label`s are provided, those are printed first without the
additional indentation.

#### Parameters

##### label

...`any`[]

#### Returns

`void`

#### Since

v8.5.0

***

### groupCollapsed()

> **groupCollapsed**(...`label`): `void`

Defined in: common/ChatLog.ts:171

An alias for [group](#group).

#### Parameters

##### label

...`any`[]

#### Returns

`void`

#### Since

v8.5.0

***

### groupEnd()

> **groupEnd**(): `void`

Defined in: common/ChatLog.ts:180

Decreases indentation of subsequent lines by spaces for `groupIndentation`length.

#### Returns

`void`

#### Since

v8.5.0

***

### info()

> **info**(`message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:189

The `console.info()` function is an alias for [log](#log).

#### Parameters

##### message?

`any`

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v0.1.100

***

### log()

> **log**(`message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:208

Prints to `stdout` with newline. Multiple arguments can be passed, with the
first used as the primary message and all additional used as substitution
values similar to [`printf(3)`](http://man7.org/linux/man-pages/man3/printf.3.html) (the arguments are all passed to `util.format()`).

```js
const count = 5;
console.log('count: %d', count);
// Prints: count: 5, to stdout
console.log('count:', count);
// Prints: count: 5, to stdout
```

See `util.format()` for more information.

#### Parameters

##### message?

`any`

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v0.1.100

***

### profile()

> **profile**(`label?`): `void`

Defined in: common/ChatLog.ts:330

This method does not display anything unless used in the inspector.
 Starts a JavaScript CPU profile with an optional label.

#### Parameters

##### label?

`string`

#### Returns

`void`

***

### profileEnd()

> **profileEnd**(`label?`): `void`

Defined in: common/ChatLog.ts:339

This method does not display anything unless used in the inspector.
 Stops the current JavaScript CPU profiling session if one has been started and prints the report to the Profiles panel of the inspector.

#### Parameters

##### label?

`string`

#### Returns

`void`

***

### table()

> **table**(`tabularData`, `properties?`): `void`

Defined in: common/ChatLog.ts:242

Try to construct a table with the columns of the properties of `tabularData`(or use `properties`) and rows of `tabularData` and log it. Falls back to just
logging the argument if it can’t be parsed as tabular.

```js
// These can't be parsed as tabular data
console.table(Symbol());
// Symbol()

console.table(undefined);
// undefined

console.table([{ a: 1, b: 'Y' }, { a: 'Z', b: 2 }]);
// ┌─────────┬─────┬─────┐
// │ (index) │  a  │  b  │
// ├─────────┼─────┼─────┤
// │    0    │  1  │ 'Y' │
// │    1    │ 'Z' │  2  │
// └─────────┴─────┴─────┘

console.table([{ a: 1, b: 'Y' }, { a: 'Z', b: 2 }], ['a']);
// ┌─────────┬─────┐
// │ (index) │  a  │
// ├─────────┼─────┤
// │    0    │  1  │
// │    1    │ 'Z' │
// └─────────┴─────┘
```

#### Parameters

##### tabularData

`any`

##### properties?

readonly `string`[]

Alternate properties for constructing the table.

#### Returns

`void`

#### Since

v10.0.0

***

### time()

> **time**(`label?`): `void`

Defined in: common/ChatLog.ts:254

Starts a timer that can be used to compute the duration of an operation. Timers
are identified by a unique `label`. Use the same `label` when calling [timeEnd](#timeend) to stop the timer and output the elapsed time in
suitable time units to `stdout`. For example, if the elapsed
time is 3869ms, `console.timeEnd()` displays "3.869s".

#### Parameters

##### label?

`string`

#### Returns

`void`

#### Since

v0.1.104

***

### timeEnd()

> **timeEnd**(`label?`): `void`

Defined in: common/ChatLog.ts:271

Stops a timer that was previously started by calling [time](#time) and
prints the result to `stdout`:

```js
console.time('100-elements');
for (let i = 0; i < 100; i++) {}
console.timeEnd('100-elements');
// prints 100-elements: 225.438ms
```

#### Parameters

##### label?

`string`

#### Returns

`void`

#### Since

v0.1.104

***

### timeLog()

> **timeLog**(`label?`, ...`data?`): `void`

Defined in: common/ChatLog.ts:290

For a timer that was previously started by calling [time](#time), prints
the elapsed time and other `data` arguments to `stdout`:

```js
console.time('process');
const value = expensiveProcess1(); // Returns 42
console.timeLog('process', value);
// Prints "process: 365.227ms 42".
doExpensiveProcess2(value);
console.timeEnd('process');
```

#### Parameters

##### label?

`string`

##### data?

...`any`[]

#### Returns

`void`

#### Since

v10.7.0

***

### timeStamp()

> **timeStamp**(`label?`): `void`

Defined in: common/ChatLog.ts:348

This method does not display anything unless used in the inspector.
 Adds an event with the label `label` to the Timeline panel of the inspector.

#### Parameters

##### label?

`string`

#### Returns

`void`

***

### trace()

> **trace**(`message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:315

Prints to `stderr` the string `'Trace: '`, followed by the `util.format()` formatted message and stack trace to the current position in the code.

```js
console.trace('Show me');
// Prints: (stack trace will vary based on where trace is called)
//  Trace: Show me
//    at repl:2:9
//    at REPLServer.defaultEval (repl.js:248:27)
//    at bound (domain.js:287:14)
//    at REPLServer.runBound [as eval] (domain.js:300:12)
//    at REPLServer.<anonymous> (repl.js:412:12)
//    at emitOne (events.js:82:20)
//    at REPLServer.emit (events.js:169:7)
//    at REPLServer.Interface._onLine (readline.js:210:10)
//    at REPLServer.Interface._line (readline.js:549:8)
//    at REPLServer.Interface._ttyWrite (readline.js:826:14)
```

#### Parameters

##### message?

`any`

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v0.1.104

***

### warn()

> **warn**(`message?`, ...`optionalParams?`): `void`

Defined in: common/ChatLog.ts:322

The `console.warn()` function is an alias for [error](#error).

#### Parameters

##### message?

`any`

##### optionalParams?

...`any`[]

#### Returns

`void`

#### Since

v0.1.100
