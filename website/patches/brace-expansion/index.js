'use strict'

// Upstream 5.x only exports a named `expand`. minimatch@3 and minimatch@5 call
// require('brace-expansion') as a function. Re-export 5.0.8 with a callable
// default while keeping named exports.
const upstream = require('brace-expansion-v5')
const expand = upstream.expand

function braceExpansion(str, options) {
  return expand(str, options)
}

module.exports = Object.assign(braceExpansion, upstream, {
  expand,
  default: braceExpansion,
})
