# Big O Notation

When you discuss Big-O notation, that is generally referring to the worst case scenario.

For example, if we have to search two lists for common entries, we will calculate as if both entries would be at the very end of each list, just to be safe that we don't underestimate how long it could take.

- `O(1)` - determining if a number is odd or even. O(1) is a static amount of time, the same no matter how much information is there or how many users there are.
- `O(log N)` - finding a word in the dictionary (using binary search). Binary search is an example of a type of 'divide and conquer' algorithm.
- `O(N)` - reading a book
- `O(N log N)` - sorting a deck of playing cards (using merge sort)
- `O(N^2)` - checking if you have everything on your shopping list in your cart
- `O(infinity)` - tossing a coin until it lands on heads

[Cheatsheet](http://bigocheatsheet.com)
