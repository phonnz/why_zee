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
- like a post to increase the like count

secondary
- each post should create a "like object"
- if you liked a post previously, the button should be bold and clciking it will "unlike" it.
- we need an oban job that periodically counts up the likes for a post and updates the like count

bonus
- when someone else likes your post, you get a notification
