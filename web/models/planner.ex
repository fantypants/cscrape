defmodule Cryptscrape.Planner do
  use GenServer
  alias Cryptscrape.DomainController

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    IO.puts "Supervisor for the planner is online"
    DomainController.run_list()
    Process.send_after(self(), :work, 60 * 1000 * 60 * 24) # In 24 Hours
  end
end
