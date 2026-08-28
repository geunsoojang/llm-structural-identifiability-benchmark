using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = lambda_birth - beta*S(t)*(I(t) + etaE*E(t) + etaQ*Q(t)) - omega_nat*S(t),
    E'(t) = beta*S(t)*(I(t) + etaE*E(t) + etaQ*Q(t)) - alpha*E(t) - omega_nat*E(t),
    I'(t) = alpha*E(t) - qI*I(t) - gammaI*I(t) - deltaI*I(t) - omega_nat*I(t),
    Q'(t) = qI*I(t) - gammaQ*Q(t) - deltaQ*Q(t) - omega_nat*Q(t),
    R'(t) = gammaI*I(t) + gammaQ*Q(t) - omega_nat*R(t),

    y1(t) = Q(t),
    y_lambda_birth(t) = lambda_birth,
    y_omega_nat(t) = omega_nat,
    y_alpha(t) = alpha,
    y_gammaI(t) = gammaI,
    y_deltaI(t) = deltaI,
    y_gammaQ(t) = gammaQ,
    y_deltaQ(t) = deltaQ
)

known_states = [S, E, I, Q, R]
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

run_case("model4_confirmed_prevalence unknown initial conditions", "model4_confirmed_prevalence_unknown_initial.txt")
run_case("model4_confirmed_prevalence known initial conditions", "model4_confirmed_prevalence_known_initial.txt", known_ic = known_states)