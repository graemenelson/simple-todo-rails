# Simple Todo Rails App

This is a sample rails app, that uses the [simple todo library](https://github.com/graemenelson/simple-todo).  All of the business logic is in the library, and has no attachment to the framework or persistence.  I hope to build a sample sinatra app based on the same library.

There is some lib functionality in this app that I might break out at a later time, so I can re-use in a sinatra application -- it's only dependency is on active model but not persistence.

## TODO:
* clean up the decorators library, no longer needed.
* clean up the views, not really happy with them at this time.  Thought about using [display_case](https://github.com/objects-on-rails/display-case).