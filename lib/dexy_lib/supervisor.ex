defmodule DexyLib.Supervisor do

  defmacro __using__(opts \\ []) do
    app = opts[:otp_app] || throw :otp_app_required
    quote do
      def start_link (opts \\ nil) do
        opts = opts
          || Application.get_env(unquote(app), __MODULE__)[:options]
          || [name: __MODULE__, strategy: :one_for_one]
        Elixir.Supervisor.start_link(__MODULE__, _args = opts, opts)
      end

      def init opts do
        sup_name = opts[:name] || __MODULE__
        children = children(sup_name)
        opts = [strategy: opts[:strategy] || :one_for_one]
        Elixir.Supervisor.Spec.supervise(children, opts)
      end

      def members do
        Elixir.Supervisor.which_children(__MODULE__)
          |> Enum.map(fn {name, pid, _, _} -> {name, pid} end)
      end

      def children sup_name do
        children = Application.get_env(unquote(app), sup_name)[:children] || []
        for {type, spec} <- children do
          {mod, args, opts} = case spec do
            mod when is_atom(mod) -> {mod, [], []}
            {mod, args} -> {mod, args, []}
            {_mod, _args, _opts} = full_spec -> full_spec
          end
          apply Elixir.Supervisor.Spec, type, [mod, args, opts]
        end
      end

      def start_child type, module, args \\ [], opts \\ [] do
        child = apply(Elixir.Supervisor.Spec, type, [module, args, opts])
        Elixir.Supervisor.start_child(__MODULE__, child)
      end
    end # qutoe
  end # defmacro

end

