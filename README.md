# Vim Tab Merge

## TODO:

- Update to reflect added features

---

## Original README:

This is a mirror of http://www.vim.org/scripts/script.php?script_id=1961

Usage:

```
:Tabmerge [tab number] [top|bottom|left|right]
```

The tab number can be "$" for the last tab.  If the tab number isn't specified
the tab to the right of the current tab is merged.  If there is no right tab,
the left tab is merged.

The location specifies where in the current tab to merge the windows. Defaults
to "top".

