using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# Parameters omitted from the table's Parameters column are encoded as
# constant outputs so they are treated as known quantities.
# Table 2 gives fixed numerical initial conditions for all seven states.
# The known_ic call below treats them as known generic values only.
ode = @ODEmodel(
    S'(t) = -beta*S(t)*(I(t) + theta*A(t)) - p*S(t) + lambda*Q(t),
    E'(t) = beta*S(t)*(I(t) + theta*A(t)) - sigma*E(t),
    I'(t) = sigma*rho*E(t) - gamma_i*I(t) - d_i*I(t) - epsilon_i*I(t),
    A'(t) = sigma*(1 - rho)*E(t) - epsilon_a*A(t) - gamma_a*A(t),
    R'(t) = gamma_a*A(t) + gamma_i*I(t) + gamma_d*D(t),
    Q'(t) = p*S(t) - lambda*Q(t),
    D'(t) = epsilon_a*A(t) + epsilon_i*I(t) - d_d*D(t) - gamma_d*D(t),

    y1(t) = D(t)
)

known_states = [S, E, I, A, R, Q, D]

println("Massonis SEIR model 18 Jia output configuration 3 D: known generic initial conditions")
known_ic_result = assess_identifiability(
    ode,
    known_ic = known_states,
    loglevel = Logging.Warn,
)
show(stdout, "text/plain", known_ic_result)
println()
