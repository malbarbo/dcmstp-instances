A collections of scripts to download instances and solvers for the degree
constrained minimum spanning tree problem. It also provides an uniform
interface to run the solvers.

<!-- TODO: add problem definition -->
<!-- TODO: define project scope -->

## Setup

Clone this repository using the command

```
git clone https://github.com/malbarbo/dcmstp-instances
```

Before usage, it is necessary to download the solvers and instances. Some
solvers are available as binaries, while others need to be compiled from
source. To download (and build) all solvers these dependencies are necessary:
`make`, `curl`, `gcc`, `maven` and `jdk`. (In a Debian based system these
dependencies can be installed with the command: `apt-get install make curl gcc
maven openjdk-9-jdk-headless`)

After dependencies installation, execute the command `make` in project
directory. Solvers are download to `target/solvers` directory and instances are
download to `target/instances` directory.

To delete all solvers and instances, delete the `target` directory (Alert: to
avoid removing important files, never put any file in the `target` directory)


## Usage

The `solve` script provides an uniform interface to execute the solvers. For
example, to solve the `target/instances/variable/ANDINST/tb1ct100_1.txt` instance
with the solver `cgbc`, execute

```
./solve cgbc file target/instances/variable/ANDINST/tb1ct100_1.txt
```

To check if the produced solution is valid, redirect the output to a file and
execute the `check` script

```
./solve concorde 2 target/instances/variable/ANDINST/tb1ct100_1.txt > result
./check result
```

Note that some solvers does not print the solution, in this case, the solution
cannot be checked.

Running `./solve` in the project directory will show detailed usage
information.

<!-- Experiments -->


## Solvers

- [CG-BC, BCP and BCP-BC] from [3]

- [Choco] from [6]

- [Concorde] from [1] (can only be used when dc = 2)

- [LKH] from [7] (can only be used when dc = 2)

### Adding new solvers

Write a script and put it `solvers` directory. The script should accept as
a command line argument the instance file path and output to stdout tree lines,
the first contains the time in seconds used by the solver, the second contains
the value of the objective function and the third line the solution (like `1-2
3-4`, where `1-2` and `3-4` are edges of the tree). The script can write
logging information to stderr.

The script is responsible for converting the input file if necessary, calling
the real solver with the appropriated parameters, parsing the output of the
solver and printing the expected output. See the scripts in `solvers` directory
to see examples of how this can be done.

The input file is a text file that contains integers numbers. The first two
numbers are the number of vertices `n` and the number of edges `m`. The
following `3 * m` values are the edges. Each edge is represented by a pair of
numbers (vertices) in the range `[1, n]` followed by the weight. The last
`2 * n` values represents the degree constraint of each vertex (pairs of vertex
number followed by the degree constrain).

Ok, this format has some redundancies, like the vertex number in the degree
constraint section. Also if the graph is complete (all downloaded instances
are!) the end vertices of the edges are redundant. Anyway, this format was
chosen because it is already used by some solvers and it is easy to parse.

Example of input file with 4 vertices and 6 edges:

```
4 5
1 3 10
1 4 20
2 3 30
2 4 40
3 4 50
1 1
2 1
3 2
4 2
```

Vertices 1 and 2 has degree constraint of 1 and vertices 3 and 4 degree constraint of 2.


## Instances

- [CRD, SYM, STR and
  SHRD](https://turing.cs.hbg.psu.edu/txn131/file_instances/spanning_tree/SHRD-Graphs.tar.gz)
  instances from [9]

- [Misleading and
  R](https://turing.cs.hbg.psu.edu/txn131/file_instances/spanning_tree/IEEE-Graphs.tar.gz)
  instances from [8] and [10]

- [ANDINST, DE, DR, LH-E and
  LH-R](http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/allinstances.tar)
  instances from [2], [5] and [3]


<!-- Adding new instances -->


## References

1. D. L. Applegate, R. E. Bixby, V. Chvatál, and W. J. Cook, The Traveling
   Salesman Problem: A Computational Study. Princeton University Press, 2006.
   <http://www.jstor.org/stable/j.ctt7s8xg>

2. R. Andrade, A. Lucena, and N. Maculan, “Using Lagrangian dual information to
   generate degree constrained spanning trees,” Discrete Applied Mathematics,
   vol. 154, no. 5, pp. 703–717, Apr. 2006.
   <https://doi.org/10.1016/j.dam.2005.06.011>

3. L. H. Bicalho, A. S. da Cunha, and A. Lucena, “Branch-and-cut-and-price
   algorithms for the Degree Constrained Minimum Spanning Tree Problem,”
   Computational Optimization and Applications, vol. 63, no. 3, pp. 755–792,
   Apr. 2016. <https://doi.org/10.1007/s10589-015-9788-7>

4. T. N. Bui, X. Deng, and C. M. Zrncic, “An Improved Ant-Based Algorithm for
   the Degree-Constrained Minimum Spanning Tree Problem,” IEEE Transactions on
   Evolutionary Computation, vol. 16, no. 2, pp. 266–278, Apr. 2012.
   <https://doi.org/10.1109/TEVC.2011.2125971>

5. A. S. da Cunha and A. Lucena, “Lower and upper bounds for the
   degree-constrained minimum spanning tree problem,” Networks, vol. 50, no. 1,
   pp. 55–66, Aug. 2007. <https://doi.org/10.1002/net.20166>

6. J. G. Fages, X. Lorca, and L. M. Rousseau, “The salesman and the tree: the
   importance of search in CP,” Constraints, vol. 21, no. 2, pp. 145–162, Apr.
  2016. <https://doi.org/10.1007/s10601-014-9178-2>

7. K. Helsgaun, “General k-opt submoves for the Lin–Kernighan TSP heuristic,”
   Mathematical Programming Computation, vol. 1, no. 2–3, pp. 119–163, Oct.
   2009. <https://doi.org/10.1007/s12532-009-0004-6>

8. J. Knowles and D. Corne, “A new evolutionary approach to the
   degree-constrained minimum spanning tree problem,” IEEE Transactions on
   Evolutionary Computation, vol. 4, no. 2, pp. 125–134, Jul. 2000.
   <https://doi.org/10.1109/4235.850653>

9. M. Krishnamoorthy, A. T. Ernst, and Y. M. Sharaiha, “Comparison of
   Algorithms for the Degree Constrained Minimum Spanning Tree,” Journal of
   Heuristics, vol. 7, no. 6, pp. 587–611, Nov. 2001.
   <https://doi.org/10.1023/A:1011977126230>

10. G. R. Raidl and B. A. Julstrom, “Edge sets: an effective evolutionary
    coding of spanning trees,” IEEE Transactions on Evolutionary Computation,
    vol. 7, no. 3, pp. 225–239, Jun. 2003.
    <https://doi.org/10.1109/TEVC.2002.807275>

11. P. Martins and M. C. de Souza, “VNS and second order heuristics for the
    min-degree constrained minimum spanning tree problem,” Computers
    & Operations Research, vol. 36, no. 11, pp. 2969–2982, Nov. 2009.
    <https://doi.org/10.1016/j.cor.2009.01.013>


<!-- ## License -->

[CG-BC, BCP and BCP-BC]: http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/
[Choco]: https://github.com/malbarbo/dcmstp-choco
[Concorde]: http://www.math.uwaterloo.ca/tsp/concorde/index.html
[LKH]: http://www.akira.ruc.dk/~keld/research/LKH/
