# brace-expansion compatibility shim

Pins [brace-expansion@5.0.8](https://www.npmjs.com/package/brace-expansion)
(CVE-2026-14257 / GHSA-mh99-v99m-4gvg) and restores a CommonJS default
function for `minimatch@3` / `minimatch@5`:

```js
const expand = require('brace-expansion')
expand('{a,b}')
```

The website forces this package via `overrides.brace-expansion` in
`website/package.json`.
