# HTML5

prefetch and prerender usage

### prefetch

```html
  <link rel="prefetch">
```

Fetching and caching resources for later user navigation i.e. 
  prefetching a css file to be used in a page which highly likely to be used by the user in his upcoming navigation.
Supported in Chrome, Firefox & IE.

### prerender

```html
  <link rel="prerender">
```

Prerendering a complete page that the user will highly likely navigate to. i.e.
  like prerendering the next article where it is highly likely that the user will click on "next article" button.
Supported only in Chrome & IE.
