using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# Parameters omitted from the table's Parameters column are encoded as
# constant outputs so they are treated as known quantities.
# Table 2 uses parameter-dependent and zero initial conditions involving I0.
# StructuralIdentifiability.jl known_ic assumes generic values, so these are
# baseline analyses and do not reproduce the paper-specific IC constraints.
ode = @ODEmodel(
    S'(t) = -alpha*(E(t) + I(t) + A(t))*S(t)/N - sigma*S(t),
    E'(t) = alpha*(E(t) + I(t) + A(t))*S(t)/N - beta1*E(t),
    I'(t) = beta1*h*E(t) + beta2*r*A(t) - phi*q*I(t) - gamma*(1 - q)*I(t),
    A'(t) = beta1*(1 - h)*E(t) - beta2*r*A(t) - gamma*(1 - r)*A(t),
    J'(t) = phi*q*I(t) - gamma*J(t),
    R'(t) = gamma*(1 - q)*I(t) + gamma*(1 - r)*A(t) + gamma*J(t),

    y1(t) = I(t),
    y2(t) = J(t),
    y_N(t) = N
)

known_states = [S, E, I, A, J, R]

println("Massonis SEIR model 31 Dohare output configuration 1 I,J: known generic initial conditions")
known_ic_result = assess_identifiability(
    ode,
    known_ic = known_states,
    loglevel = Logging.Warn,
)
show(stdout, "text/plain", known_ic_result)
println()
