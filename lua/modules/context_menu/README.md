This will make it easier to interact with nodes in a document

Requirements:
- The context menu should be global, i.e. any provider (a plugin spec, for example), might register an `entry`.
- Each `entry` is defined by:
    * a description
    * a callback function to call when executed
    * a condition function (should it be shown or not?)
- Will be displayed using `vim.ui.picker`
- It should be possible to define buffer local context menus, which override the global one.
  * For example, the context menu in Fern should be
    completely different from the one present in a normal document.
- It should be dot repeatable
- It should be possible to dynamically define context menus, and bring them up selectively.
- It should be tested


Limitations:
- Any non-node based menus can just be defined using vim.ui.picker directly? Or is this just another kind of context menu?


Possible entries:
- Toggling an entry based on nvim-ts-toggle
- Marking a list item as a TODO-item in a .md file
- Toggle a TODO-item in a .md file
- Rename entry


Doing these things would be possible without any information to the
consumer, but that would make it convoluted to add new entries.

Instead, I want to expose the most often used values when deciding both action and condition:
- Current line
- Current cursor position
- Current buffer (Buffer)
- Current window (Window)
- Current TS-node
- Current TS-document?
- Current filetype
