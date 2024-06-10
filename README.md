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


