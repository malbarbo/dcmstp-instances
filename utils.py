import math
import os
import sys


def read(f):
    vals = read_values(f)
    if f.startswith('target/instances/fixed/crd'):
        sys.stderr.write('reading crd\n')
        return read_crd(vals), None, 10000
    if f.startswith('target/instances/fixed/m') or f.startswith('instances/fixed/R'):
        sys.stderr.write('reading full matrix\n')
        return read_full_matrix(vals), None, 10000
    if f.startswith('target/instances/fixed/'):
        sys.stderr.write('reading lower row\n')
        return read_lower_row(vals), None, 1
    if f.startswith('target/instances/variable/ANDINST'):
        sys.stderr.write('reading ANDINST\n')
        return read_andinst(vals) + (1,)
    if f.startswith('target/instances/variable/'):
        sys.stderr.write('reading non ANDINST\n')
        return read_non_andinst(vals) + (1,)
    raise Exception('unknown format')


def read_crd(vals):
    vals = list(map(int, vals))
    n = len(vals) // 2
    x = vals[::2]
    y = vals[1::2]
    m = matrix(n)
    for i in range(0, n):
        for j in range(i, n):
            m[i][j] = math.hypot(x[i] - x[j], y[i] - y[j])
            m[j][i] = m[i][j]
    return m


def read_full_matrix(vals):
    vals = list(map(float, vals))
    n = int(math.sqrt(len(vals)))
    assert len(vals) == n * n
    return list(vals[i:i + n] for i in range(0, len(vals), n))


def read_lower_row(vals):
    vals = list(map(int, vals))
    n = int(1 + math.sqrt(1 + 8 * len(vals))) // 2
    assert n * (n - 1) == 2 * len(vals)
    k = 0
    m = matrix(n)
    for i in range(1, n):
        for j in range(i):
            m[i][j] = vals[k]
            m[j][i] = vals[k]
            k += 1
    return m


def read_andinst(vals):
    vals = list(map(int, vals))
    n = vals[0]
    m = vals[1]
    edges = vals[2:2 + 3 * m]
    degs = vals[2 + 3 * m:]
    M = matrix(n)
    for i in range(m):
        u = edges[3 * i + 0] - 1
        v = edges[3 * i + 1] - 1
        w = edges[3 * i + 2]
        M[u][v] = M[v][u] = w
    d = [None] * n
    for i in range(n):
        j = degs[2 * i + 0] - 1
        d[j] = degs[2 * i + 1]
    return M, d


def read_non_andinst(vals):
    assert vals[0] == '1'
    n = int(vals[1])
    m = int(vals[2])
    vals = list(map(int, vals[3:3 + n + m]))
    M = matrix(n)
    d = vals[:n]
    vals = vals[n:]
    for i in range(m):
        u = vals[3 * i + 0] - 1
        v = vals[3 * i + 1] - 1
        w = vals[3 * i + 2]
        M[u][v] = M[v][u] = w
    return M, d


def read_values(f):
    return list(open(f).read().split())


def write_tsp(f, m):
    print('TYPE : TSP', file=f)
    print('DIMENSION :', len(m), file=f)
    print('EDGE_WEIGHT_TYPE : EXPLICIT', file=f)
    print('EDGE_WEIGHT_FORMAT : FULL_MATRIX', file=f)
    print('EDGE_WEIGHT_SECTION', file=f)
    for line in m:
        print(
            ' '.join(map(str, ((0 if x == None else x) for x in line))), file=f)
    print('EOF', file=f)
    f.flush()


def matrix(n):
    return [[None] * n for _ in range(n)]


def add_dummy_vertex(m):
    n = len(m)
    mm = [[0] * (n + 1) for _ in range(n + 1)]
    for i in range(n):
        for j in range(n):
            mm[i][j] = m[i][j]
    return mm


def scale(m, s):
    for line in m:
        for i in range(len(line)):
            if line[i] != None:
                line[i] = int(line[i] * s)


def str_solution(sol):
    """
    >>> str_soltuion([(1, 2), (3, 4)])
    '1-2 3-4'
    """
    return ' '.join('{}-{}'.format(u, v) for u, v in sol)
