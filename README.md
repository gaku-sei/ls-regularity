### Regularity LS

Conversion of the ruby library [Regularity](https://github.com/andrewberls/regularity "Regularity").

```LiveScript
require! regularity.Regularity

Regularity!
  .start-with 3 \digits
  .then \-
  .then 2 \letters
  .maybe \#
  .one-of <[a b]>
  .between [2 4] \a
  .end-with \$
  .regex!
```

Will return this regexp:

```JavaScript
/^[0-9]{3}-[A-Za-z]{2}#?[a|b]a{2,4}\$$/
```
