defmodule Portal do
  defstruct [:left, :right]

  @doc """
  Starts transfering data from left to right
  """
  def transfer(left, right, data) do
    for item <- data do
      Portal.Door.push(left, item)
    end

    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given portal
  """
  def push_right(portal) do
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    portal
  end

  @doc """
  Pushes data to the right in the given portal
  """
  def push_left(portal) do
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, t} -> Portal.Door.push(portal.left, t)
    end

    portal
  end

  @doc """
  Shoots a new door with the given color
  """
  def shoot(color) do
    DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, color})
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.pad_leading(left_door, max)} <=> #{right_door}
      #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """
  end
end
