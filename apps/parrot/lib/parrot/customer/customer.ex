defmodule Parrot.Customer do
  @moduledoc """
  The Application context.
  """

  import Ecto.Query, warn: false
  alias Parrot.Repo

  alias Parrot.Customer.Assistant

  @doc """
  Returns the list of assistants.

  ## Examples

      iex> list_assistants()
      [%Assistant{}, ...]

  """
  def list_assistants do
    Repo.all(Assistant)
  end

  @doc """
  Gets a single assistant.

  Raises `Ecto.NoResultsError` if the Assistant does not exist.

  ## Examples

      iex> get_assistant!(123)
      %Assistant{}

      iex> get_assistant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assistant!(id), do: Repo.get!(Assistant, id)

  @doc """
  Creates a assistant.

  ## Examples

      iex> create_assistant(%{field: value})
      {:ok, %Assistant{}}

      iex> create_assistant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assistant(attrs \\ %{}) do
    %Assistant{}
    |> Assistant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a assistant.

  ## Examples

      iex> update_assistant(assistant, %{field: new_value})
      {:ok, %Assistant{}}

      iex> update_assistant(assistant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assistant(%Assistant{} = assistant, attrs) do
    assistant
    |> Assistant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Assistant.

  ## Examples

      iex> delete_assistant(assistant)
      {:ok, %Assistant{}}

      iex> delete_assistant(assistant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assistant(%Assistant{} = assistant) do
    Repo.delete(assistant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assistant changes.

  ## Examples

      iex> change_assistant(assistant)
      %Ecto.Changeset{source: %Assistant{}}

  """
  def change_assistant(%Assistant{} = assistant) do
    Assistant.changeset(assistant, %{})
  end
end
