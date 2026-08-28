using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -alpha - beta*(Ii+Is)/N,
    Ei'(t) = alpha - k*Ei,
    Ii'(t) = k*Ei - gamma*Ii,
    Es'(t) = -k*Es + beta*(Ii+Is)/N,
    Is'(t) = k*Es - gamma*Is,
    R'(t) = gamma*(Ii+Is),
    y1(t) = k*Ei,
    y2(t) = k*Es
)

known_states = [S, Ei, Ii, Es, Is, R]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model11_unknown_initial.txt")

function print_classification(result)
    for (quantity, classification) in result
        println(quantity, " => ", classification)
    end
end

function print_functions(functions)
    for f in functions
        println(f)
    end
end

open(out_file, "w") do io
    redirect_stdout(io) do
        redirect_stderr(io) do
            println("LIYANAGE2026 Model11_unknown_initial")
            println()

            println("assess_identifiability(ode)")
            elapsed = @elapsed begin
                result = assess_identifiability(ode, loglevel = Logging.Warn)
                print_classification(result)
            end
            println()
            println("elapsed_seconds = ", elapsed)

            println()
            println("find_identifiable_functions(ode)")
            funcs = find_identifiable_functions(ode, loglevel = Logging.Warn)
            print_functions(funcs)
        end
    end
end

println("saved: ", out_file)
