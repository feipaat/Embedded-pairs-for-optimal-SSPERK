Code for the numerical results

Reproducing Work-Precision figure
----------------------------------

The file `get_precision_work_diagram.m` is used to generate the work/precision figures.

For the report, the results used are stored in `pathMain = 'finalResults';`. The variable `testChoice = 'NewVsLiterature';` indicates that we want to generate the work/precision figures of the SSP pairs and known methods from the literature for comparison.

Reproducing Stepper Info tables
-------------------------------

`printGoodTable.m` generates the tables `Table 1, 2,3..` from the Numerical results report.



Directory Structure
-------------------

1. **controllerAlgorithms**: Contains the controller (IController, PIController, PIDController, and GustafssonController

2. **dataSaveNew**: This is where the results from the integration are first stored for analysis

3. **exactSolution**:The numerical reference solutions

4. **figs**: `get_precision_work_diagram.m` figures are stored here

5. **methods**: Embedded RK methods coefficients and loading functions

6. **problems**: ODE, Scalar PDE, and Euler codes

7. **stepper**: integrator, steppers, and anything that deals with step-size control

8. **utils**: functions needed for RHS evaluations, such as WENO and numerical flux
