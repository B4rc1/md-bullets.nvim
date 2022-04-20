# md-bullets.nvim
My own KISS markdown bullet plugins

DISCLAIMER: This Plugin is for my personal use only. It may or may to be abanoned at any time, and may recieve abitrary changes without notice.

## Requirements
- Neovim `0.7+`

## Install

Install `B4rc1/md-bullets.nvim` using your plugin manager.

## Features
Demo: `|`: cursor

### continue bullet lists automatically
```
- some text|
```
Press `<CR>`
```
- some text
- |
```
Press `<CR>` again
```
- some text
  |
```

### continue citation and infer nesting
This is mainly useful for nested obsidian [callouts](https://help.obsidian.md/How+to/Use+callouts)
```
> > some text|
```
Press `<CR>`
```
> > some text
> > |
```
Press `<CR>`
```
> > some text
> >
> > |
```
Press `<CR>`
```
> > some text
> |
```

## I have a feature request/feedback
You are free to submit pull requests with your desired changes or fork the plugin.
