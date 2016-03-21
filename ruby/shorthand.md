# Ruby Shorthand

> env ruby 2.3.0

`%` Magic. Need to dig into this one a little more but... Multi-line strings and symbols.

```ruby
  %s"
    symbol
  " => :"\nsymbol\n"
```

```ruby
  %"
    string
  " => "\nstring\n"
```

You can also create a single character string by using `?x`.

```ruby
  ?? => "?"
```

The `*` is equivalent to `join` when called on an `Array`.

```ruby
  [1,2,3]*'' => "123"
```

In most cases `tr` can be used in place of `gsub`.

```ruby
  'modify'.tr('d','p') => "mopify"
```

A quick way of converting a `Range` to an `Array`.

```ruby
  [*'a'..'g'] => ["a", "b", "c", "d", "e", "f", "g"]
```

A proc can be called using `.()` rather than `call`.

```ruby
  ->{ 'proc' }.() => "proc"
```

Working with `STDOUT` and `STDIN`

* `%>` = STDOUT. You can push a string back into it using `<<`
* `%<` = STDIN. Rather than calling, lines or `read` you can call `to_a` on stdin.
* `p` writes to stdout with a new line. For strings it will call obj.inspect

Using ruby hashbang commands. For more commands use `ruby -h`

- To call the script for each line of stdin use `#!ruby -n`. Now the file is specific to one line of stdin and can be accessed using `$_`.
- To output a ruby scripte add `#!ruby -p` to the top of the file.
