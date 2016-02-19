defmodule Cry do

	@flcon (1 / (:math.pow(2, 32) |> round))

	use Application
		# See http://elixir-lang.org/docs/stable/elixir/Application.html
		# for more information on OTP Applications
		def start(_type, _args) do
		import Supervisor.Spec, warn: false

		children = [
		# Define workers and child supervisors to be supervised
		# worker(Cry.Worker, [arg1, arg2, arg3]),
		]

		# See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
		# for other strategies and supported options
		opts = [strategy: :one_for_one, name: Cry.Supervisor]
		Supervisor.start_link(children, opts)
	end

	def uniform do
		<<int::32>> = :crypto.strong_rand_bytes(4)
		(int + 0.5) * @flcon
	end

	def uniform(num) when (is_integer(num) and (num > 0)) do
		size = num |> :binary.encode_unsigned |> byte_size
		range = num + 1
		uniform_process(range, (:math.pow(2, size) |> round |> rem(range)), size)
	end
	defp uniform_process(range, limit, size) do
		case :crypto.strong_rand_bytes(size) |> :binary.decode_unsigned do
			good when (good >= limit) -> rem(good, range)
			_ ->
				IO.inspect({range, limit, size})
				uniform_process(range, limit, size)
		end
	end

end
