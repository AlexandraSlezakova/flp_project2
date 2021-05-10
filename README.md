
# Logical Project FLP 2020/2021

## Spanning tree
Author:  **Alexandra Slezáková (xsleza20)**

## Build
The project is compiled using the `swipl`  with the command `make` and program `flp20-log` is created.

## Run
When program is created, it can be run as follows:
```
$ ./flp20-log < input_file [> output_file]
```
The program reads standard input, the output is printed to stdout. 

The input graph is expected to be in the following format:
```
<V1> <V2>
...
```
where vertex is labelled with 1 uppercase letter of English alphabet (A-Z). 

## Description
Program checks if edges of given graph are in correct format.  The application ignores edges with different notation as mentioned above.  In case of disconnected graph, nothing is printed to stdout.
Otherwise,  edges are sorted, duplicates and self-loops are removed. The program creates lists of length (N - 1) of all combinations of edges, where N is number of vertices. Each list represents spanning tree and its properties are checked. A spanning tree does not have cycles, it cannot be disconnected and it has the same number of vertices as given graph.

## Tests
The application has been tested on a set of tests with a script `tester.sh` which can be found in folder `tests`. Tests can be run by executing `make tests`, to get the time of execution for each input file from `tests` folder, run `make time`. 

### Run time of input files 
| Filename      | Run time [s]  |
| ------------- | ------------- |
| test0.in      | 0.024         |
| test1.in      | 0.018         |
| test2.in      | 0.019         |
| test3.in      | 0.018         |
| test4.in      | 0.018         |
| test5.in      | 0.018         |
| test6.in      | 0.018         |
| test7.in      | 0.019         |
| test8.in      | 0.019         |
| test9.in      | 0.018         |
| test10.in     | 0.018         |
| test11.in     | 0.018         |
| test12.in     | 0.019         |
| test13.in     | 0.018         |
| test14.in     | 0.018         |
| test15.in     | 0.019         |
| test16.in     | 0.018         |
| test17.in     | 0.020         |
| test18.in     | 0.019         |
