using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    E'(t) = (betap*Ip(t) + betaI*I(t))*(C1 - (E(t) + Ip(t) + (kp+gammap)*Y(t)/kp))/(C - D(t)),
    Ip'(t) = k*E(t) - kp*Ip(t) - gammap*Ip(t),
    I'(t) = kp*Ip(t) - gamma*I(t) - delta*I(t),
    D'(t) = delta*I(t),
    Y'(t) = kp*Ip(t),
    y1(t) = kp*Ip(t),
    y2(t) = Y(t)
)

known_states = [E, Ip, I, D]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model8a_known_initial.txt")

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
            println("LIYANAGE2026 Model8a_known_initial")
            println()

            println("assess_identifiability(ode)")
            elapsed = @elapsed begin
                result = assess_identifiability(ode, known_ic = known_states, loglevel = Logging.Warn)
                print_classification(result)
            end
            println()
            println("elapsed_seconds = ", elapsed)

            println()
            println("find_identifiable_functions(ode)")
            funcs = find_identifiable_functions(ode, known_ic = known_states, loglevel = Logging.Warn)
            print_functions(funcs)
        end
    end
end

println("saved: ", out_file)
