# Haml

> A ruby indentation based markup language

Bits I keep forgetting

----
Trim whitepace outside tag. Useful for preserving punctuation
```ruby
  %span> single-word (break) .
```
Trim whitepace inside tags. Useful for nesting tags that logically should go one one line
```ruby
  %tr< (break) %td
```
Preserve whitespace. Useful for keeping line breaks
```ruby
  %pre~ @content
```
Interpolated string. Work just like a double quoted string
```ruby
  %h1== New editing #{@content}
```
Sanitize HTML-unsafe characters
```ruby
  %h1&= @title
```
Unsanitized expression - *never* sanitize
```ruby
  %body!= @html
```
