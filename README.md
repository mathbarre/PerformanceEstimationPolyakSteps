# PerformanceEstimationPolyakSteps
Code associated to the work [`reference`](https://arxiv.org/abs/2002.00915).

> [1] M. Barré, A. B. Taylor and A. d'Aspremont, "Complexity Guarantees for Polyak Steps with Momentum" arXiv:2002.00915, 2020.

Date:    February 3, 2020

#### Authors

- [**Mathieu Barré**](https://github.com/mathbarre/)
- [**Adrien Taylor**](https://www.di.ens.fr/~ataylor/)
- [**Alexandre d'Aspremont**](https://www.di.ens.fr/~aspremon/)

#### Requirements
- The [Mathematica](https://www.wolfram.com/mathematica/) notebooks in the proofs folder allow to easily verify some statements present in the paper's appendices.

- The Matlab code requires [YALMIP](https://yalmip.github.io/) along with a suitable SDP solver (e.g., Sedumi, SDPT3, Mosek).

- The Numerical experiements are presented in a [IJulia](https://github.com/JuliaLang/IJulia.jl) notebook, and require several Julia packages listed in the first cell of the notebook.
