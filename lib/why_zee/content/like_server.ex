defmodule WhyZee.Content.Servers.LikeServer do
  use GenServer
  alias WhyZee.Content

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def like(element) do
    GenServer.cast(__MODULE__, {:like, element})
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state, {:continue, :start_likes}}
  end

  @impl
  def handle_continue(:start_likes, state) do
    schedule_work(state)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:like, post_id}, state) do
    new_state = Map.update(state, post_id, 1, fn value -> value + 1 end)
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:submit_likes, state) do
    schedule_work(state)

    {:noreply, %{}}
  end

  defp schedule_work(state) do
    Content.submit_likes(state)
    Process.send_after(self(), :submit_likes, 1000)
  end
end
