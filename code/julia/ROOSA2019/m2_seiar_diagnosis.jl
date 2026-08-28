using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -beta*S(t)*(I(t) + J(t) + q*A(t))/N,
    E'(t) = beta*S(t)*(I(t) + J(t) + q*A(t))/N - k*E(t),
    A'(t) = k*(1 - rho)*E(t) - gamma1*A(t),
    I'(t) = k*rho*E(t) - (alpha + gamma1)*I(t),
    J'(t) = alpha*I(t) - gamma2*J(t),
    R'(t) = gamma1*A(t) + gamma1*I(t) + gamma2*J(t),
    C'(t) = alpha*I(t),

    y1(t) = alpha*I(t),
    y2(t) = N
)

known_states = [S, E, A, I, J, R, C]
result_dir = joinpath(pwd(), "result")
mkpath(result_dir)

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

function run_case(label, filename; known_ic = nothing)
    out_file = joinpath(result_dir, filename)
    open(out_file, "w") do io
        redirect_stdout(io) do
            redirect_stderr(io) do
                println(label)
                println()

                println("assess_identifiability(ode)")
                elapsed = @elapsed begin
                    if known_ic === nothing
                        result = assess_identifiability(ode, loglevel = Logging.Warn)
                    else
                        result = assess_identifiability(ode, known_ic = known_ic, loglevel = Logging.Warn)
                    end
                    print_classification(result)
                end
                println()
                println("elapsed_seconds = ", elapsed)

                println()
                println("find_identifiable_functions(ode)")
                if known_ic === nothing
                    funcs = find_identifiable_functions(ode, loglevel = Logging.Warn)
                else
                    funcs = find_identifiable_functions(ode, known_ic = known_ic, loglevel = Logging.Warn)
                end
                print_functions(funcs)
            end
        end
    end
    println("saved: ", out_file)
end

run_case("m2_seiar_diagnosis unknown initial conditions", "m2_seiar_diagnosis_unknown_initial.txt")
run_case("m2_seiar_diagnosis known initial conditions", "m2_seiar_diagnosis_known_initial.txt", known_ic = known_states)