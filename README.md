# WhyZee

because X Y z

To start your Phoenix server:

there is an included docker compase with dockerfile built in database for you to hook up to

```

docker-compose run -p 4000:4000 -p 4001:4001 -p 5436:5432 app zsh
mix deps.get
mix ecto.migrate
mix phx.server

```


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Game Plan

The following boilerplate holds within it 
- aut flows generated via mix phx.gen.auth
- posts, greating a post will add it to the user
- oban is already setup

## goals
primary goals
- the posts page should only show posts from the user
- create a new page that whows all the posts and the ability to "like" it.

secondary
- each post should create a "like object"
- we need an oban job that periodically counts up the likes for a post and updates the like count
