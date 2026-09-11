local t = require('test.testutil')
local n = require('test.functional.testnvim')()

local describe, it, before_each, pending = t.describe, t.it, t.before_each, t.pending
local clear, eval, eq, matches = n.clear, n.eval, t.eq, t.matches
local source = n.source

-- clear({env=...}) replaces the child Nvim's environment with an allowlisted
-- subset (test/functional/testnvim.lua) that does not include
-- $XDG_RUNTIME_DIR, so pass it through explicitly to avoid a long
-- $TMPDIR-derived fallback socket path.
local runtime_dir = os.getenv('XDG_RUNTIME_DIR')

describe('vimscript', function()
  before_each(clear)

  it('parses `<SID>` with turkish locale', function()
    if not pcall(n.command, 'lang ctype tr_TR.UTF-8') then
      pending('Locale tr_TR.UTF-8 not supported')
      return
    end
    source([[
      let s:foo = 1
      func! <sid>_dummy_function()
        echo 1
      endfunc
      au VimEnter * call <sid>_dummy_function()
    ]])
    eq(nil, string.find(eval('v:errmsg'), '^E129'))
  end)

  it('str2float is not affected by locale', function()
    if not pcall(n.command, 'lang ctype sv_SE.UTF-8') then
      pending('Locale sv_SE.UTF-8 not supported')
      return
    end
    clear { env = { LANG = '', LC_NUMERIC = 'sv_SE.UTF-8', XDG_RUNTIME_DIR = runtime_dir } }
    eq(2.2, eval('str2float("2.2")'))
  end)
end)

describe('locale', function()
  it('forces a UTF-8 ctype locale when $LANG has no encoding', function()
    clear { env = { LANG = 'en_GB', LC_ALL = '', LC_CTYPE = '', XDG_RUNTIME_DIR = runtime_dir } }
    matches('[Uu][Tt][Ff]%-?8', eval('v:ctype'))
    matches('[Uu][Tt][Ff]%-?8', eval('$LC_CTYPE'))
  end)

  it('does not override a locale that is already UTF-8', function()
    clear { env = { LANG = 'C.UTF-8', LC_ALL = '', LC_CTYPE = '', XDG_RUNTIME_DIR = runtime_dir } }
    if not string.find(eval('v:ctype'):lower(), 'utf%-?8') then
      pending('Locale C.UTF-8 not supported')
      return
    end
    eq('C.UTF-8', eval('v:ctype'))
  end)
end)
