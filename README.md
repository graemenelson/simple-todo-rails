# Simple Todo Rails App

This is a sample rails app, that uses the [simple todo library](https://github.com/graemenelson/simple-todo).  All of the business logic is in the library, and has no attachment to the framework or persistence.  I hope to build a sample sinatra app based on the same library.

There is some lib functionality in this app that I might break out at a later time, so I can re-use in a sinatra application -- it's only dependency is on active model but not persistence.

## Usage:

To run with an in memory repository for people and todos, start up rails with:
    
    IN_MEMORY=true bundle exec rails s_

Otherwise, the app will use the active record repository, which will save to the database -- see lib/repository/active_record/person_repository.rb

Likewise, you can use the in memory repository to run tests.  I might force in memory in the future for tests, so they run faster.

## TODO:
* clean up the decorators library, no longer needed.
* clean up the views, not really happy with them at this time.  Thought about using [display_case](https://github.com/objects-on-rails/display-case).