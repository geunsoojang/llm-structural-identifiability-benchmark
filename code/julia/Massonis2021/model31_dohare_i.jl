using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# N is encoded as a constant output so it is treated as known. The paper uses
# S(0)=0.9N, E(0)=9(I0+A(0)), I(0)=I0, A(0)=I0*f, and J(0)=R(0)=0.
# We represent I0 by the initial value of I and f by the initial ratio A/I.
# The known_ic API accepts functions of states and parameters, which lets us
# retain the remaining initial-condition relationships.
ode = @ODEmodel(
    S'(t) = -alpha*(E(t) + I(t) + A(t))*S(t)/N - sigma*S(t),
    E'(t) = alpha*(E(t) + I(t) + A(t))*S(t)/N - beta1*E(t),
    I'(t) = beta1*h*E(t) + beta2*r*A(t) - phi*q*I(t) - gamma*(1 - q)*I(t),
    A'(t) = beta1*(1 - h)*E(t) - beta2*r*A(t) - gamma*(1 - r)*A(t),
    J'(t) = phi*q*I(t) - gamma*J(t),
    R'(t) = gamma*(1 - q)*I(t) + gamma*(1 - r)*A(t) + gamma*J(t),

    y1(t) = I(t),
    y_N(t) = N
)

known_initial_functions = [
    S,
    E - 9*(I + A),
    J,
    R,
]

targets = [
    alpha,
    sigma,
    h,
    r,
    q,
    beta1,
    beta2,
    phi,
    gamma,
    I,
    A // I,
]

target_labels = [
    "alpha",
    "sigma",
    "h",
    "r",
    "q",
    "beta1",
    "beta2",
    "phi",
    "gamma",
    "I0 (= I(0))",
    "f (= A(0)/I(0))",
]

println("Massonis SEIR model 31 Dohare output configuration 2 I")
println("Parameter-dependent initial-condition relationships enabled")
println()

result = assess_identifiability(
    ode,
    funcs_to_check = targets,
    known_ic = known_initial_functions,
    loglevel = Logging.Warn,
)

for (label, target) in zip(target_labels, targets)
    println(label, " => ", result[target])
end
println()

println("Identifiable functions under the same initial-condition assumptions")
functions_result = find_identifiable_functions(
    ode,
    known_ic = known_initial_functions,
    loglevel = Logging.Warn,
)
for fn in functions_result
    println(fn)
end
